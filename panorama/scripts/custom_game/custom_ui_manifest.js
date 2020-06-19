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

// GameUI.CustomUIConfig().team_colors = {}
// GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_1] = "#38902d";
// GameUI.CustomUIConfig().team_colors[DOTATeam_t.DOTA_TEAM_CUSTOM_2] = "#994a31";


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

// NoGlyphAndRadar.FindChildTraverse("GlyphScanContainer").style.visibility = "collapse";
// NoKDA.FindChildTraverse("quickstats").style.visibility = "collapse";
// NoKDA.FindChildTraverse("PlusStatus").style.visibility = "collapse";

// $.Msg("sssss",DotaDefaultUIElement_t);
// GameUI.CustomUIConfig().dotaUi = newUI;

//newUI.FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("StatBranch").BCreateChildren("<Panel id='herocountry' style='width:62px;height:62px;' class='ShowStatBranch'><Label id='herocountrytext' text='' style='font-size:60px;' class='ShowStatBranch'/></Panel>");
//GameEvents.Subscribe( "playergetcountry", upcountry)
//function upcountry(data){$("#herocountrytext").text=data.event}

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