if GameForUnit == nil then GameForUnit = class({}) end

function GameForUnit:OnGameRulesStateChange( keys )
    if   GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then 
         GameForUnit:OnGameRoundChange() 
    end    
end

function GameForUnit:OnGameRoundChange()
    
    print("_G.GAME_ROUND=".._G.GAME_ROUND)
    -- ---------------------------------每一轮开始打印上一局战绩-------
    -- -----------------------------------发送轮数消息给所有玩家-------
    
    for i=1,8 do 
        if  PlayerResource:GetPlayerCountForTeam( i +5 ) == 1 then 
            if _G.GAME_ROUND == 0 then--选主公

                local home_ent = Entities:FindByName(nil,"creep_birth_"..i.."_3"):GetOrigin()
                local zhugong  = CreateUnitByName("tower_zhugong",home_ent,false,nil,nil,i+5)
                table.foreach(FindUnitsInRadius(i+5,home_ent,nil,-1,1,1,0,0,false),function(_,v) if v:GetName()==SET_FORCE_HERO then zhugong:SetOwner(v) end end)
                               
            elseif _G.GAME_ROUND ==  1 
                or _G.GAME_ROUND ==  2
                or _G.GAME_ROUND ==  3  
                then--PVE
                for j=1,_G.GAME_ROUND*5 do ShuaGuai("npc_majia",nil,i,i) end
            else--pvp
                local Ts   = RandomInt(1,#_G.buildpostab) 
                local PosB = Entities:FindByName(nil,"tree_birth_"..i.."_1"):GetOrigin()
                table.foreach( _G.buildpostab[Ts],function(_,v) ShuaGuai(v.unit,PosB-v.origin,i,Ts) end)
            end
        end
    end

    if _G.GAME_ROUND == 0 then GameForUnit:OnGameInPlan() end
end

function GameForUnit:OnGameInPlan( ... )
    CustomNetTables:SetTableValue( "game_stat", "game_round_stat",{0} )
    local return_time= TIME_BETWEEN_ROUND 
    _G.GAME_ROUND    = _G.GAME_ROUND + 1

    -- 修长城
    for i=1,8 do
        --[[
        if  PlayerResource:GetSelectedHeroEntity(i-1) and not YOUR_IN_TEST then
            local caster  = PlayerResource:GetSelectedHeroEntity(i-1)
            local abiName = "skill_player_notplan"
            caster:RemoveAbility(abiName)
            caster:RemoveModifierByName("modifier_"..abiName)
        end]]

        if  PlayerResource:GetSelectedHeroEntity(i-1) then
            local startPos   =Entities:FindByName(nil,"tree_birth_"..i.."_0"):GetOrigin()
            local endPos     =Entities:FindByName(nil,"tree_birth_"..i.."_1"):GetOrigin()
            local pathlength =(startPos-endPos)/16
            for j=0,16 do
                local newPos = startPos - pathlength *j
                local zhalan = CreateUnitByName("build_zhalan",newPos,false,nil,nil,i +5)
            end

            local refreshupcount = _G.GAME_ROUND==1 and 10 or 5
            for R=1,refreshupcount do GetNewHero:UptoDJT(i-1,"shopUp",SET_FIRST_HERO) end
        end
    end
        -- ------------------如果有上一轮的位置和单位，按照保存创建单位---- 
    table.foreach(_G.buildpostab,function(i,p) 
    table.foreach(p,function(_,v) 
        if  v.unit and not v.unit:IsNull() then
            v.unit:Kill(nil,v.unit)
            Timer(0.1,function()
                v.unit:RespawnUnit()
                v.unit:SetOrigin(v.origin+Entities:FindByName(nil,"tree_birth_"..i.."_0"):GetOrigin()) 
                v.unit:SetHealth(v.unit:GetMaxHealth()) 
                v.unit:SetMana(v.unit:GetMaxMana()) 
            end)
            for q=0,10 do if v.unit:GetAbilityByIndex(q) then v.unit:GetAbilityByIndex(q):EndCooldown()end end
        end
    end)
    end)
    
    
    -- --------------做一个倒数，倒数结束后，记录当前所有单位的位置-----
    CustomNetTables:SetTableValue( "game_stat", "game_countdown",{countDown=true,timeMax=TIME_BETWEEN_ROUND,timeNow=return_time} )
    local TimeForPlan = Timer(function()
        if return_time == 5 then--lock
            CustomNetTables:SetTableValue( "game_stat", "game_round_stat",{1} )
            
            --全体防守加状态 (禁锢 缴械 无敌 沉默) 
            table.foreach(self:FindAllByKey("all"),function(_,v) 
                if v:IsMoving() then v:Stop() end
                local abiName = "skill_player_countdown"
                v:AddAbility(abiName)
                v:FindAbilityByName(abiName):SetLevel(1)
            end)

        elseif return_time == 4 then--mark
            for i=1,8 do
                if PlayerResource:GetPlayerCountForTeam( i +5 ) == 1 then 
                    local PosA   =Entities:FindByName(nil,"tree_birth_"..i.."_0"):GetOrigin()
                    local PosB   =Entities:FindByName(nil,"tree_birth_"..i.."_1"):GetOrigin()
                    local PosC   =Entities:FindByName(nil,"tree_birth_"..i.."_2"):GetOrigin()

                    local startPos   = Vector((PosC.x-PosB.x)/2+PosA.x,(PosC.y-PosB.y)/2+PosA.y,0)
                    local endPos     = Vector((PosC.x-PosB.x)/2+PosB.x,(PosC.y-PosB.y)/2+PosB.y,0)
                    local width      = math.sqrt( math.pow(PosC.x-PosB.x, 2)+ math.pow(PosC.y-PosB.y, 2) )
                    
                    _G.buildpostab[i]={}
                    table.foreach(FindUnitsInLine(i+5, startPos, endPos,nil, width, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL,0),function(k,v) 
                        if  v:GetName() ~= SET_FORCE_HERO then 
                            _G.buildpostab[i][k]={unit=v,origin=v:GetOrigin()-PosA}
                        end
                    end)
                end
            end

        elseif return_time == 3 then GameForUnit:OnGameRoundChange()
        elseif return_time == 2 then--forward
            table.foreach(self:FindAllByKey("all"),function(k,unit) 
                print(k,unit:GetUnitName())
                if  unit.enemy then
                    unit:FaceTowards(unit:GetAbsOrigin()+Vector(0,-1,0))
                else
                    unit:FaceTowards(unit:GetAbsOrigin()+Vector(0,1,0))
                end
            end)
        end
        
        if  return_time > 0  then 
            CustomNetTables:SetTableValue( "game_stat", "game_countdown",{countDown=true,timeMax=TIME_BETWEEN_ROUND,timeNow=return_time} )
            print("round countdown time:"..return_time)
            if not GameRules:IsGamePaused() then return_time=return_time-1 end
            return 1 
        else
            CustomNetTables:SetTableValue( "game_stat", "game_countdown",{countDown=false,timeMax=0,timeNow=0} )
            CustomNetTables:SetTableValue( "game_stat", "game_round_stat",{2} )
            
            --全体删状态 (禁锢 缴械 无敌 沉默) 
            table.foreach(self:FindAllByKey("all"),function(_,caster) 
                local abiName = "skill_player_countdown"
                caster:RemoveAbility(abiName)
                caster:RemoveModifierByName("modifier_"..abiName)
                --caster:RemoveModifierByName("modifier_"..abiName.."enemy")
            end)            
            
            for i=1,8 do
                if  PlayerResource:GetPlayerCountForTeam( i +5 ) == 1 then
                    local tBuff01 ={}--这一队的所有技能，带ship,去重
                    local tBuff02 ={}--这一队的激活的羁绊
                    local tTeamMate=FindUnitsInRadius( i +5, Vector(0,0,0), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )
                
                    table.foreach(tTeamMate,function(_,v)
                        for c = 0,10 do
                            if v:GetAbilityByIndex(c) then
                                local hAbi = v:GetAbilityByIndex(c) 
                                local intab =false
                                for _,modhad in pairs(tBuff01) do
                                    if hAbi:GetAbilityName() == modhad then intab =true break end
                                end
                                    if intab==false then table.insert(tBuff01,hAbi:GetAbilityName()) end
                            end
                        end
                    end)

                    table.foreach(tBuff01,function(_,v)
                        local modup = false
                        if tkShipList[v] then
                            local count = 0
                            local nedcount = 0 
                            table.foreach(tkShipList[v],function() nedcount=nedcount+1 end)
                            for _,heroneed in pairs(tkShipList[v]) do
                                for _,unit in pairs(tTeamMate) do 
                                    if unit:GetUnitName() == heroneed then count=count+1 break end
                                end
                                    if count == nedcount then modup=true break end
                            end 
                        end
                        
                        if modup == true then table.insert(tBuff02,v) end
                    end) 

                    table.foreach(tTeamMate,function(_,v)
                        table.foreach(tBuff02,function(_,abiname) 
                            if v:FindAbilityByName(abiname ) then
                                local hAbi = v:FindAbilityByName(abiname )
                                local modName = "Modifier_"..abiname
                                if hAbi:GetCaster():HasModifier(modName ) then RemoveModifierByName(modName) end
                                hAbi:ApplyDataDrivenModifier(hAbi:GetCaster(), hAbi:GetCaster(), modName, nil)
                                --print("tBuff02",hAbi:GetCaster():GetUnitName(),hAbi:GetCaster():HasModifier(modName ),modName )
                            end
                        end)
                    end)
                end
                --[[
                --加信使状态(沉默)
                if  PlayerResource:GetSelectedHeroEntity(i-1) and not YOUR_IN_TEST then
                    local caster  = PlayerResource:GetSelectedHeroEntity(i-1)
                    local abiName = "skill_player_notplan"
                    caster:AddAbility(abiName)
                    caster:FindAbilityByName(abiName):SetLevel(1)
                end]]
            end
            table.foreach(Entities:FindAllByName("npc_dota_fort"),function(_,v) v:Destroy() end)
        end
    end)

    TimeForBatter = Timer(TIME_BETWEEN_ROUND+1,function()
        if return_time<TIME_BATTER_MAX then
            if not GameRules:IsGamePaused() then return_time=return_time+1 end
            CustomNetTables:SetTableValue( "game_stat", "game_countdown",{countDown=true,timeMax=TIME_BATTER_MAX,timeNow=return_time} )
            print("batter countdown time:"..return_time)
            return 1 
        else
            table.foreach(self:FindAllByKey("enemy"),function(_,unit) unit:Kill(nil,unit) end)
            CustomNetTables:SetTableValue( "game_stat", "game_countdown",{countDown=false,timeMax=0,timeNow=0} )
        end
    end)
end

function GameForUnit:OnEntityKilled( keys )
    local killedUnit = EntIndexToHScript( keys.entindex_killed   ) 
    local killerUnit = EntIndexToHScript( keys.entindex_attacker ) 

    if  killedUnit.enemy then killedUnit:Destroy() 
        if #GameForUnit:FindAllByKey("enemy")==0  then RemoveTimer(TimeForBatter) GameForUnit:OnGameInPlan()  end
    end

    if  killerUnit~=killedUnit and killerUnit:GetName() == "npc_dota_building" then 
        local realKiller = PlayerResource:GetSelectedHeroEntity(killerUnit:GetPlayerOwnerID())--killerUnit:GetPlayerOwner():GetAssignedHero()
              realKiller:SetHealth( realKiller:GetHealth()-1 )
        if    realKiller:GetHealth() == 0 then 
              GameRules:MakeTeamLose( realKiller:GetTeamNumber() )
              killerUnit:Destroy()
        end
    end
end

function GameForUnit:ItemAddedToInventoryFilter( filterTable )  --控制物品被放入物品栏时的行为
    --[[
    if filterTable["item_entindex_const"] == nil                  --获得的物品
    or filterTable["inventory_parent_entindex_const"] == nil then --库存拥有者
        return true
    end


    print('ItemAddedToInventoryFilter',1)
    local hItem = EntIndexToHScript( filterTable["item_entindex_const"] )
    local hInvPar = EntIndexToHScript( filterTable["inventory_parent_entindex_const"] )--InventoryParent
    
    if  hItem:GetPurchaser() ~= hInvPar then--不是自己的元素装备不能拾起，下一帧掉落]]
    --[[   Timers(0.01,function()
            hInvPar:DropItemAtPositionImmediate( hItem, hInvPar:GetAbsOrigin() )
        end)]]
       --return false
     --[[  
    print('ItemAddedToInventoryFilter',2)
    end

    if  hItem ~= nil and hInvPar ~= nil 
    and string.find(hItem:GetAbilityName(),"hero")  
    and hInvPar:IsRealHero() then

        print('ItemAddedToInventoryFilter',3)
        GetNewHero:buy_wujiang( {id=hInvPar:GetPlayerOwnerID(),way=hItem:GetAbilityName(),back=true }) 

    end]]
    return true
end

function GameForUnit:OnNPCSpawned(keys )
    local  npc = EntIndexToHScript(keys.entindex)
    if npc:GetName()== "npc_dota_fort" 
    or npc:GetName()== "npc_dota_building" 
    or npc.bFirstSpawned then 
        return 
    end

    npc.bFirstSpawned = true

    if npc:GetName()==SET_FORCE_HERO then
        for i=0,15 do if npc:GetAbilityByIndex(i) ~= nil then  npc:GetAbilityByIndex(i):SetLevel(1) end end 

        npc.Ticket=PlayerResource:HasCustomGameTicketForPlayerID(npc:GetPlayerOwnerID())

        CustomUI:DynamicHud_Create(npc:GetPlayerID(),"psd","file://{resources}/layout/custom_game/uiscreen.xml",nil)
        CustomNetTables:SetTableValue( "Hero_Population", tostring(npc:GetPlayerID()),{popMax=LOCAL_POPLATION,popNow=0} ) 
        if GetMapName=="map0" then CustomGameEventManager:Send_ServerToTeam(npc:GetTeam(), "CameraRotateHorizontal", {angle=npc:GetPlayerID()*360/8}) end
    else
        local NameX = npc:GetUnitName()
        if _G.npcBaseType[NameX] then
            local attack_type = _G.npcBaseType[NameX][1] or "none"
            local defend_type = _G.npcBaseType[NameX][2] or "none"
            
            npc:AddNewModifier(npc, nil, "modifier_attack_" .. attack_type, {})
            npc:AddNewModifier(npc, nil, "modifier_defend_" .. defend_type, {})
            npc.popuse = tonumber(_G.npcBaseType[NameX][3]) or 1

        elseif npc:IsHero() then
            for k,v in pairs(tkHeroList)do
                if NameX==v.override_hero then NameX=k break end
            end
            local attack_type = tkHeroList[NameX]["TksAttackType"] or "none"
            local defend_type = tkHeroList[NameX]["TksDefendType"] or "none"
            
            npc:AddNewModifier(npc, nil, "modifier_attack_" .. attack_type, {})
            npc:AddNewModifier(npc, nil, "modifier_defend_" .. defend_type, {})
            npc.popuse = tonumber(tkHeroList[NameX]["TksPopUse"]) or 1
                            
            _G.npcBaseType[NameX]={}
            table.insert( _G.npcBaseType[NameX], attack_type )
            table.insert( _G.npcBaseType[NameX], defend_type )
            table.insert( _G.npcBaseType[NameX], npc.popuse  )
            
        elseif tkUnitList[NameX] then
            local attack_type = tkUnitList[NameX]["TksAttackType"] or "none"
            local defend_type = tkUnitList[NameX]["TksDefendType"] or "none"
            
            npc:AddNewModifier(npc, nil, "modifier_attack_" .. attack_type, {})
            npc:AddNewModifier(npc, nil, "modifier_defend_" .. defend_type, {})
            npc.popuse = tonumber(tkUnitList[NameX]["TksPopUse"]) or 1
                            
            _G.npcBaseType[NameX]={}
            table.insert( _G.npcBaseType[NameX], attack_type )
            table.insert( _G.npcBaseType[NameX], defend_type )
            table.insert( _G.npcBaseType[NameX], npc.popuse  )
            
        else print(NameX,"error create without kind") return
        end
        
        if not npc:GetPlayerOwner() then return end

        local tPop = CustomNetTables:GetTableValue( "Hero_Population", tostring(npc:GetPlayerOwnerID())) 
        tPop['popNow'] = tPop['popNow'] + npc.popuse  
        CustomNetTables:SetTableValue( "Hero_Population", tostring(npc:GetPlayerOwnerID()),tPop) 
    end

    print("[BAREBONES] NPC Spawned",npc:GetUnitName())
    
end

function GameForUnit:DamageFilter(filterTable)
    --[[
    table.foreach( filterTable,function(k,v)  print("Damage: " .. k .. " " .. tostring(v) ) end)

    Damage: entindex_attacker_const 388
    Damage: entindex_victim_const 339
    Damage: damagetype_const 1
    Damage: damage 0]]
    
    
    local victim_index   = filterTable["entindex_victim_const"]
    local attacker_index = filterTable["entindex_attacker_const"]
    if not victim_index or not attacker_index then return true end

    local victim  = EntIndexToHScript(victim_index)--被攻击单位
    local attacker= EntIndexToHScript(attacker_index)--攻击单位
    local damtype = filterTable["damagetype_const"]--伤害类型

    -- Physical attack damage filtering
    if damtype == DAMAGE_TYPE_PHYSICAL then
        --Post reduction
        
        if not _G.npcBaseType[attacker:GetUnitName()] or not _G.npcBaseType[victim:GetUnitName()] then return true end

        local attack_type = _G.npcBaseType[attacker:GetUnitName()][1] or "none"
        local defend_type = _G.npcBaseType[victim:GetUnitName()][2] or "none"

        if attack_type == "none" or defend_type == "none" then return true end

        local damage_multiplier = DamageKV[attack_type][defend_type] or 1

        -- print (attacker:GetUnitName() .. "(" .. attack_type .. ") vs " .. victim:GetUnitName() .. "(" .. defend_type .. "), damage multiplied by " .. damage_multiplier)
        -- Reassign the new damage
        filterTable["damage"] = filterTable["damage"] * damage_multiplier

    elseif damtype == DAMAGE_TYPE_MAGICAL then
        -- print("Magic Damage is happening: " .. filterTable["damage"])
        local damagePercent = 100
        local modi01 = "modifier_elementalbuilder_passive_thunder_negative_lua"
        local modi02 = "modifier_elementalbuilder_passive_thunder_lua"
        if victim:HasModifier(modi01) then
            local a = victim:GetModifierStackCount(modi01, victim)
            if a > 0 then damagePercent = damagePercent + a         end
        end
        if victim:HasModifier(modi02) then
            local a = victim:GetModifierStackCount(modi02, victim)
            if a > 0 then damagePercent = damagePercent - (a * 2)   end
        end
        if attacker:HasModifier(modi01) then
            local a = attacker:GetModifierStackCount(modi01, attacker)
            if a > 0 then damagePercent = damagePercent - a         end
        end
        if attacker:HasModifier(modi02) then
            local a = attacker:GetModifierStackCount(modi02, attacker)
            if a > 0 then damagePercent = damagePercent + (a * 2)   end
        end
        filterTable["damage"] = filterTable["damage"] * (damagePercent / 100.0)
    -- print("filtered magic damage: " .. filterTable["damage"] .. " (" .. damagePercent .. " percent)")
    end

    return true
end

function ShuaGuai( CreateName,origin,iTeam,iReTeam)
    local ShuaGuai_entity = Entities:FindByName(nil,"creep_birth_"..iTeam.."_0")
    local abiName = "skill_player_countdown"
    local vPos
    local vName
    if iTeam == iReTeam then iReTeam = DOTA_TEAM_BADGUYS end

    if origin == nil then
        vPos =ShuaGuai_entity:GetOrigin()
        vName=CreateName
    else
        vPos =origin
        vName=CreateName:GetUnitName()
    end 

    CreateUnitByNameAsync(vName,vPos,false,nil,nil,iReTeam,  function( v ) 
        v:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
        v:SetInitialGoalEntity( ShuaGuai_entity )
        --v:SetRequiresReachingEndPath(true)
        v:AddAbility(abiName)
        v:FindAbilityByName(abiName):SetLevel(1)
        v.enemy=true end)  
end

function GameForUnit:FindAllByKey(key)
    local rheroes = {}
    --local heroes  = {}
    if key=="creature" then
        return Entities:FindAllByName("npc_dota_creature")
    end

    if key=="enemy" then 
        table.foreach(Entities:FindAllByName("npc_dota_creature"),function(_,v)
            if  v.enemy and v:IsAlive() then table.insert(rheroes,v) end
        end)
        table.foreach(HeroList:GetAllHeroes(),function(_,v)
            if   v.enemy and v:IsAlive()  then table.insert(rheroes,v) end
        end)
        
        return rheroes
    end

    if key=="all" then
        rheroes=Entities:FindAllByName("npc_dota_creature")
        table.foreach(HeroList:GetAllHeroes(),function(_,v)
            if  v:GetName()~=SET_FORCE_HERO  then table.insert(rheroes,v) end
        end)

        
        return rheroes
    end

    if key=="allx" then---有个同队的没有name的实体无法排除
        
        table.foreach(Entities:FindAllInSphere(Vector(0,0,0), 99999),function(k,v)
            print(k,v)
            --if v:GetUnitName() then print(v:GetUnitName())
            --else
            if v:GetName() then print(v:GetName())
            end

            --v:getclass(instanceObj)
            --if v:IsPlayer() then print(v,"true") end
            if  v:GetTeam()~=4  and v:GetTeam()~=0 
            and v:GetName()~=SET_FORCE_HERO 
            and v:GetName()~="npc_dota_building"
            and v:GetName()~="npc_dota_fort" then
                table.insert(rheroes,v)
                print(k,v,v:GetTeam(),v:GetName(),v:GetClassname())
            end
        end)
        table.foreach(rheroes,function(c,s) print(c,s,s:GetTeam(),s:GetName()) end) --function(_,x) table.foreach(x,  end)
        return rheroes
    end
        --[[
    HeroList:GetAllHeroes()

    for i=1,#heroes do
        if heroes[i]:IsRealHero() then
            table.insert(rheroes,heroes[i])
        end
    end
    return rheroes]]
end