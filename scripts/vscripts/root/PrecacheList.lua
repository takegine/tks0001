
SET_UP_AUTO_LAUNCH_DELAY = 20 
SET_FORCE_HERO     ="npc_dota_hero_phoenix"
SET_FIRST_HERO     ="npc_dota_creature_gnoll_assassin"
SET_PREGAME_TIME   = 5  
TIME_BETWEEN_ROUND = 30
TIME_BATTER_MAX    = 60   
SET_STARTING_GOLD  = 4000  
LOCAL_POPLATION    = 10  
YOUR_IN_TEST       = true
LOCAL_VERSION      = '0004'


DAMAGE_TYPES = {
    [0] = "DAMAGE_TYPE_NONE",
    [1] = "DAMAGE_TYPE_PHYSICAL",
    [2] = "DAMAGE_TYPE_MAGICAL",
    [4] = "DAMAGE_TYPE_PURE",
    [7] = "DAMAGE_TYPE_ALL",
    [8] = "DAMAGE_TYPE_HP_REMOVAL"
}

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
    PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/jugg_attack_blur.vpcf", context )
    
    PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_ti8_sword_attack_b.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_ti8_sword_attack_a.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/pudge/pudge_arcana/pudge_arcana_weapon_blur_left_to_right.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/pudge/pudge_arcana/pudge_arcana_weapon_blur_right_to_left.vpcf", context )

    PrecacheResource( "particle", "particles/units/heroes/hero_pudge/pudge_death_dust.vpcf", context )
    --PrecacheResource( "particle", "particles/econ/items/pudge/pudge_arcana/pudge_arcana_weapon_blur_right_to_left.vpcf", context )
    PrecacheResource( "model", "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee.vmdl", context )

    for hero, info in pairs(tkHeroList) do
        PrecacheUnitByNameSync(info.Model, context)
    end
end

function BroadcastMsg( sMsg )
	-- Display a message about the button action that took place
	local buttonEventMessage = sMsg
	--print( buttonEventMessage )
	local centerMessage = {
		message = buttonEventMessage,
		duration = 1.0,
		clearQueue = true -- this doesn't seem to work
	}
	FireGameEvent( "show_center_message", centerMessage )
end

--math.randomseed(tostring(os.time()):reverse():sub(1, 7)) --设置时间种子

function LinkLuaS()
    local typetab = {"none","tree","fire","electrical","water","land","god"}
    local modload = "buff/BaseType.lua"
    for _,v in pairs(typetab) do
        print("modifier_attack_"..v)
        LinkLuaModifier( "modifier_attack_"..v, modload, 0 )
        LinkLuaModifier( "modifier_defend_"..v, modload, 0 )
    end 
end

LinkLuaS()

if  YOUR_IN_TEST then
    SET_UP_AUTO_LAUNCH_DELAY = 0--队伍选择时间
    TIME_BETWEEN_ROUND = 10  --轮间距40
    LOCAL_POPLATION    = 99 
end


if LOCAL_VERSION == '0004' or LOCAL_VERSION == '0003' then
    theloadluafilehead = 'abandoned/'
else
    theloadluafilehead = 'root/'
end

require('root/ToolsFromX')
require("root/ValueTable")
require("root/bare_bones")
--require("questsystem")  
require(theloadluafilehead.."GetNewHero")
require(theloadluafilehead.."rootline"..LOCAL_VERSION)