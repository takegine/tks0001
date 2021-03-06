if GameForUnit == nil then GameForUnit = class({}) end

function GameForUnit:OnGameRulesStateChange( keys )
    if   GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        Timer(1,function() GameForUnit:OnGameRoundChange() end)
    end
end

function GameForUnit:OnGameRoundChange()

    print("_G.GAME_ROUND=".._G.GAME_ROUND)

    CustomNetTables:SetTableValue( "game_stat", "game_round_stat",{0} )
    local return_time= TIME_BETWEEN_ROUND
    local lock = 'skill_player_lock'
    _G.GAME_ROUND    = _G.GAME_ROUND + 1

    -- greatwall
    for i=1,8 do
        if PlayerResource:GetPlayerCountForTeam( i +5 ) == 1 then
            local startPos   =Entities:FindByName(nil,"tree_birth_"..i.."_0"):GetOrigin()
            local endPos     =Entities:FindByName(nil,"tree_birth_"..i.."_1"):GetOrigin()
            local pathlength =(startPos-endPos)/16
            for j=0,16 do
                local newPos = startPos - pathlength *j
                local zhalan = CreateUnitByName("build_zhalan",newPos,false,nil,nil,i +5)
            end

            local refreshupcount = _G.GAME_ROUND==1 and 10 or 5
            local hero = Entities:GetPlayer(i+5)
            for R=1,refreshupcount do GetNewHero:UptoDJT(hero:GetPlayerID(),"shopUp",SET_FIRST_HERO) end

            hero.ship={}
        end
    end
        -- ------------------复位----

    table.foreach(Entities:FindAllByTeam( 1 ),function(_,v)

        if v.bench then
            v:RemoveModifierByName( lock..'_plan')
        elseif not v:HasModifier(lock..'_battle') then
            v:Destroy()
        end
    end)
    table.foreach(_G.buildpostab,function(i,p)
        table.foreach(p,function(_,v)
            if  v.unit and not v.unit:IsNull() then
                --if not v.unit:IsAlive() then v.unit:RespawnUnit() end
                --v.unit:Kill(nil,v.unit)
                --Timer(0.1,function()
                    --v.unit:RespawnUnit()
                    v.unit:RemoveModifierByName( lock..'_battle')
                    v.unit:SetOrigin(v.origin+Entities:Pos(i, 2) )
                    --v.unit:SetHealth(v.unit:GetMaxHealth())
                    --v.unit:SetMana(v.unit:GetMaxMana())
                --end)
                --for q=0,10 do if v.unit:GetAbilityByIndex(q) then v.unit:GetAbilityByIndex(q):EndCooldown()end end
            end
        end)
    end)

    CustomNetTables:SetTableValue( "game_stat", "game_countdown",{ countDown=true, timeMax=TIME_BETWEEN_ROUND, timeNow=return_time} )
    local TimeForPlan = Timer(function()
        if return_time == 5 then--lock
            CustomNetTables:SetTableValue( "game_stat", "game_round_stat",{1} )
            local defendlist = Entities:FindAllByTeam( 1 )

            if   PlayerResource:GetPlayerCount() == 1
            and  not tkRounList[tostring(_G.GAME_ROUND)]
            then local benchcount = 0

                table.foreach(defendlist,function(_,v)
                    if v.bench then
                        benchcount = benchcount + 1
                    end
                end)

                if #defendlist == benchcount then
                    GameForUnit:OnGameRoundChange( )
                    return
                end
            end

            --全体防守加状态 (禁锢 缴械 无敌 沉默)
            table.foreach(defendlist,function(_,u)
                if u:IsMoving() then u:Stop() end
                u:FindAbilityByName(lock):ApplyDataDrivenModifier(u, u, lock..'_plan', nil)

            end)

        elseif return_time == 4 then--mark

            for i=1,8 do
                if PlayerResource:GetPlayerCountForTeam( i +5 ) == 1 then
                    _G.buildpostab[i]={}
                    table.foreach(Entities:FindAllByTeam( 1, i),function(k,u)
                        if not u.bench then
                            _G.buildpostab[i][k]={unit=u, origin=u:GetOrigin()-Entities:Pos(i,2), lvl=u:GetLevel()}
                            local hero = Entities:GetPlayer(i +5 )

                            --Timer(1, function()
                            CreateUnitByNameAsync( u:GetUnitName(), u:GetOrigin(), true,hero,hero, u:GetTeamNumber(), function( v )
                                v:CheckLevel(u:GetLevel())
                                v:SetUnitCanRespawn(false)
                                v:SetPlayer(u:GetTeamNumber())
                            end)
                            --end)

                            u:FindAbilityByName(lock):ApplyDataDrivenModifier(u, u, lock..'_battle', nil)
                            u:SetOrigin(Entities:Pos(i,3)+Vector(0, 0, -999) )
                        end
                    end)
                end
            end

        elseif return_time == 3 then--copy

            for i=1,8 do
                if  PlayerResource:GetPlayerCountForTeam( i +5 ) == 1 then


                    if  tkRounList[tostring(_G.GAME_ROUND)] then
                        table.foreach( tkRounList[tostring(_G.GAME_ROUND)],function(_,v) ShuaGuai(v.unit,nil,v.lvl,i,i) end)

                    else
                        local Ts   = RandomInt(1,#_G.buildpostab)
                        while not _G.buildpostab[Ts] do Ts = RandomInt(1,#_G.buildpostab) end
                        --local PosB = Entities:FindByName(nil,"creep_birth_"..i.."_1"):GetOrigin()
                        table.foreach( _G.buildpostab[Ts],function(_,v) ShuaGuai(v.unit:GetUnitName(),Entities:Pos(i,1)-v.origin,v.lvl,i,Ts) end)
                    end
                end
            end

        elseif return_time == 2 then--forward
            table.foreach(Entities:FindAllByTeam(),function(k,u)
                if  u.enemy or u.bench then
                    u:FaceTowards(u:GetAbsOrigin()+Vector(0,-1,0))
                else u:FaceTowards(u:GetAbsOrigin()+Vector(0,1,0))
                end
            end)
        end

        if  return_time > 0  then
            CustomNetTables:SetTableValue( "game_stat", "game_countdown",{countDown=true,timeMax=TIME_BETWEEN_ROUND,timeNow=return_time} )
            print("countdown round  time:"..return_time)
            if not GameRules:IsGamePaused() then return_time=return_time-1 end
            return 1
        else
            CustomNetTables:SetTableValue( "game_stat", "game_countdown",{countDown=false,timeMax=0,timeNow=0} )
            CustomNetTables:SetTableValue( "game_stat", "game_round_stat",{2} )

            --全体删状态 (禁锢 缴械 无敌 沉默)
            table.foreach(Entities:FindAllByTeam(),function(_,caster)
                -- local abiName = "skill_player_countdown"
                -- caster:RemoveAbility(abiName)
                -- print(caster:GetName(), caster:HasModifier("modifier_"..abiName))
                if not caster.bench then
                caster:RemoveModifierByName( lock..'_plan' )
                end
                --caster:RemoveModifierByName("modifier_"..abiName.."enemy")
            end)

            for i=1,8 do
                if  PlayerResource:GetPlayerCountForTeam( i +5 ) == 1 then
                    local tBuff01 ={}--这一队的所有技能，带ship,去重
                    local tBuff02 ={}--这一队的激活的羁绊
                    local tTeamMate=Entities:FindAllByTeam(1,i)
                    --FindUnitsInRadius( i +5, Vector(0,0,0), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false )

                    table.foreach(tkShipList,function(s,n)

                        local modup = false
                        local count = 0
                        local needcount = #n >2 and table.foreach(tTeamMate,function(_,u) if u:GetUnitName() == '神吕蒙' then return true end end) and #n-1 or #n
                        table.foreach(n,function(_,unit)

                            local usedunit = {}
                            for _,u in pairs(tTeamMate) do

                                local used = false
                                for _,d in pairs(usedunit) do
                                    if d==u then
                                        used = true
                                        break
                                    end
                                end

                                if not used and u:GetUnitName() == unit then
                                    table.insert(usedunit,u)
                                    count=count+1
                                    break
                                end
                            end

                            if count >= needcount then
                                modup=true
                            end
                        end)

                        if modup == true then
                            -- for _,h in pairs(Entities:FindAllByName( SET_FORCE_HERO ) ) do
                            --     if  h:GetTeamNumber()== i+5 then
                            --         h.ship[string.sub(s,12)]=true
                            --         break
                            --     end
                            -- end
                            Entities:GetPlayer(i +5 ).ship[string.sub(s,12)]=true
                        end

                    end)

                    -- table.foreach(tTeamMate,function(_,v)
                    --     for c = 0,10 do
                    --         if v:GetAbilityByIndex(c) then
                    --             local hAbi  = v:GetAbilityByIndex(c):GetAbilityName()

                    --             --if tkShipList[hAbi] and not tBuff01[hAbi] then tBuff01[hAbi]=true end

                    --             local intab = false
                    --             for _,modhad in pairs(tBuff01) do
                    --                 if hAbi == modhad then intab =true break end
                    --             end
                    --                 if intab==false then table.insert(tBuff01,hAbi) end
                    --         end
                    --     end
                    -- end)

                    -- table.foreach(tBuff01,function(_,v)
                    --     local modup = false
                    --     if tkShipList[v] then
                    --         local count = 0
                    --         local nedcount = 0
                    --         table.foreach(tkShipList[v],function() nedcount=nedcount+1 end)
                    --         for _,heroneed in pairs(tkShipList[v]) do
                    --             for _,unit in pairs(tTeamMate) do
                    --                 if unit:GetUnitName() == heroneed then count=count+1 break end
                    --             end
                    --                 if count == nedcount then modup=true break end
                    --         end
                    --     end

                    --     if modup == true then table.insert(tBuff02,v) end
                    -- end)

                    -- table.foreach(tTeamMate,function(_,v)
                    --     table.foreach(tBuff02,function(_,abiname)
                    --         if v:FindAbilityByName(abiname ) then
                    --             local hAbi = v:FindAbilityByName(abiname )
                    --             local modName = "Modifier_"..abiname
                    --             if hAbi:GetCaster():HasModifier(modName ) then RemoveModifierByName(modName) end
                    --             hAbi:ApplyDataDrivenModifier(hAbi:GetCaster(), hAbi:GetCaster(), modName, nil)
                    --             --print("tBuff02",hAbi:GetCaster():GetUnitName(),hAbi:GetCaster():HasModifier(modName ),modName )
                    --         end
                    --     end)
                    -- end)

                    -- for q=0,5 do
                    --     local oitem = Entities:GetPlayer(i +5 ):GetItemInSlot(q)
                    --     if oitem then
                    --         local vitem = CreateItem(oitem:GetName(),nil,nil)
                    --         table.foreach(tTeamMate,function(_,v)
                    --             if  v:GetItemInSlot(q) ~= vitem then
                    --                 v:RemoveItem(v:GetItemInSlot(q))
                    --                 v:AddItem( vitem )
                    --             end
                    --         end)
                    --     end
                    -- end
                    table.foreach(tTeamMate,function(_,u)
                        for q=0,5 do
                            local oitem = Entities:GetPlayer(i +5 ):GetItemInSlot(q)
                            local vitem = u:GetItemInSlot(q)
                            if    oitem 
                            and ( not vitem  or vitem:GetName() ~= oitem:GetName() ) 
                            then local additem = CreateItem( oitem:GetName(), u, u )
                                additem:SetCurrentCharges(oitem:GetCurrentCharges())
                                u:RemoveItem(vitem )
                                u:AddItem( additem )
                            end
                        end

                        for i=0,10 do
                            local abi = u:GetAbilityByIndex(i)
                            if    abi 
                            and   abi.needwaveup 
                            then  abi:needwaveup()
                            end
                        end
                    end)
                end
            end
            table.foreach(Entities:FindAllByName("npc_dota_fort"),function(_,v) v:Destroy() end)
        end

        TimeForBatter = Timer(function()
            if return_time<TIME_BATTER_MAX then
                if not GameRules:IsGamePaused() then return_time=return_time+1 end
                CustomNetTables:SetTableValue( "game_stat", "game_countdown",{countDown=true,timeMax=TIME_BATTER_MAX,timeNow=return_time} )
                print("countdown batter time:"..return_time)
    
                table.foreach(Entities:FindAllByTeam( 2 ), function(_,v) if v:IsIdle() then  v:SetRequiresReachingEndPath(true) end end)
                return 1
            else
                table.foreach(Entities:FindAllByTeam( 2 ), function(_,unit) unit:Kill(nil,unit) end)
                CustomNetTables:SetTableValue( "game_stat", "game_countdown",{countDown=false,timeMax=0,timeNow=0} )
            end
        end)
    end)
end

function GameForUnit:OnEntityKilled( keys )
    local killedUnit = EntIndexToHScript( keys.entindex_killed   )
    local killerUnit = EntIndexToHScript( keys.entindex_attacker )


    if  killerUnit~=killedUnit and killerUnit:GetName() == "npc_dota_building" then
        local realKiller = killerUnit:GetPlayerOwner():GetAssignedHero() --PlayerResource:GetSelectedHeroEntity(killerUnit:GetPlayerOwnerID())
              realKiller:SetHealth( realKiller:GetHealth()-1 )


        if    realKiller:GetHealth() <= 0 then
              GameRules:MakeTeamLose( realKiller:GetTeamNumber() )
              --killerUnit:Destroy()
        end
    end

    if  killedUnit.enemy then killedUnit:Destroy()
        if #Entities:FindAllByTeam(2)==0  then RemoveTimer(TimeForBatter) GameForUnit:OnGameRoundChange()  end
    end
end

function GameForUnit:OnNPCSpawned( keys )
    local  npc = EntIndexToHScript(keys.entindex)
    if npc:GetName()== "npc_dota_fort"
    or npc:GetName()== "npc_dota_building"
    or npc.bFirstSpawned then
        return
    end

    npc.bFirstSpawned = true

    if npc:GetName()==SET_FORCE_HERO then
        for i=0,15 do if npc:GetAbilityByIndex(i) ~= nil then  npc:GetAbilityByIndex(i):SetLevel(1) end end
        npc.Ticket = PlayerResource:HasCustomGameTicketForPlayerID(npc:GetPlayerOwnerID())

        CreateUnitByName("tower_zhugong",
                        Entities:Pos(npc:GetTeamNumber()-5,3),
                        false,nil,nil,
                        npc:GetTeamNumber()):SetOwner(npc)

        CustomUI:DynamicHud_Create(npc:GetPlayerID(),"psd","file://{resources}/layout/custom_game/uiscreen.xml",nil)
        CustomNetTables:SetTableValue( "Hero_Population", tostring(npc:GetPlayerID()),{popMax=LOCAL_POPLATION,popNow=0} )
        if GetMapName=="map0" then CustomGameEventManager:Send_ServerToTeam(npc:GetTeam(), "CameraRotateHorizontal", {angle=npc:GetPlayerID()*360/8}) end
    else
        local NameX = npc:GetUnitName()
        --print(NameX)
        local abiT =  npc:AddAbility('skill_player_lock')
        if abiT then abiT:SetLevel(npc:GetLevel()) end

        if able_table[NameX] then
            table.foreach(able_table[NameX],function(k,a)
                local abiname =  npc:AddAbility(a)
                if abiname then
                    abiname:SetLevel(npc:GetLevel())
                end
            end)
        end

        if _G.npcBaseType[NameX] then
            local attack_type = _G.npcBaseType[NameX][1] or "none"
            local defend_type = _G.npcBaseType[NameX][2] or "none"

            npc:AddNewModifier(npc, nil, "modifier_attack_" .. attack_type, {})
            npc:AddNewModifier(npc, nil, "modifier_defend_" .. defend_type, {})
            npc.popuse = tonumber(_G.npcBaseType[NameX][3]) or 1

        elseif npc:IsHero() then
            for k,v in pairs(tkHeroList)do
                --print(k,v.override_hero)
                if NameX==string.lower(v.override_hero) then NameX=k break end
            end
            local attack_type = tkHeroList[NameX]["TksAttackType"] or "none"
            local defend_type = tkHeroList[NameX]["TksDefendType"] or "none"

            --print(NameX,attack_type,defend_type)
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
    end

    print("[BAREBONES] NPC Spawned",npc:GetUnitName())

end

function GameForUnit:OnPlayerLevelUp( keys )
    EntIndexToHScript(keys.hero_entindex):SetAbilityPoints(0)
end

function GameForUnit:DamageFilter( filterTable )
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

        local armor = victim:GetPhysicalArmorValue(false)
        local oldkang  = 1-52/48*armor/(18.75+armor)
        local newkang  = 1-armor/(100+armor)

        filterTable.damage=filterTable.damage /oldkang *newkang

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

function GameForUnit:InventoryFilter( filterTable )
    local hItem   = EntIndexToHScript( filterTable.item_entindex_const )--获得的物品
    local hItemPar= EntIndexToHScript( filterTable.item_parent_entindex_const )
    local hInvPar = EntIndexToHScript( filterTable.inventory_parent_entindex_const )--InventoryParent--库存拥有者
    local slot    = filterTable.suggested_slot

    --if hItem:GetName()=='item_tpscroll' then return true end


    if hItem == nil or hInvPar == nil then return true end

    local slotlist={ 'weapon', 'defend', 'jewelry', 'horses', 'format', 'queue' }
    for k,v in pairs(slotlist) do
        if  string.find(hItem:GetAbilityName(),v) then
            slot = k-1
            break
        end
    end

    if hInvPar:GetItemInSlot(slot) then hInvPar:RemoveItem(hInvPar:GetItemInSlot(slot)) end

    filterTable.suggested_slot = slot

    -- if hInvPar:GetName() == SET_FORCE_HERO then
    --     local arms={}
    --     table.foreach(HeroList:GetAllHeroes(),function(_,v)
    --         if not v:IsOpposingTeam( hInvPar:GetTeamNumber() ) and v~=hInvPar  then
    --             table.insert(arms,v)
    --         end
    --     end)
    --     for i in ipairs(arms) do arms[i]:AddItemByName(hItem:GetName()):SetSellable(false) end
    -- end

    return true
end

function GameForUnit:ExperienceFilter( filterTable ) end

function ShuaGuai( CreateName, origin, level, iTeam, iReTeam)

    local ShuaGuai_entity = Entities:FindByName(nil,"creep_birth_"..iTeam.."_0")
    local lock = 'skill_player_lock'
    local hero = Entities:GetPlayer(iReTeam)

    iReTeam = iTeam ~= iReTeam and iReTeam or DOTA_TEAM_BADGUYS
    origin = origin or ShuaGuai_entity:GetOrigin()

    CreateUnitByNameAsync(CreateName,origin,true,hero,hero,iReTeam,  function( u )
        u:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
        u:FindAbilityByName(lock):ApplyDataDrivenModifier(u, u, lock..'_plan', nil)
        -- v:AddAbility("skill_player_countdown"):SetLevel(1)
        u:SetInitialGoalEntity( ShuaGuai_entity )
        u:CheckLevel(level)
        u.enemy=true end)
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