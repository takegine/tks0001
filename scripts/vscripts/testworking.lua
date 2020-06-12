function wow()
local reList = Entities:FindAllByTeam(2)
    print_r(reList)
    table.foreach(reList,function(k,v)
        print("wow",k,v,v:GetTeam(),v:GetName(),v:GetClassname())
    end)
    -- local team   = 6
    -- local enemy  = true
    -- local PosZuo = Entities:FindByName(nil,"tree_birth_"..(team-5).."_0"):GetOrigin()
    -- local PosYou = Entities:FindByName(nil,"tree_birth_"..(team-5).."_1"):GetOrigin()
    -- local PosXia = Entities:FindByName(nil,"tree_birth_"..(team-5).."_2"):GetOrigin()
    -- local PosSta = PosZuo/2 + (PosXia - PosYou /2)  -- (PosYou - PosZuo)/2 + PosZuo + (PosXia - PosYou)
    -- local PosEnd = PosZuo/2 - (PosXia- PosYou*3/2)  -- (PosYou - PosZuo)/2 + PosZuo - (PosXia - PosYou)

    -- CreateUnitByName("npc_dota_creature_gnoll_assassin", PosSta, true, nil, nil, 2)
    -- CreateUnitByName("npc_majia", PosEnd , true, nil, nil, 2)

    -- if enemy==nil then enemy=3
    -- else enemy = enmey and DOTA_UNIT_TARGET_TEAM_ENEMY or DOTA_UNIT_TARGET_TEAM_FRIENDLY
    -- end
    -- -- local reList = Entities:FindAllInSphere(Vector(0,0,0), 9999)
    -- local reList = FindUnitsInLine( team, 
    --     PosZuo/2 - PosYou/2 + PosXia , 
    --     PosZuo/2 - PosYou/2 - PosXia , 
    --     nil, 
    --     PosYou.x - PosZuo.x ,
    --     enemy ,
    --     DOTA_UNIT_TARGET_ALL ,
    --     DOTA_UNIT_TARGET_FLAG_NONE)


    -- -- table.foreach(reList,function(k,v)
      
    -- for i = #reList, 1, -1 do  
    --     local v =reList[i]
        
    --     if not v.bFirstSpawned
    --     or v:GetName() == SET_FORCE_HERO 
    --     then table.remove( reList , i )            
    --     end

    --     -- if a==true and not b then table.remove(reList,i)
    --     -- elseif a==false and b then table.remove(reList,i)
    --     -- elseif a==nil then 
    --     -- end
        
    --     -- if enemy== false and v.enemy then table.remove(reList,i)
    --     -- elseif enemy and not v.enemy then table.remove(reList,i)
    --     -- end

    -- end
    
    -- return reList
    
end


-- if a== false and b then table.remove(reList,i)
-- elseif a and not b then table.remove(reList,i)
-- end

-- if a ~= nil and a ~= b then table.remove(reList,i) end