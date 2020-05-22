TIME_BETWEEN_ROUND = 6  --间距时间
SET_FORCE_HERO     ="npc_dota_hero_phoenix"
SET_UP_AUTO_LAUNCH_DELAY = 0--队伍选择时间

playerallstart = {}--所有人是否选好主公
_G.buildpostab ={}--所有单位位置
_G.game_round  = 0--初始化轮数

require("questsystem")  --任务列表，倒计时
require("ThreeKingdoms")

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_witchdoctor.vsndevts", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf", context )
    PrecacheResource( "particle", "particles/base_destruction_fx/gensmoke.vpcf", context )
end

