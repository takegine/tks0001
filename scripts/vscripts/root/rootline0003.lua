if GameForUnit == nil then GameForUnit = class({}) end

function GameForUnit:OnGameRoundChange()
    
    print("_G.GAME_ROUND=".._G.GAME_ROUND)
    
    for i=1,8 do 
        if  PlayerResource:GetPlayerCountForTeam( i +5 ) == 1 then
    
            if _G.GAME_ROUND == 0 then

                local home_ent = Entities:FindByName(nil,"creep_birth_"..i.."_3")
                --local owner   = Entities:FindByNameWithin(nil, SET_FORCE_HERO,home_ent:GetOrigin(), 999)
                local owner   = FindUnitsInRadius(i+5,home_ent:GetOrigin(),nil,-1,1,1,0,0,false) 
                local zhugong = CreateUnitByName("tower_zhugong",home_ent:GetOrigin(),false,nil,nil,i+5)
                for k,v in pairs(owner) do
                    if v:GetName()==SET_FORCE_HERO then zhugong:SetOwner(v) end
                end
                
                print("OnGameRoundChange",zhugong:GetPlayerOwnerID(),owner[1]:GetPlayerOwnerID())
                --zhugong:SetControllableByPlayer(owner[1]:GetPlayerOwnerID(),true)

                --print("OnGameRoundChange",zhugong:GetPlayerOwnerID())
                
            elseif _G.GAME_ROUND ==  1 
                or _G.GAME_ROUND ==  2
                or _G.GAME_ROUND ==  3  
                then 
                for j=1,_G.GAME_ROUND*5 do
                    ShuaGuai("npc_majia",nil,i,i) 
                end
            else 
                local Ts   = RandomInt(1,#_G.buildpostab) 
                local PosB =Entities:FindByName(nil,"tree_birth_"..i.."_1"):GetOrigin()
                for k,v in pairs(_G.buildpostab[Ts]) do
                    if _G.buildpostab[Ts][k]['unit'] then
                    local origin =PosB-_G.buildpostab[Ts][k]['origin']
                    ShuaGuai(_G.buildpostab[Ts][k]['unit'],origin,i,Ts)
                    end
                end 
            end
        end
    end

    if _G.GAME_ROUND == 0 then GameForUnit:OnGameInPlan()  end
end

function GameForUnit:OnGameInPlan( ... )
    CustomNetTables:SetTableValue( "game_stat", "game_round_stat",{0} )
    local return_time= TIME_BETWEEN_ROUND 
    
    local time_      = 1
    _G.GAME_ROUND    = _G.GAME_ROUND + 1

    
    for i=1,8 do
        if  PlayerResource:GetSelectedHeroEntity(i-1) and not YOUR_IN_TEST then
            local caster  = PlayerResource:GetSelectedHeroEntity(i-1)
            local abiName = "skill_player_notplan"
            caster:RemoveAbility(abiName)
            caster:RemoveModifierByName("modifier_"..abiName)
        end

        if  PlayerResource:GetPlayerCountForTeam( i +5 ) == 1 then
            local startPos   =Entities:FindByName(nil,"tree_birth_"..i.."_0"):GetOrigin()
            local endPos     =Entities:FindByName(nil,"tree_birth_"..i.."_1"):GetOrigin()
            local pathlength =(startPos-endPos)/16
            for j=0,16 do
                local newPos = startPos - pathlength *j
                local zhalan = CreateUnitByName("build_zhalan",newPos,false,nil,nil,i +5)
            end
        end
     end

    --[[
        local test1 = Entities:FindAllByName("npc_dota_creature")
        if test1 ~= nil and #test1 ~= 0 then
            for b=1,#test1 do  test1[b]:ForceKill(false)  end
    end]]
        
    --[[for i=1,8 do
        if type(_G.buildpostab[i]) ~= nil then
            for k,v in pairs(_G.buildpostab[i]) do
                --_G.buildpostab[i][k]['unit']:RespawnUnit()
            end
        end
    end]]
    for i,p in pairs(_G.buildpostab) do  
        for k,v in pairs(p) do           
            if  v['unit'] then
                if not v['unit']:IsNull() then

                    v['unit']:Kill(nil,v['unit'])

                    Timer(0.1,function()
                        v['unit']:RespawnUnit()
                        v['unit']:SetOrigin(v['origin']+Entities:FindByName(nil,"tree_birth_"..i.."_0"):GetOrigin()) 
                    end)
                    
                end
                
                --v['unit']:SetHealth(v['unit']:GetMaxHealth())            
                --v['unit']:SetMana(v['unit']:GetMaxMana())                
            end
        end
    end
     
    CustomNetTables:SetTableValue( "game_stat", "game_countdown",{countDown=true,timeMax=return_time,timeNow=return_time-time_} )
    local TimeForPlan = Timer(function()
        if  time_ <= return_time  then    
            if  return_time - time_ == 5  then
                CustomNetTables:SetTableValue( "game_stat", "game_round_stat",{1} )
                
                 
                local test1 = Entities:FindAllByName("npc_dota_creature")
                for _,unit in pairs(test1)do
                    local caster  = unit
                    local abiName = "skill_player_countdown"
                    caster:AddAbility(abiName)
                    caster:FindAbilityByName(abiName):SetLevel(1)
                end

                 
                for i=1,8 do
                    if PlayerResource:GetPlayerCountForTeam( i +5 ) == 1 then 
                        local PosA   =Entities:FindByName(nil,"tree_birth_"..i.."_0"):GetOrigin()
                        local PosB   =Entities:FindByName(nil,"tree_birth_"..i.."_1"):GetOrigin()
                        local PosC   =Entities:FindByName(nil,"tree_birth_"..i.."_2"):GetOrigin()

                        local startPos   = Vector((PosC.x-PosB.x)/2+PosA.x,(PosC.y-PosB.y)/2+PosA.y,0)
                        local endPos     = Vector((PosC.x-PosB.x)/2+PosB.x,(PosC.y-PosB.y)/2+PosB.y,0)
                        local width      = math.sqrt( math.pow(PosC.x-PosB.x, 2)+ math.pow(PosC.y-PosB.y, 2) )

                        local mybuildstab= FindUnitsInLine(i+5, startPos, endPos,nil, width, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL,0)
                        
                        _G.buildpostab[i]={}
                        for k,v in pairs(mybuildstab) do
                            _G.buildpostab[i][k]={}
                            --local modifs = v:FindAllModifiers()  
                            --for b=1, #modifs do  modifs[b]:ForceRefresh()  end

                            if v:GetName() == "npc_dota_creature" then
                                --print(v:GetAbsOrigin())
                                --print(v:GetOrigin())
                                --local newpos2 = Vector(v:GetOrigin().x-PosA.x,v:GetOrigin().y-PosA.y,0)
                                local newpos = v:GetOrigin()-PosA
                                v:SetUnitCanRespawn(true)
                                _G.buildpostab[i][k]['unit']  =v
                                _G.buildpostab[i][k]['origin']=newpos
                                --print(k,v:GetUnitName(),v:UnitCanRespawn())
                            end
                        end
                    end
                end
                
            end

            if return_time - time_ == 3  then
                GameForUnit:OnGameRoundChange()
 
                local test1 = Entities:FindAllByName("npc_dota_creature")
                for _,unit in pairs(test1)do
                    if unit.enemy then--if unit:GetTeam() == 3 then
                        local caster  = unit
                        local abiName = "skill_player_countdown"
                        caster:AddAbility(abiName)
                        caster:FindAbilityByName(abiName):SetLevel(1)
                        caster:FaceTowards(caster:GetAbsOrigin()+Vector(0,-1,0))
                    else
                        unit:FaceTowards(unit:GetAbsOrigin()+Vector(0,1,0))
                    end
                end
            end

            CustomNetTables:SetTableValue( "game_stat", "game_countdown",{countDown=true,timeMax=return_time,timeNow=return_time-time_} )
            print("round countdown time_--"..time_)
            if not GameRules:IsGamePaused() then time_=time_+1 end 
            
            return 1  
        else
            CustomNetTables:SetTableValue( "game_stat", "game_countdown",{countDown=false,timeMax=0,timeNow=0} )
            CustomNetTables:SetTableValue( "game_stat", "game_round_stat",{2} )
             
            local test1 = Entities:FindAllByName("npc_dota_creature")
            for _,unit in pairs(test1)do
                local caster  = unit
                local abiName = "skill_player_countdown"
                caster:RemoveAbility(abiName)
                caster:RemoveModifierByName("modifier_"..abiName)
                caster:RemoveModifierByName("modifier_"..abiName.."enemy")
            end
             
            for i=1,8 do
                if  PlayerResource:GetPlayerCountForTeam( i +5 ) == 1 then
                --and PlayerResource:GetConnectionState(unit:GetPlayerOwnerID()) == 2 then
                    local tBuff01 ={} 
                    local tBuff02 ={} 
                    local tTeamMate=FindUnitsInRadius( i +5, Entities:FindByName(nil,"creep_birth_"..i.."_3"):GetOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )
                 
                    for _,unit in pairs(tTeamMate) do
                        for c = 0,10 do
                            if unit:GetAbilityByIndex(c) then
                                --print("000000",c,unit:GetAbilityByIndex(c):GetAbilityName())
                                local hAbi = unit:GetAbilityByIndex(c)
                                --if  string.find(hAbi:GetAbilityName(),"ship") then
                                    if #tBuff01 == 0 then table.insert(tBuff01,hAbi:GetAbilityName())
                                    else 
                                        local intab =false
                                        for _,modhad in pairs(tBuff01) do
                                            if hAbi:GetAbilityName() == modhad then intab =true break end
                                        end
                                        if intab ==false then table.insert(tBuff01,hAbi:GetAbilityName()) end
                                    end
                                --end
                            end
                        end
                    end
                    --print("buff01 is over",#tBuff01,tBuff01[1]:GetAbilityName())
                 
                    for _,modhad in pairs(tBuff01) do
                        local modup = false

                        for ship, info in pairs(tkShipList) do
                            if modhad == ship then
                                local count = 0
                                local nedcount = 0
                                for _,heroneed in pairs(info) do
                                    nedcount=nedcount+1
                                end
                                for _,heroneed in pairs(info) do
                                    for _,unit in pairs(tTeamMate) do
                                        --print("222222",heroneed,unit:GetUnitName(),count,nedcount,#info,#tkShipList,table.getn(info))
                                        if unit:GetUnitName() == heroneed then count=count+1 break end
                                    end
                                    if count == nedcount then modup = true break end
                                end
                            end 
                        end
                        
                        if modup == true then table.insert(tBuff02,modhad) end
                    end
                    --print("buff02 is over",#tBuff02,#tTeamMate,tBuff02[1]:GetAbilityName())
                 
                    --[[for _,unit in pairs(tTeamMate) do
                        for c = 0,10 do
                            if unit:GetAbilityByIndex(c) then
                                local hAbi = unit:GetAbilityByIndex(c)
                                for _,modup in pairs(tBuff02) do
                                if hAbi == modup then
                                    local modName = "Modifier_"..hAbi:GetAbilityName() 
                                    if hAbi:GetCaster():HasModifier(modName ) then RemoveModifierByName(modName) end
                                    hAbi:ApplyDataDrivenModifier(hAbi:GetCaster(), hAbi:GetCaster(), modName, nil)
                                    print(hAbi:GetCaster():GetUnitName(),hAbi:GetCaster():HasModifier(modName ),modName )
                                    break
                                end
                                end
                            end
                        end
                    end]]

                    for _,unit in pairs(tTeamMate) do
                        for _,abiname in pairs(tBuff02) do
                            if unit:FindAbilityByName(abiname ) then
                                local hAbi = unit:FindAbilityByName(abiname )
                                local modName = "Modifier_"..abiname
                                if hAbi:GetCaster():HasModifier(modName ) then RemoveModifierByName(modName) end
                                hAbi:ApplyDataDrivenModifier(hAbi:GetCaster(), hAbi:GetCaster(), modName, nil)
                                print("tBuff02",hAbi:GetCaster():GetUnitName(),hAbi:GetCaster():HasModifier(modName ),modName )
                            end
                        end
                    end
                end 
                if  PlayerResource:GetSelectedHeroEntity(i-1) and not YOUR_IN_TEST then
                    local caster  = PlayerResource:GetSelectedHeroEntity(i-1)
                    local abiName = "skill_player_notplan"
                    caster:AddAbility(abiName)
                    caster:FindAbilityByName(abiName):SetLevel(1)
                end
            end
            --[[local test1 = Entities:FindAllByName("npc_dota_creature")
                for _,v in pairs(test1) do         
                print("refresh all modifiers on hero")
                if PlayerResource:GetConnectionState(v:GetPlayerOwnerID()) == 2 then
                    local modifs = v:FindAllModifiers()  
                    for b=1, #modifs do
                        if  modifs[b]:GetAbility() ~= nil then
                            if   modifs[b].needupwawe then
                                 modifs[b]:OnWaweChange()
                            else modifs[b]:ForceRefresh() 
                            end
                        end
                    end
                end
            end]] 

            local zhalanTab = Entities:FindAllByName("npc_dota_fort")
            for k,v in pairs(zhalanTab) do  zhalanTab[k]:Destroy()  end
            
    
            
        end
    end)
end

function GameForUnit:OnEntityKilled( keys )
    local killedUnit = EntIndexToHScript( keys.entindex_killed ) 
    local killerUnit = EntIndexToHScript( keys.entindex_attacker ) 
    local plc = PlayerResource:GetPlayerCount() 
 
    --if  killedUnit:GetTeam() == DOTA_TEAM_BADGUYS and killedUnit:GetName() == "npc_dota_creature" then
    if  killedUnit.enemy then
        killedUnit:Destroy() 

        local test1 = Entities:FindAllByName("npc_dota_creature")
        print("num of enemy isalive.."..#test1)
        
        local nextwave = true

        if test1 ~= nil and #test1 ~= 0 then                     
            for b=1,#test1 do
                --if  test1[b]:GetTeam() == DOTA_TEAM_BADGUYS and test1[b]:IsAlive() == true then  
                if  test1[b].enemy and test1[b]:IsAlive() then    
                    nextwave = false
                end
            end
        end
        if   nextwave == true then GameForUnit:OnGameInPlan()  end  
    end

    if  killerUnit:GetName() == "npc_dota_building" then
        --print(killerUnit:GetTeamNumber() ,killerUnit:GetPlayerOwnerID(),killerUnit:GetPlayerOwner():GetAssignedHero():GetName())
        
        local realKiller = PlayerResource:GetSelectedHeroEntity(killerUnit:GetPlayerOwnerID())--killerUnit:GetPlayerOwner():GetAssignedHero()--
        --print(realKiller:GetTeamNumber() ,realKiller:GetPlayerOwnerID())
        --local owner   = FindUnitsInRadius(killerUnit:GetTeamNumber(),killerUnit:GetOrigin(),nil,-1,0,1,0,0,false) 
        --for k,v in pairs(owner) do
        --    print(k,v)
        --end
        
        realKiller:SetHealth( realKiller:GetHealth()-1 ) 
        --print(killerUnit:GetHealth())
        if  realKiller:GetHealth() == 0 then 
            GameRules:MakeTeamLose( realKiller:GetTeamNumber() )
            killerUnit:Destroy()
        end
    end
end

function GameForUnit:ItemAddedToInventoryFilter( filterTable )   
    if filterTable["item_entindex_const"] == nil                   
    or filterTable["inventory_parent_entindex_const"] == nil then  
        return true
    end

    local hItem = EntIndexToHScript( filterTable["item_entindex_const"] )
    local hInvPar = EntIndexToHScript( filterTable["inventory_parent_entindex_const"] )--InventoryParent
    
    if  hItem:GetPurchaser() ~= hInvPar then 
    --[[   Timers(0.01,function()
            hInvPar:DropItemAtPositionImmediate( hItem, hInvPar:GetAbsOrigin() )
        end)]]
       --return false
    end

    if  hItem ~= nil and hInvPar ~= nil 
    and string.find(hItem:GetAbilityName(),"hero")  
    and hInvPar:IsRealHero() then

        GetNewHero:buy_wujiang( {id=hInvPar:GetPlayerOwnerID(),way=hItem:GetAbilityName(),back=true }) 

    end
    return true
end

function GameForUnit:OnNPCSpawned(keys )
    local  npc = EntIndexToHScript(keys.entindex)
    if npc:GetName()== "npc_dota_fort" or npc.enemy then return end


    print("[BAREBONES] NPC Spawned",npc:GetUnitName())

    if  npc.bFirstSpawned == nil then
        npc.bFirstSpawned = true
        if npc:IsRealHero() then
            CustomUI:DynamicHud_Create(npc:GetPlayerID(),"psd","file://{resources}/layout/custom_game/uiscreen.xml",nil)
            for i=0,15 do
                if npc:GetAbilityByIndex(i) ~= nil then  npc:GetAbilityByIndex(i):SetLevel(1) end
            end
            --npc.population = LOCAL_POPLATION
            --npc.popnow     = 0
            CustomNetTables:SetTableValue( "Hero_Population", tostring(npc:GetPlayerID()),{popMax=LOCAL_POPLATION,popNow=0} )
            --CustomGameEventManager:Send_ServerToPlayer( npc:GetPlayerOwner(), "populationCreate", {Population=npc.population,Popnow=npc.popnow} )
            --print("populationCreate",npc.popnow,npc.population)

            --for _,v in pairs(_G._G.ItemHeroName)do
                --print(k,v)
            --    CustomGameEventManager:Send_ServerToAllClients('hero_info', {name=v})
            --end
        else
            if _G.npcBaseType[npc:GetUnitName()] then
                local attack_type = _G.npcBaseType[npc:GetUnitName()][1] or "none"
                local defend_type = _G.npcBaseType[npc:GetUnitName()][2] or "none"
                --print ("unit spawned with " .. attack_type .. "/" .. defend_type)
                npc:AddNewModifier(npc, nil, "modifier_attack_" .. attack_type, {})
                npc:AddNewModifier(npc, nil, "modifier_defend_" .. defend_type, {})
                npc.popuse = tonumber(_G.npcBaseType[npc:GetUnitName()][3]) or 1

            elseif tkHeroList[npc:GetUnitName()] then
                local NameX = npc:GetUnitName()
                local attack_type = tkHeroList[NameX]["TksAttackType"] or "none"
                local defend_type = tkHeroList[NameX]["TksDefendType"] or "none"
                --print ("unit spawned with " .. attack_type .. "/" .. defend_type)
                npc:AddNewModifier(npc, nil, "modifier_attack_" .. attack_type, {})
                npc:AddNewModifier(npc, nil, "modifier_defend_" .. defend_type, {})
                npc.popuse = tonumber(tkHeroList[NameX]["TksDefendType"]) or 1

                --table.insert( _G.npcBaseType, tostring(npc:GetUnitName()) )
                
                _G.npcBaseType[NameX]={}
                table.insert( _G.npcBaseType[NameX], attack_type )
                table.insert( _G.npcBaseType[NameX], defend_type )
                table.insert( _G.npcBaseType[NameX], npc.popuse  )

                --for k,v in pairs(npc:FindAllModifiers()) do print("NPC Spawned",k,v:GetName()) end
                --for k,v in pairs(_G.npcBaseType) do print("NPC Spawned",k,v[1]) end
            end
        end
    end
end

function GameForUnit:playerGetCountry( data )
    local hero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)

    if  data.country == 5 then 
        data.country = RandomInt(1,4) 
        hero:SetGold( PlayerResource:GetUnreliableGold(data.PlayerID) + 200 , false) 
    end

    if data.country == 4 then hero.country = "qunxiong" 
    elseif data.country == 1 then hero.country = "shuguo"
    elseif data.country == 2 then hero.country = "wuguo"
    elseif data.country == 3 then hero.country = "weiguo"
    end
    --CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(PlayID), "wujiang_shopUp", {event=itemName} )
    --CustomUI:DynamicHud_Create(data.PlayerID,"psd","file://{resources}/layout/custom_game/uiscreen.xml",{country=hero.country})
    local unitID   = RandomInt(1,#_G.tkHeroName[hero.country])
    local unitName = _G.tkHeroName[hero.country][unitID]
    local itemName = string.gsub(unitName,"npc","item")
    GetNewHero:buy_wujiang( {id=data.PlayerID,way=itemName,back=false }) 

    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(data.PlayerID), "playergetcountry", {event=hero.country} )
    print("playerGetCountry",hero.country)
    --table.insert(playerallstart,data.PlayerID)
    --if  PlayerResource:GetPlayerCount() == #playerallstart then
    --    GameForUnit:OnGameRoundChange()
    --end
end

function GameForUnit:DamageFilter(filterTable)
    --[[
    for k, v in pairs( filterTable ) do
    	print("Damage: " .. k .. " " .. tostring(v) )
    end
    Damage: entindex_attacker_const 388
    Damage: entindex_victim_const 339
    Damage: damagetype_const 1
    Damage: damage 0]]
    
    
    local victim_index   = filterTable["entindex_victim_const"]
    local attacker_index = filterTable["entindex_attacker_const"]
    if not victim_index or not attacker_index then return true end

    local victim  = EntIndexToHScript(victim_index) 
    local attacker= EntIndexToHScript(attacker_index) 
    local damtype = filterTable["damagetype_const"] 
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
    local ShuaGuai = CreateUnitByName(vName,vPos,false,nil,nil,iReTeam) 
    ShuaGuai:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
    --ShuaGuai:SetMustReachEachGoalEntity(true)
    ShuaGuai:SetInitialGoalEntity( ShuaGuai_entity )
    ShuaGuai:SetRequiresReachingEndPath(true)
    ShuaGuai.enemy =true
    --ShuaGuai:SetControllableByPlayer(0,true)
    --ShuaGuai:SetOwner( PlayerResource:GetPlayer(0) )--PlayerResource:GetSelectedHeroEntity(0)
end

function GameForUnit:OnGameRulesStateChange( keys )
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then GameForUnit:OnGameRoundChange() end
    --[[print ("print  OnGameRulesStateChange is running.")
           --DeepPrintTable(keys)    --详细打印传递进来的表
    local newState = GameRules:State_Get() --获取当前游戏阶段

    if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
            print("Player begin select team") --玩家处于选择队伍 
    elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then    
            print("Player begin select hero")  --玩家处于选择英雄界面


    elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
            print("Player in befor game")  --进游戏直到倒数结束
            --
            --CreateHeroForPlayer(string unitName, handle player)

            --CreateUnitByName(npc_creature_0,Entities:FindByName(nil,"playerlocal_1"):GetOrigin(),false,nil,nil,DOTA_TEAM_CUSTOM_1)

    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
            print("Player game begin")  --玩家开始游戏
            
            
            print("Player---- OnGameRoundChange endding")  --玩家开始游戏
            GameForUnit:OnGameRoundChange()
            

    elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then

    elseif newState == DOTA_GAMERULES_STATE_POST_GAME then
            print("Player are show case")  --游戏结束
    end]]
end

