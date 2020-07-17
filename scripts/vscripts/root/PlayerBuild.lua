
-- skill_player_price
-- skill_player_lvlup
-- skill_player_lvlkeep
-- skill_player_onsale
-- skill_player_sell
-- skill_player_toggle

require('root/ToolsFromX')
----------------------------------------------------------------------------
skill_player_price = skill_player_price or {}

LinkLuaModifier( "modifier_skill_player_price", "root/PlayerBuild.lua", LUA_MODIFIER_MOTION_NONE )

function skill_player_price:IsHidden() return true end
function skill_player_price:OnSpellStart()

    local caster   = self:GetCaster()
    local modiName = 'modifier_skill_player_price'

    if not caster:IsHero() then return end
    if not caster:HasModifier(modiName) then
           caster:AddNewModifier( caster, self , modiName , {} )
    end
    
    caster:SetModifierStackCount( modiName, caster, -1-RandomInt(11, 20) )

end

modifier_skill_player_price = modifier_skill_player_price or {}
function modifier_skill_player_price:IsHidden()		return false end
function modifier_skill_player_price:IsPurgable() 	return false end
function modifier_skill_player_price:RemoveOnDeath()	return false end

function modifier_skill_player_price:GetTexture () 
    local count  = -1-self:GetStackCount()

    if count <15 then
        return "player/gold-low" 
    elseif count <17 then
        return "player/gold-middle" 
    elseif count <21 then
        return "player/gold-high" 
    else
        return "player/PASBTNJinsha" 
    end
end

function modifier_skill_player_price:OnCreated( kv )
    local caster   = self:GetParent()
    self.basepirce = LoadKeyValues('scripts/npc/npc_heroes_custom.txt')[caster:GetName()]['TksPayedGold']*caster:GetLevel() + 385
end

function modifier_skill_player_price:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end
function modifier_skill_player_price:OnTooltip(keys)
    local count = -1-self:GetStackCount()
	return 0.05 * count * self.basepirce
end

skill_player_lvlup = skill_player_lvlup or {}
--------------------------------------------------------------------------------

function skill_player_lvlup:CastFilterResult() 
    if not IsServer() then return end
    
    if CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]~=0 then return UF_FAIL_CUSTOM end

    local caster   = self:GetCaster()
    local plid     = caster:GetPlayerOwnerID()
    local hero     = PlayerResource:GetSelectedHeroEntity(plid)
    local basecost = self:GetLevelSpecialValueFor("basecost", self:GetLevel() )
    local vipcost  = self:GetLevelSpecialValueFor("vipcost", self:GetLevel() )

    local viptable = LoadKeyValues("scripts/npc/vipcost.kv")

    local findcost = viptable[caster:GetName()] and vipcost or basecost

    if caster:GetLevel()==10 
    or hero:GetGold()<findcost 
    then  return UF_FAIL_CUSTOM 
    end
    
    return 0
end

function skill_player_lvlup:GetCustomCastError() 
    if self:GetCaster():GetLevel()==10 then return "MAX LEVEL" end
    return 'poorguy'
end

function skill_player_lvlup:OnSpellStart()
    
    local caster   = self:GetCaster()
    local plid     = caster:GetPlayerOwnerID()
    local hero     = PlayerResource:GetSelectedHeroEntity(plid)
    local basecost = self:GetLevelSpecialValueFor("basecost", self:GetLevel() )
    local vipcost  = self:GetLevelSpecialValueFor("vipcost", self:GetLevel() )

    local viptable = LoadKeyValues("scripts/npc/vipcost.kv")

    local findcost = viptable[caster:GetName()] and vipcost or basecost

    if PlayerResource:Pay( plid, findcost ) then 
        caster:CheckLevel() 
        caster:FindAbilityByName('skill_player_price'):CastAbility()
    end
end



skill_player_lvlkeep = skill_player_lvlkeep or {}
--------------------------------------------------------------------------------
function skill_player_lvlkeep:CastFilterResult(   ) 
    
    if CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]~=0 then return UF_FAIL_CUSTOM end
    
    return 0 
end
function skill_player_lvlkeep:GetCustomCastError( ) return ErrorTarget(  ) end

function skill_player_lvlkeep:OnSpellStart()
    
    local caster   = self:GetCaster()
    local plid     = caster:GetPlayerOwnerID()
    local hero     = PlayerResource:GetSelectedHeroEntity(plid)

    for i= 1,10 do
        if not caster:FindAbilityByName('skill_player_lvlup'):CastAbility() then break end
    end
end

skill_player_onsale = skill_player_onsale or {}
--------------------------------------------------------------------------------
function skill_player_onsale:CastFilterResult(   ) 
    
    if CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]~=0 then return UF_FAIL_CUSTOM end
    
    return 0 
end
function skill_player_onsale:GetCustomCastError( ) return ErrorTarget(  ) end
function skill_player_onsale:OnSpellStart()
    
    local caster   = self:GetCaster()
    local plid     = caster:GetPlayerOwnerID()
    local tPop     = CustomNetTables:GetTableValue( "Hero_Population", tostring(plid)) 
    local price    = caster:IsRealHero() and caster:FindModifierByName( 'modifier_skill_player_price'):OnTooltip() or caster.price or 0

    if  PlayerResource:Pay( plid, -price ) then
        if not caster.bench then
            tPop.popNow = tPop.popNow - caster.popuse  
            CustomNetTables:SetTableValue( "Hero_Population", tostring(plid),tPop) 
        end
        caster:Destroy()
    end
    
