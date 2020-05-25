if GetNewHero == nil then GetNewHero = class({}) end

function GetNewHero:listen()
    CustomGameEventManager:RegisterListener("find_wujiang",Dynamic_Wrap(self, 'find_wujiang'))
    CustomGameEventManager:RegisterListener("get_wujiang",Dynamic_Wrap(self, 'LetHeroTrue'))
    CustomGameEventManager:RegisterListener("player_get_country",Dynamic_Wrap(self, 'playerGetCountry'))
    CustomGameEventManager:RegisterListener("item_lvl_up",Dynamic_Wrap(self, 'itemLevelUp'))
    CustomGameEventManager:RegisterListener("item_on_sell",Dynamic_Wrap(self, 'itemOnSell'))
    
    
    
    table.foreach(tkHeroList,function(hero, info)              
        if  info ~= 1 then
            if  info.UnitLabel == "qunxiong"   then table.insert( _G.tkHeroName['qunxiong'], info.override_hero )  
            elseif  info.UnitLabel == "shuguo" then table.insert( _G.tkHeroName['shuguo'], info.override_hero )  
            elseif  info.UnitLabel == "wuguo"  then table.insert( _G.tkHeroName['wuguo'], info.override_hero )  
            elseif  info.UnitLabel == "weiguo" then table.insert( _G.tkHeroName['weiguo'], info.override_hero )  
            end
            if  info.UnitLabel then table.insert( _G.tkHeroName['all'], info.override_hero )  end
        end
    end)
end

function GetNewHero:findding_Wj( data )
    local hero = PlayerResource:GetSelectedHeroEntity(data.id) 
    local x    = data.way
    local findcost = 100 --减钱

    if  hero:GetGold() > findcost then
        if  PlayerResource:GetUnreliableGold(data.id) > findcost then
            hero:SetGold( PlayerResource:GetUnreliableGold(data.id) - findcost , false)
            hero:SetGold( PlayerResource:GetReliableGold(data.id), true)
        else
            hero:SetGold(hero:GetGold()-findcost,true)
            hero:SetGold(0,false)
        end

        if  x == "country" then GetNewHero:find_country( data.id ) 
        elseif x == "hero" then GetNewHero:find_wujiang( data.id ) 
        elseif type(x) == "table" then for k,v in pairs(x)do print('input',k,v) end
        else GetNewHero:LetHeroTrue( data ) --if type(x)=="string" then--x ~= "undefined"
        end
    else GetNewHero:UptoDJT(data.id,"poorguy")
    end
end

function GetNewHero:find_wujiang( data )
    local hero     = PlayerResource:GetSelectedHeroEntity(data.id) 
    local chance   = 70  
    local findcost = 100 --减钱

    if   hero:GetGold() < findcost then GetNewHero:UptoDJT(data.id,"poorguy") return
    else hero:SetGold( PlayerResource:GetGold(data.id)-findcost, false)
    end
    
    local rolltable ={}
    if data.way == "country" then rolltable =_G.tkHeroName[hero.country] end
    if data.way == "hero" then rolltable = _G.tkHeroName['all'] end

    if RollPercentage(chance) then 
        --local itemID="150"..RandomInt(1,3)
        local randomID=RandomInt(1,#rolltable)
        local unitName=rolltable[randomID]

        print("find_wujiang",randomID,unitName )

        GetNewHero:UptoDJT(data.id,unitName)
    else
        GetNewHero:UptoDJT(data.id,"noget")
        hero:SetGold( PlayerResource:GetGold(data.id)+findcost/2, false)
    end  
end

function GetNewHero:LetHeroTrue( data ) 
    --DeepPrintTable(data.way)
    local hero = PlayerResource:GetSelectedHeroEntity(data.id)
    local unitName = data.way 
    local findcost = 100 --减钱
    print(unitName)
    if   hero:GetGold() < findcost then GetNewHero:UptoDJT(data.id,"poorguy") return
    else hero:SetGold( PlayerResource:GetGold(data.id)-findcost, false)
    end

    local vPos = Entities:FindByName(nil,"creep_birth_"..(hero:GetTeamNumber()-5).."_2"):GetAbsOrigin()+ Vector (RandomFloat(-300, 300),RandomFloat(-100, 200),0)
    --local vBir = CreateUnitByName(unitName,vPos,true,hero,hero,hero:GetTeamNumber())
    --      vBir:SetControllableByPlayer(hero:GetPlayerOwnerID(),true)
    CreateUnitByNameAsync(unitName,vPos,true,hero,hero,hero:GetTeamNumber(),function(v) v:SetControllableByPlayer(hero:GetPlayerOwnerID(),true) end)
    --print("LetHeroTrue",hero:GetPlayerOwnerID(),vBir:GetMainControllingPlayer(),hero:GetTeamNumber(),hero:GetPlayerOwnerID())   

    if data.No then GetNewHero:UptoDJT(data.id,data.No) end
end 
            
function GetNewHero:UptoDJT(playID,event)
    --if string.find(event,"npc") then event=string.gsub(event,"npc","item") end
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playID), "wujiang_shopUp", {event=event} )
end

