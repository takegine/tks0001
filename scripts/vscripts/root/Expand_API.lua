function CDOTAGamerules:SetGoldPerTick(gold) 

    GAMERULE_GOLD_PER_TICK = GAMERULE_GOLD_PER_TICK
    if gold then GAMERULE_GOLD_PER_TICK = gold return end

    for i=0,PlayerResource:GetPlayerCount() do
        if  PlayerResource:HasSelectedHero( i )  then
            PlayerResource:SetGold( i , 
            PlayerResource:GetGold( i )+(GAMERULE_GOLD_PER_TICK or 0 ), false)
        end
    end
end

function CDOTAGamerules:SetGoldTickTime(TickTime)

    local timerName = DoUniqueString("GoldenThink")

    GameRules.__vTimerNamerTable__ = GameRules.__vTimerNamerTable__ or {}
    GameRules.__vTimerNamerTable__[timerName] = true

    GameRules:GetGameModeEntity():SetContextThink(timerName,function()
        if GameRules.__vTimerNamerTable__[timerName] then
            GameRules:SetGoldPerTick()
            return TickTime 
        else
            return nil
        end
    end, TickTime)

    return timerName

end


function CDOTA_BaseNPC:CheckLevel(lvl)
    
    lvl = lvl or self:GetLevel()+1

    while( self:GetLevel() < lvl ) do
            if   self:IsHero() then
                 self:HeroLevelUp( false )
            else self:CreatureLevelUp( 1 )
            end
    end
    
    for i=0,15 do 
        if  self:GetAbilityByIndex(i) then 
            self:GetAbilityByIndex(i):SetLevel(lvl) 
        end 
    end
end