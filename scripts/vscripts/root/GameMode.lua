mode=GameRules:GetGameModeEntity()
mode:SetCustomHeroMaxLevel(MAX_LEVEL)
mode:SetCustomGameForceHero(SET_FORCE_HERO)

--游戏性
mode:SetBuybackEnabled(false)
--mode:SetUseCustomHeroLevels(true)
--mode:SetCustomXPRequiredToReachNextLevel(Custom_XP_Required)
mode:SetLoseGoldOnDeath(false)
mode:SetTopBarTeamValuesVisible( true )
mode:SetStashPurchasingDisabled( true )
mode:SetStickyItemDisabled(true)
mode:SetFogOfWarDisabled( FOG_OF_WAR_DISABLE )

--显示
mode:SetCameraDistanceOverride( 1000)--设置镜头
mode:SetHUDVisible(18,false)
mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_DAMAGE, 5 )
mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_HP, 100 )
mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_STRENGTH_HP_REGEN, 0 )
mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_DAMAGE, 5 )
mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_ARMOR, 0.25 )
mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED, 0 )
mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE, 5 )
mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_MANA, 0.2 )
mode:SetCustomAttributeDerivedStatValue( DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN, 0.01 )--失效
mode:SetSendToStashEnabled( false )
mode:SetHudCombatEventsDisabled( true )