function GetNewHero:playerGetCountry( data )
    local hero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
    local unitName
    local num
    local tRamdom
    if type(data.event)== 'string' then unitName = data.event
    elseif type(data.event)== 'number' then num  = data.event
    else tRamdom = data.event
    end
    
    if num then 
        if  num == 5 then 
            num = RandomInt(1,4) 
            hero:SetGold( PlayerResource:GetGold(data.PlayerID) + 200 , false) 
        end

        if num == 4 then hero.country = "qunxiong" 
        elseif num == 1 then hero.country = "shuguo"
        elseif num == 2 then hero.country = "wuguo"
        elseif num == 3 then hero.country = "weiguo"
        end
        --CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(PlayID), "wujiang_shopUp", {event=itemName} )
        --CustomUI:DynamicHud_Create(data.PlayerID,"psd","file://{resources}/layout/custom_game/uiscreen.xml",{country=hero.country})
        for i=1,4 do
            local unitID   = RandomInt(1,#_G.tkHeroName[hero.country])
            local unitName = _G.tkHeroName[hero.country][unitID]
            
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(data.PlayerID), "wujiang_first", {num=i,event=unitName} )
            print("first_wujiang",unitName)
        end
    
        --CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(data.PlayerID), "playergetcountry", {event=hero.country} )
        print("playerGetCountry",hero.country)
        --table.insert(playerallstart,data.PlayerID)
        --if  PlayerResource:GetPlayerCount() == #playerallstart then
        --    ThreeKingdoms:OnGameRoundChange()
        --end
        return
    end

    if  tRamdom then 
        local unitName = tRamdom[RandomInt(1,4) ]
        hero:SetGold( PlayerResource:GetGold(data.PlayerID) + 200 , false) 
    end
    
    if  unitName then
        GetNewHero:LetHeroTrue( {id=data.PlayerID,way=unitName} ) 
         print("GetNewHero:playerGetCountry",unitName)
    else print("you got error message in GetNewHero:playerGetCountry")
    end

end

function GetNewHero:itemLevelUp(data)
    local playID= data.PlayerID
    local num	= data.num
    local item	= data.item
end

function GetNewHero:itemOnSell(data)
    local playID= data.PlayerID
    local hero 	= PlayerResource:GetSelectedHeroEntity(playID) 
    local num	= data.num
    local item	= data.item
    hero:SetGold(hero:GetGold()+math.random(45,75),false)

    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playID), "item_selled", {num=num})
end
-----------------------------------------------------playerBuild的参考----------------------

function OnSell( data )
    local target   = data.target
    local caster   = data.caster
    if target == caster then return end
    local onsell   = false
    local heroName = target:GetUnitName()
    local itemName = string.gsub(heroName,"npc","item")
    
end

function LevelUp( data )
    local target   = data.target
    local caster   = data.caster
    if target == caster then print("is wrong") return end
    local plid     = caster:GetPlayerOwnerID()
    local hero     = PlayerResource:GetSelectedHeroEntity(plid)
    local findcost = 100 --减钱

    print(PlayerResource:NumTeamPlayers())

    if  hero:GetGold() > findcost then
        hero:SetGold(hero:GetGold()-findcost,false)
        target:CreatureLevelUp(1)
    else
        print("poor guy")
    end

    
    
end