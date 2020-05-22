--[[
	Author: 西索酱
	Date: 12.05.2020
	小于50%的血增加护甲30+lvl*3
]]
skill_hero_fangquan = class ({})

----------------------------------------------------------------------------------------

function skill_hero_fangquan:OnSpellStart()
	local caster   = self:GetCaster()
    local duration = self:GetLevelSpecialValueFor("duration",(self:GetLevel()-1))
	local tFriend  = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 999, DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_ALL, 0, 0, false )
	local used  = false
	local cdrun = 0 

	if #tFriend == 0 then return UF_FAIL_DEAD
	else
		Timers(function()
			if not used then
				used = true
				local target = tFriend[RandomInt(1, #tFriend)]
				local change = caster:GetMaxHealth()*0.3
				--caster 减change
				--target 加change
				
			end

			if cdrun < duration then
				cdrun= 1+cdrun
				return 1
			else
				if target:IsAlive() then
					--caster 加change
					--target 减change
				end
			end
		end)
	end
end


----------------------------------------------------------------------------------------