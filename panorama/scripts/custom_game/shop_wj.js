function Yes()
{
    $.Msg("open");
    if  ( $("#ShopInfo").visible == true){   $("#ShopInfo").visible = false;         }
    else{ $("#ShopInfo").visible = true;
            if ($("#ShopInfo").BHasClass("ShopInfoAnim"))
                {
                 $("#ShopInfo").RemoveClass("ShopInfoAnim");
                 $("#ShopInfo").AddClass("ShopInfoAnim");    }   
                
        }
    $("#readytext").RemoveClass("ElementShopText");//移除闪烁特效
    $("#ElementShop").RemoveClass("ElementShopText");//移除闪烁特效
}

(function()//立即执行的函数
{
   // CustomNetTables.SubscribeNetTableListener( "Elements_Tabel", UpdateShop );
    
    $("#ShopInfo").visible = false;
    
})();