end


skill_player_toggle = skill_player_toggle or {}
--------------------------------------------------------------------------------
function skill_player_toggle:CastFilterResult( ) 
    if not IsServer() then return end
    
    if CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]~=0 then return UF_FAIL_CUSTOM end

    local caster   = self:GetCaster()
    local owner    = caster:GetOwner()
    local hero     = owner:GetPlayerOwner()
    local playerID = tostring(owner:GetPlayerOwnerID())
    local tPop     = CustomNetTables:GetTableValue( "Hero_Population", playerID) 
    tPop.popNow = tPop.popNow + self:GetCaster().popuse
    if tPop.popNow > tPop.popMax then 
        self.Result="outofyourpop"
        return UF_FAIL_CUSTOM
    end
    
    return 0
end

function skill_player_toggle:GetCustomCastError() 
    
    if self.Result=="outofyourpop" then 
        self.Result=nil
        return "#outofyourpop" end

    return "....."

end

function skill_player_toggle:OnSpellStart()
        
    --local target   = self:GetCursorTarget()
    local caster   = self:GetCaster()
    local owner    = caster:GetOwner()
    local hero     = owner:GetPlayerOwner()
    local playerID = tostring(owner:GetPlayerOwnerID())
   -- local onback   = false
    local iTeam    = caster:GetTeamNumber()-5
    local lock  = "skill_player_lock"
    local tPop     = CustomNetTables:GetTableValue( "Hero_Population", playerID) 
    --item:SetPurchaseTime(0)
    --item:SetPurchaser( caster )

    if  caster:HasModifier(lock..'_bench') then
        tPop.popNow = tPop.popNow + caster.popuse
        --if tPop.popNow > tPop.popMax then return end
        caster.bench = nil
        caster:RemoveModifierByName(lock..'_bench')
        caster:SetOrigin(Entities:Pos(iTeam, 2)+ Vector (RandomFloat(-300, 300), RandomFloat(-100, 200), 0) )
        caster:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
    
        CustomNetTables:SetTableValue( "Hero_Population", playerID,tPop) 
    else
        local x = owner.Ticket and 6 or 5
        for i = 1 , x do
            local posempty   = true
            local itemPos    = Entities:FindByName( nil, "dianjiangtai_"..iTeam.."_"..i):GetAbsOrigin()
            local isemptytab = Entities:FindAllInSphere(itemPos,100)
            -- print(i,x)
            -- print_r(isemptytab)
            for _,v in pairs(isemptytab) do
                if v.bFirstSpawned then posempty=false break end
            end
            if  posempty then
                caster.bench = true
                caster:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
                caster:FindAbilityByName(lock):ApplyDataDrivenModifier(caster, caster, lock..'_bench', nil)
                caster:SetOrigin(itemPos)
                tPop.popNow = tPop.popNow - caster.popuse  
                CustomNetTables:SetTableValue( "Hero_Population", playerID,tPop)
                break
            end
        end
    end

    -- --在记录表中删掉这个单位
    -- if _G.buildpostab[iTeam] then
    --     table.foreach(_G.buildpostab[iTeam],function(k,v) 
    --         if v.unit==caster:GetUnitName() and v.origin==caster:GetOrigin() then v=nil end 
    --     end)
    -- end
        
    
end

skill_player_sell = skill_player_sell or {}
--------------------------------------------------------------------------------
function skill_player_sell:CastFilterResultTarget(  hTarget ) return ChecktTarget( { hTarget = hTarget, team = self:GetCaster():GetTeamNumber()} ) end
function skill_player_sell:GetCustomCastErrorTarget(hTarget ) return ErrorTarget( hTarget ) end
function skill_player_sell:OnSpellStart()
    local target   = self:GetCursorTarget()
    local caster   = self:GetCaster()
    local plid     = caster:GetPlayerOwnerID()

    target:FindAbilityByName('skill_player_onsale'):CastAbility()
    
end

--------------------------------------------------------------------------------
function ChecktTarget(  data )
    hTarget = data.hTarget
    team    = data.team
    if hTarget:GetName()=="npc_dota_hero_phoenix" then return UF_FAIL_COURIER end
    if CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]~=0 then return UF_FAIL_CUSTOM end
    return UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, team )
end

function ErrorTarget( hTarget )
    local stat = CustomNetTables:GetTableValue( "game_stat", "game_round_stat")["1"]

    --if self:GetCaster() == hTarget then return "#dota_hud_error_cant_cast_on_self" 
    if stat==1 then return "#OnGameRoundChange" end
    if stat==2 then return "#OnGameInProgress"  end
    -- if hTarget:IsAncient() then
    --     return "#dota_hud_error_cant_cast_on_ancient"
    -- end

    -- if hTarget:IsCreep() and ( not self:GetCaster():HasScepter() ) then
    --     return "#dota_hud_error_cant_cast_on_creep"
    --end
    return ""
end






