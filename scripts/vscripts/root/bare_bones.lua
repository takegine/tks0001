if GameMode == nil then GameMode = class({}) end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
    print( "Template addon is loaded." )
	require("root/GameRules")

    self.game = GameForUnit()
    GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
    GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(self.game, "DamageFilter"), self.game)
    GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap( self.game, "InventoryFilter" ), self.game )
    GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap(self.game, "ExperienceFilter"), self.game )

    ListenToGameEvent('dota_player_gained_level',Dynamic_Wrap(self.game, 'OnPlayerLevelUp'), self.game)
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(self.game,"OnGameRulesStateChange"), self.game)
    ListenToGameEvent("entity_killed",           Dynamic_Wrap(self.game,"OnEntityKilled"), self.game)
    ListenToGameEvent("npc_spawned",             Dynamic_Wrap(self.game, "OnNPCSpawned"), self.game)
    ListenToGameEvent("player_connect_full",     Dynamic_Wrap(self, "OnConnectFull"), self)

    CustomGameEventManager:RegisterListener("createnewherotest", Dynamic_Wrap(self,"createnewherotest") )
    CustomGameEventManager:RegisterListener("refreshlist",       Dynamic_Wrap(self, 'refreshlist'))

    -- Change random seed
    local timeTxt = string.gsub(string.gsub(GetSystemTime(), ":", ""), "0", "")
    math.randomseed(tonumber(timeTxt))
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
    -- print("[BAREBONES] OnConnectFull")
    
    -- Set GameMode parameters
require("root/GameMode")
    
end

-- Evaluate the state of the game
function GameMode:OnThink()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        local zhugongTab = Entities:FindAllByName(SET_FORCE_HERO)
        if  PlayerResource:GetPlayerCount() > 1 and #zhugongTab == 1 then
            GameRules:SetGameWinner(zhugongTab[1]:GetTeamNumber())
        elseif #zhugongTab == 0 then
            GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
        end
    elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
        return nil
    end
	return 1
end

function GameMode:createnewherotest( data ) 

    local hero   = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
    local teamid = 3
    if data.good then teamid = PlayerResource:GetCustomTeamAssignment(data.PlayerID) end 
    CreateUnitByNameAsync( data.way, Entities:FindByName(nil,"creep_birth_"..(hero:GetTeamNumber()-5).."_"..(teamid-3)):GetAbsOrigin(), true, nil, nil, teamid,
        function( v ) 
            v:SetControllableByPlayer( data.PlayerID, false ) 
            v:Hold() 
            v:SetIdleAcquire( false ) 
            v:SetAcquisitionRange( 0 ) 
            v.enemy=true
        end )  
end

function GameMode:refreshlist()
    for name,info in pairs(LoadKeyValues('scripts/npc/npc_heroes_custom.txt'))do 
        if info ~= 1 and name ~= SET_FORCE_HERO then 
            CustomGameEventManager:Send_ServerToAllClients('hero_info', {name=name,hero=info.override_hero}) 
        end
    end
end



function GameMode:ExampleConsoleCommand()
    local  cmdPlayer = Convars:GetCommandClient()
    if not cmdPlayer then return end
    if not cmdPlayer:GetPlayerID() or cmdPlayer:GetPlayerID()==-1 then return end
    
    -- Do something here for the player who called this command
    PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)

    -- print("*********************************************")
end

function GameMode:OnHeroInGame(hero)
    -- print("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

    -- Store a reference to the player handle inside this hero handle.
    hero.player = PlayerResource:GetPlayer(hero:GetPlayerID())
    -- Store the player's name inside this hero handle.
    hero.playerName = PlayerResource:GetPlayerName(hero:GetPlayerID())

    local innate_ability = hero:FindAbilityByName("builder_invulnerable")
    if innate_ability then
        innate_ability:SetLevel(1)
        innate_ability:SetHidden(true)
    end
end

-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
    -- print("[BAREBONES] GameRules State Changed")
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
    ---- print("[BAREBONES] Entity Hurt")
    ---- DeepPrintTable(keys)
    if keys.entindex_attacker then
        local entCause = EntIndexToHScript(keys.entindex_attacker)
    end
    if keys.entindex_killed then
        local entVictim = EntIndexToHScript(keys.entindex_killed)
    end
end