GameRules:SetPreGameTime(SET_PREGAME_TIME)
    GameRules:SetStartingGold(SET_STARTING_GOLD)
    --GameRules:SetStrategyTime( 0 )
    --GameRules:SetHeroSelectionTime(0)
    --GameRules:SetHeroSelectPenaltyTime(0)
    GameRules:SetUseUniversalShopMode(true)
    GameRules:SetHeroRespawnEnabled( false )
    GameRules:SetCustomGameSetupAutoLaunchDelay(SET_UP_AUTO_LAUNCH_DELAY)
    GameRules:EnableCustomGameSetupAutoLaunch(true)
    
    
    for i in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
    GameRules:SetCustomGameTeamMaxPlayers( i, CUSTOM_TEAM_PLAYER_COUNT[i] ) 
    end
    --[[
    local i = 0
    local j = 0 
    local k = 0 
    if      GetMapName() == "map1" then i=1 j=0 k=0 
    elseif  GetMapName() == "map2" then i=1 j=1 k=0  
    elseif  GetMapName() == "map3" then i=1 j=1 k=0  
    elseif  GetMapName() == "map8" then i=1 j=1 k=1  
    elseif  GetMapName() == "map0" then i=1 j=1 k=1  
    end

    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 0 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS , 0 )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, i )--CUSTOM 6
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, j )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_3, k )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_4, k )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_5, k )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_6, k )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_7, k )
    GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_8, k )
]]
    GetNewHero:listen()