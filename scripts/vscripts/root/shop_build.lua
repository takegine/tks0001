shopbuild = shopbuild or class({})

function shopbuild.new()
	
    CustomGameEventManager:RegisterListener("Population_Up", Dynamic_Wrap(shopbuild,"Population_Up") )
end

function shopbuild:Population_Up( data )
	print("ShopBuild:PopulationUp")
	-- local caster   = data.caster
	-- local ability  = data.ability
	-- local plid = caster:GetPlayerID()
	local id = data.PlayerID
	local tPop = CustomNetTables:GetTableValue( "Hero_Population", tostring(id))
	
	if  PlayerResource:Pay( id, 100 ) then
		tPop['popMax'] = tPop['popMax'] + 1

		CustomNetTables:SetTableValue( "Hero_Population", tostring(id),tPop)
	-- print(caster:GetName(),ability:GetAbilityName(),caster:HasItemInInventory( ability:GetAbilityName()))
	-- local item = caster:FindItemInInventory(ability:GetAbilityName())
	-- caster:RemoveItem(item)
	
	end
end