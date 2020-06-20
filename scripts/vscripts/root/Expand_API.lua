function CDOTAGamerules:SetGoldPerTick(gold) 

    GAMERULE_GOLD_PER_TICK = GAMERULE_GOLD_PER_TICK or 0
    if gold then GAMERULE_GOLD_PER_TICK = -gold return end

    for i=0,PlayerResource:GetPlayerCount() do
        if  PlayerResource:HasSelectedHero( i )  then
            PlayerResource:SpendGold( i, GAMERULE_GOLD_PER_TICK, 10 )
        end
    end
end

function CDOTAGamerules:SetGoldTickTime(TickTime)

    local timerName = DoUniqueString("GoldenThink")

    GameRules.__vTimerNamerTable__ = GameRules.__vTimerNamerTable__ or {}
    GameRules.__vTimerNamerTable__[timerName] = true

    GameRules:GetGameModeEntity():SetContextThink(timerName,function()
        if  GameRules.__vTimerNamerTable__[timerName] then
            GameRules:SetGoldPerTick()
            return TickTime 
        else
            return nil
        end
    end, TickTime)

    return timerName
end


function CDOTA_BaseNPC:CheckLevel(lvl)
    
    lvl = lvl or self:GetLevel()+1

    while( self:GetLevel() < lvl ) do
            if   self:IsHero() then
                 self:HeroLevelUp( false )
            else self:CreatureLevelUp( 1 )
            end
    end
    
    for i=0,15 do 
        if  self:GetAbilityByIndex(i) then 
            self:GetAbilityByIndex(i):SetLevel(lvl) 
        end 
    end
end

function CDOTA_PlayerResource:Pay( PlayerID, cost )

    if  self:GetGold(PlayerID) < cost then
        --FireGameEvent('dota_hud_error_message',{reason=0, message="no gold"	})
        return false
    else
        PlayerResource:SpendGold( PlayerID, cost, DOTA_ModifyGold_PurchaseConsumable)
        return true
    end
end


function CEntities:FindAllByTeam( enemy , team )
    local reList = {}

    if not team then reList = Entities:FindAllInSphere( Vector( 0, 0, 0 ), 9999)
    else
        local PosZuo = Entities:FindByName(nil,"tree_birth_"..team.."_0"):GetOrigin()
        local PosYou = Entities:FindByName(nil,"tree_birth_"..team.."_1"):GetOrigin()
        local PosXia = Entities:FindByName(nil,"tree_birth_"..team.."_2"):GetOrigin()
        local PosSta = PosZuo/2 + (PosXia - PosYou /2)  -- (PosYou - PosZuo)/2 + PosZuo + (PosXia - PosYou)
        local PosEnd = PosZuo/2 - (PosXia- PosYou*3/2)  -- (PosYou - PosZuo)/2 + PosZuo - (PosXia - PosYou)
        local width  = math.sqrt( math.pow(PosYou.x-PosZuo.x, 2)+ math.pow(PosYou.y-PosZuo.y, 2) )

        reList = FindUnitsInLine(   team+5, 
                                    PosSta , 
                                    PosEnd , 
                                    nil, 
                                    width ,
                                    enemy ,
                                    DOTA_UNIT_TARGET_ALL ,
                                    DOTA_UNIT_TARGET_FLAG_NONE
                                )
    end

    -- if enemy == DOTA_UNIT_TARGET_TEAM_FRIENDLY  then enemy = true
    -- elseif enemy == DOTA_UNIT_TARGET_TEAM_ENEMY then enemy = false
    -- elseif enemy == DOTA_UNIT_TARGET_TEAM_BOTH  then enemy = nil
    -- end
    for k = #reList, 1, -1 do  
        local u= reList[k] 

        if not u.bFirstSpawned
        or not u:IsAlive()
        or u:GetName() == SET_FORCE_HERO 
        or u:GetName() == "npc_dota_courier" 
        then table.remove( reList , k )            
        end

        -- if a==true and not b then table.remove(reList,i)
        -- elseif a==false and b then table.remove(reList,i)
        -- elseif a==nil then u:IsAlive()
        -- end
        
        if  u == reList[k] then
            if enemy == DOTA_UNIT_TARGET_TEAM_ENEMY and not u.enemy then table.remove(reList,k) 
            elseif enemy == DOTA_UNIT_TARGET_TEAM_FRIENDLY and u.enemy then table.remove(reList,k)
            end
        end
    end
    
    return reList

    -- local rheroes = {}
    -- --local heroes  = {}
    -- if key=="creature" then
    --     return Entities:FindAllByName("npc_dota_creature")
    -- end

    -- if key=="enemy" then 
    --     table.foreach(Entities:FindAllByName("npc_dota_creature"),function(_,v)
    --         if  v.enemy and v:IsAlive() then table.insert(rheroes,v) end
    --     end)
    --     table.foreach(HeroList:GetAllHeroes(),function(_,v)
    --         if   v.enemy and v:IsAlive()  then table.insert(rheroes,v) end
    --     end)
        
    --     return rheroes
    -- end

    -- if key=="all" then
    --     rheroes=Entities:FindAllByName("npc_dota_creature")
    --     table.foreach(HeroList:GetAllHeroes(),function(_,v)
    --         if  v:GetName()~=SET_FORCE_HERO  then table.insert(rheroes,v) end
    --     end)

        
    --     return rheroes
    -- end

    -- if key=="allx" then---有个同队的没有name的实体无法排除
        
    --     table.foreach(Entities:FindAllInSphere(Vector(0,0,0), 99999),function(k,v)
    --         print(k,v)
    --         --if v:GetUnitName() then print(v:GetUnitName())
    --         --else
    --         if v:GetName() then print(v:GetName())
    --         end

    --         --v:getclass(instanceObj)
    --         --if v:IsPlayer() then print(v,"true") end
    --         if  v:GetTeam()~=4  and v:GetTeam()~=0 
    --         and v:GetName()~=SET_FORCE_HERO 
    --         and v:GetName()~="npc_dota_building"
    --         and v:GetName()~="npc_dota_fort" then
    --             table.insert(rheroes,v)
    --             print(k,v,v:GetTeam(),v:GetName(),v:GetClassname())
    --         end
    --     end)
    --     table.foreach(rheroes,function(c,s) print(c,s,s:GetTeam(),s:GetName()) end) --function(_,x) table.foreach(x,  end)
    --     return rheroes
    -- end
    --     --[[
    -- HeroList:GetAllHeroes()

    -- for i=1,#heroes do
    --     if heroes[i]:IsRealHero() then
    --         table.insert(rheroes,heroes[i])
    --     end
    -- end
    -- return rheroes]]
end


function CEntities:Pos(iTeam, iSide)
    return Entities:FindByName(nil,"creep_birth_"..iTeam.."_"..iSide):GetOrigin()
end

function CEntities:GetPlayer(iTeam)
    for _,h in pairs(Entities:FindAllByName( SET_FORCE_HERO ) ) do
        if  h:GetTeamNumber()== iTeam then
            return h
        end
    end
end

function CDOTA_BaseNPC:SetPlayer()
    local iTeam = self:GetTeamNumber()
    for _,h in pairs(Entities:FindAllByName( SET_FORCE_HERO ) ) do
        if  h:GetTeamNumber()== iTeam then
            self:SetOwner(h)
            return h
        end
    end
    return nil
end