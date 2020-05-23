require("root/PrecacheList")

-- Create the game mode when we activate
function Activate()
	GameRules.CAddonGameMode = GameMode()
	GameRules.CAddonGameMode:InitGameMode()
end



