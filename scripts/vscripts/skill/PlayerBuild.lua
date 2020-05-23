function OnBack( data )
	print("PlayerBuild:OnBack")
	
	local target   = data.target
	local caster   = data.caster

	if target == caster then return end
	if not YOUR_IN_TEST and CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]~=0 then return end

	local onback   = false
	local heroName = target:GetUnitName()
	local itemName = string.gsub(heroName,"npc","item")
	local item = CreateItem(itemName, caster, caster)
    --item:SetPurchaseTime(0)
    --item:SetPurchaser( caster )

	--在记录表中删掉这个单位
	local iTeam = target:GetTeamNumber()-5
	if _G.buildpostab[iTeam] then
	for k=1,#_G.buildpostab[iTeam] do
		if _G.buildpostab[iTeam][k]['unit']  == heroName then _G.buildpostab[iTeam][k] = nil end
	end
	end
	
	--找到点将台,创建物品
	local x = caster.Ticket and 6 or 5
    for i = 1 , x do
    	local itemPos    = Entities:FindByName( nil, "dianjiangtai_"..iTeam.."_"..i)
    	local isemptytab = Entities:FindAllByClassnameWithin("dota_item_drop", itemPos:GetAbsOrigin(),50)
    	if  #isemptytab == 0 then
    		CreateItemOnPositionSync(itemPos:GetAbsOrigin(),item)
    		onback = true
    		break
    	end
	end

	if  onback == false then 
		OnSell( data )
	elseif target ~= caster then
		target:Destroy()
	end
end

function OnSell( data )
	local target   = data.target
	local caster   = data.caster
	if target == caster then return end
	if not YOUR_IN_TEST and CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]~=0 then return end

	local onsell   = false
	local heroName = target:GetUnitName()
	local itemName = string.gsub(heroName,"npc","item")
	
end

function LevelUp( data )
	local target   = data.target
	local caster   = data.caster
	if target == caster then print("is wrong") return end
	if not YOUR_IN_TEST and CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]~=0 then return end


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