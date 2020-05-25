playerallstart  = {}--所有人是否选好主公
_G.buildpostab  = {}--所有单位位置
_G.GAME_ROUND   = 0--初始化轮数
--GAME_STATS   = 1--0准备，1倒计时，2对战
   tkItemList   = LoadKeyValues('scripts/npc/npc_items_custom.txt')
   tkUnitList   = LoadKeyValues('scripts/npc/npc_units_custom.txt')
   tkHeroList   = LoadKeyValues('scripts/npc/npc_heroes_custom.txt')
   tkShipList   = LoadKeyValues('scripts/npc/npc_ships_custom.txt')
   DamageKV     = LoadKeyValues("scripts/damage_table.kv")
_G.ItemHeroName = {}-- k,v = i,item_hero_xxxx
_G.tkHeroName   = {['weiguo']={},['shuguo']={},['wuguo']={},['qunxiong']={},['all']={}}
_G.ShipNeedom   = {}
_G.npcBaseType  = {}

CustomNetTables:SetTableValue( "game_stat", "game_round_stat",{1} )

if #_G.ItemHeroName == 0  then
  for item, info in pairs(tkItemList) do                  
      if  info ~= 1 then
          if  string.find(item,"hero") or string.find(item,"wujiang") then 
              table.insert( _G.ItemHeroName, item ) 
          end
          --if info["Effect"] then  end
          --还可以筛选出装备，
      end
  end
end