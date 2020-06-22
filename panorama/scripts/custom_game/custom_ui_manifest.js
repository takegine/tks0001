GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_MINIMAP,false);
GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_HEROES,false);//HUD顶部的英雄与队伍
GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS,false);//建议购买的面板

GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER,false);//信使
GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PROTECT,false);
GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS,false);
// GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_SHOP,false);



// GameUI.CustomUIConfig().Creator = [ ];
// GameUI.CustomUIConfig().ActiveDevelopers = [  ];
// GameUI.CustomUIConfig().InactiveDevelopers = [  ];

// GameUI.CustomUIConfig().multiteam_top_scoreboard =
// {
//     reorder_team_scores: true,
//     LeftInjectXMLFile: "file://{resources}/layout/custom_game/legion_round_left.xml",
// };

GameUI.CustomUIConfig().team_colors = {}
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_1] = "#38902d";
GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_2] = "#994a31";

// var rootUI = $.GetContextPanel().GetParent().GetParent();
// var newUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block");
// var NoGlyphAndRadar = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("minimap_container");
// var NoTPScrollUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block");
// var NoKDA = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("stackable_side_panels");
// var NoNewRightPanel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block");
// var NoNeutralItemSlot = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block");

// var pppUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("shop_launcher_block");
// pppUI.FindChildTraverse("shop_launcher_bg").style.visibility = "collapse";
// pppUI.FindChildTraverse("quickbuy").FindChildTraverse("ShopCourierControls").FindChildTraverse("courier").style.visibility = "collapse";
// pppUI.FindChildTraverse("quickbuy").FindChildTraverse("ShopCourierControls").FindChildTraverse("ShopButton").FindChildTraverse("BuybackHeader").style.visibility = "collapse";
// pppUI.FindChildTraverse("quickbuy").FindChildTraverse("ShopCourierControls").FindChildTraverse("ShopButton").style.width="128px";
// pppUI.FindChildTraverse("quickbuy").FindChildTraverse("QuickBuyRows").style.visibility = "collapse";
// pppUI.FindChildTraverse("quickbuy").FindChildTraverse("ShopCourierControls").style.marginLeft = "64px";
// pppUI.FindChildTraverse("stash").style.visibility = "collapse";


// newUI.FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("StatBranch").style.visibility = "collapse";

// var shopUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("shop");
// shopUI.FindChildTraverse("GuideFlyout").style.visibility = "collapse";
// shopUI.FindChildTraverse("Main").FindChildTraverse("ItemCombinesAndBasicItemsContainer").style.visibility = "collapse";

//  NoGlyphAndRadar.FindChildTraverse("GlyphScanContainer").style.visibility = "collapse";
// NoKDA.FindChildTraverse("quickstats").style.visibility = "collapse";
// NoKDA.FindChildTraverse("PlusStatus").style.visibility = "collapse";

// $.Msg("sssss",DotaDefaultUIElement_t);
// GameUI.CustomUIConfig().dotaUi = newUI;

// newUI.FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("StatBranch").BCreateChildren("<Panel id='herocountry' style='width:62px;height:62px;' class='ShowStatBranch'><Label id='herocountrytext' text='' style='font-size:60px;' class='ShowStatBranch'/></Panel>");
// GameEvents.Subscribe( "playergetcountry", upcountry)
// function upcountry(data){$("#herocountrytext").text=data.event}

// // 天赋树
//     // 首先，在游戏运行的情况下按F6，打开UI调试面板，然后在dota里点击要清除的区块。
//     // 在F6里就会显示出该区块在UI里的ID，这里是StatBranch，然后
//     var UI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("StatBranch");
//     // $.GetContextPanel()
//     // 这个是定位当前所在的panel在哪儿，因为custom_ui_manifest.xml不是位于最高层panel，不能直接查找子元素，
//     // 所以要使用GetParent()，找出上一层，看是否包含StatBranch，没有就继续再上一层。
//     // 当来到包含StatBranch的panel后，
//     // 使用FindChildTraverse("StatBranch")，这个是穿透式的在当前panel所包含的所有子元素里查找，不用一层一层往下找了。然后就可以设置该区块不可看见了
//     UI.visible = false;
//     // 至于这2条，可有可无
//     UI.SetPanelEvent("onmouseover", function(){});
//     UI.SetPanelEvent("onactivate", function(){});
//     // 现在天赋树在面板上已经不显示了，但是当等级到达10级时又会突然跳出来在第一个技能的位置。这时通过LUA设置技能点数为0，可以取消掉，但是比较麻烦，到15级又要设置一次。
//     // 还是直接在JS里设置:
//     UI.FindChildTraverse("LevelUpTab").visible = false;// tab
//     UI.FindChildTraverse("LevelUpGlow").visible = false;// talent
//     // 就可以直接干掉天赋树了

//     function disTree() {
//         // $.Msg("Disable Talent Tree")
//         var x = $.GetContextPanel().GetParent().GetParent().GetParent();
//             x = x.FindChildTraverse('HUDElements').FindChildTraverse('lower_hud').FindChildTraverse('center_with_stats').FindChildTraverse('center_block')

//         var level_stats_frame = x.FindChildTraverse('level_stats_frame')
//             level_stats_frame.RemoveClass('CanLevelStats')
//             level_stats_frame.hittest = false
//             level_stats_frame.hittestchildren = false
//             level_stats_frame.FindChildTraverse('LevelUpBurstFX').visible = false
//             level_stats_frame.FindChildTraverse('LevelUpTab').FindChildTraverse('LevelUpButton').visible = false
//             level_stats_frame.FindChildTraverse('LevelUpTab').FindChildTraverse('LevelUpIcon').visible = false
            
//             x = x.FindChildTraverse('AbilitiesAndStatBranch').FindChildTraverse('StatBranch')
//             x.hittest = false
//             x.hittestchildren = false
//     }
    var newUI = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements");
    // var centerBlock = newUI.FindChildTraverse("center_block");
    
    newUI.FindChildTraverse("RadarButton").style.visibility = "collapse";  
    newUI.FindChildTraverse("StatBranch").visible = false;
    //you are not spawning the talent UI, fuck off (Disabling mouseover and onactivate)
    newUI.FindChildTraverse("StatBranch").SetPanelEvent("onmouseover", function(){});
    newUI.FindChildTraverse("StatBranch").SetPanelEvent("onactivate", function(){});
    

 

//调转摄像头
function CameraRotateHorizontal(data) {
    GameUI.SetCameraYaw(data["angle"])
}
GameEvents.Subscribe( "CameraRotateHorizontal", CameraRotateHorizontal)

//两个异步用法
function Delay(secs){
    return new Promise((resolve) =>{
        $.Schedule(secs.resolve);
        }    )
}

function Wait(delay,cb) {
    return $.Schedule(delay,cb);
    
}