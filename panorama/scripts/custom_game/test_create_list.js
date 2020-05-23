function Yes()
{
    //$.Msg();
    if  ( $("#AllHeroes").visible == true){   $("#AllHeroes").visible = false;         }
    else{ $("#AllHeroes").visible = true;
           // if ($("#ShopInfo").BHasClass("ShopInfoAnim"))
          //      {
          //       $("#ShopInfo").RemoveClass("ShopInfoAnim");
          //       $("#ShopInfo").AddClass("ShopInfoAnim");    }   
                
                GameEvents.SendCustomGameEventToServer( "refreshlist", {} );
        }
    //$("#readytext").RemoveClass("ElementShopText");//移除闪烁特效
    //$("#ElementShop").RemoveClass("ElementShopText");//移除闪烁特效
}

function function_name() {
    // body...
    $.Msg("12312")
    GameEvents.SendCustomGameEventToServer( "createnewherotest", {} );
}
function heroinfo(params) {
    var name=params.name
    var hero=params.hero
    //var num=params.num
    //$.Msg(params)
    $.Msg(name," _ ",hero)
    //for(i=num-1;i>num;i++){ 
        
        if ($('#AllHeroes').FindChild('panel_'+name)){$('#AllHeroes').FindChild('panel_'+name).DeleteAsync(0);}
        
            $('#AllHeroes').BCreateChildren("<Panel id='panel_"+name+"' style='flow-children:left;' />" );
            $('#panel_'+name).BCreateChildren("<Label text='"+$.Localize(hero)+"' style='font-size:25px;' />" );
            $('#panel_'+name).BCreateChildren("<Button id='hero"+name+"_1' style='margin:5px;border: 1px solid #eeeeee;' />" );
            //$.Schedule(0.1,function () {
            $('#hero'+name+"_1").BCreateChildren("<Label text='good' style='font-size:25px;' />" );
            //$('#'+name).GetChild(0).text=
            //$("#AllHeroes").BCreateChildren("<DOTAItemImage itemname='"name"' class='shopitem' style='margin-top:20px; margin-left:20px;'/>");
            $('#hero'+name+"_1").SetPanelEvent('onactivate',function() { 
                //var stat=CustomNetTables.GetTableValue( "game_stat", "game_round_stat" )[1]
                 //   if(stat=="1"){GameUI.SendCustomHUDError( "#OnGameRoundChange", "Tutorial.Notice.Speech" );return}
                //else if(stat=="2"){GameUI.SendCustomHUDError( "#OnGameInProgress", "Tutorial.Notice.Speech" );return}
                //else{GameEvents.SendCustomGameEventToServer( "find_wujiang", {id: Players.GetLocalPlayer(),way:name} ); }
                GameEvents.SendCustomGameEventToServer( "createnewherotest", {id: Players.GetLocalPlayer(),way:hero,good:true} );
                }  ) ;
            $('#panel_'+name).BCreateChildren("<Button id='hero"+name+"_2' style='margin:5px;border: 1px solid #eeeeee;' />" );
            $('#hero'+name+"_2").BCreateChildren("<Label text='bad' style='font-size:25px;' />" );
            $('#hero'+name+"_2").SetPanelEvent('onactivate',function() { GameEvents.SendCustomGameEventToServer( "createnewherotest", {id: Players.GetLocalPlayer(),way:hero} ); }  ) ;
            //})
            
           // }
        //}
}
(function()//立即执行的函数
{
    //CustomNetTables.SubscribeNetTableListener( "Elements_Tabel", UpdateShop );
    GameEvents.Subscribe( "hero_info", heroinfo)
    $("#ShopInfo").visible = false;
    
})();