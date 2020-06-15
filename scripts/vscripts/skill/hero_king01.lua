--[[
	Author: 西索酱
	Date: 12.05.2020
	小于50%的血增加护甲30+lvl*3
]]
function yinghan( keys )
	local caster  = keys.caster  
  --local target  = keys.target
	local ability = keys.ability
	local damagebase = ability:GetLevelSpecialValueFor("armor",(ability:GetLevel()-1))
	local modifierName = "modifier_skill_hero_yinghan_2"

	if  not caster:HasModifier(modifierName) 
	and caster:GetHealth() < caster:GetMaxHealth()/2 then
		ability:ApplyDataDrivenModifier( caster, caster, modifierName, nil )
	end
end

function longdan(keys)
	local caster  = keys.caster  
  	local target  = keys.target
	local ability = keys.ability
	local attacker= keys.attacker
	local change  = ability:GetLevelSpecialValueFor("change",(ability:GetLevel()-1))
	local iDamage = ability:GetLevelSpecialValueFor("change",(ability:GetLevel()-1))
	
	print("longdan............")
	for k,v in pairs(keys) do 
		print(k,v)
		if type(v)==table then print(k,v:GetUnitName()) end 
	end

	if caster:HasModifier("Modifier_item_arms_qinggangjian") then
		iDamage = (2 - caster:GetHealth() / caster:GetMaxHealth())*iDamage
	end

	if RollPercentage(change) then
		
		if  caster == attacker then--触发暴击
			local dam = {
				victim  	= target,
				attacker	= attacker,
				damage  	= iDamage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability 	= ability
				}
			ApplyDamage(dam)
		elseif caster == target then--触发闪避

		end
	end
end

function chongzheng(keys)
	--DeepPrintTable(keys)
	for k,v in pairs(keys) do print("chongzheng",k,v) end
end