var maxhero = 10

function gofind(i){
    if($('#DianJiangTai').GetChild(maxhero-1)){
        GameUI.SendCustomHUDError( "#fulloftable", "ui_find_match_change_options" );
        return
        }
    else if(Players.GetGold(Players.GetLocalPlayer() )<100 ){
        GameUI.SendCustomHUDError( "#poorguy", "General.NoGold" ) ;
        return
        }
    else{ 
        GameEvents.SendCustomGameEventToServer( "find_wujiang", {id: Players.GetLocalPlayer(),way: i} );  
        } 
            
}
function goget(i) {
    var iWays = $('#DianJiangTai').FindChild("hero"+i).GetChild(0).itemname 
            //iWays = $.GetContextPanel().GetParent().id()
    var tPop=CustomNetTables.GetTableValue( "Hero_Population", Players.GetLocalPlayer())
    var stat=CustomNetTables.GetTableValue( "game_stat", "game_round_stat" )[1]
        if(!iWays ){ return }
    else if(stat=="1"){
            GameUI.SendCustomHUDError( "#OnGameRoundChange", "Tutorial.Notice.Speech" )
            return }
    else if(stat=="2"){
            GameUI.SendCustomHUDError( "#OnGameInProgress", "Tutorial.Notice.Speech" )
            return }
    else if(!(tPop['popNow']<tPop['popMax'])){
            GameUI.SendCustomHUDError( "#outofyourpop", "Loot_Drop_Stinger_Short" )
            return }
    else if(Players.GetGold(Players.GetLocalPlayer() )<100 ){
            GameUI.SendCustomHUDError( "#poorguy", "General.NoGold" ) ;
            return }
    else {  $.Msg('input='+i+iWays);
            GameEvents.SendCustomGameEventToServer( "get_wujiang", {id: Players.GetLocalPlayer(),way: iWays,No:i} );
            }
}
function showtab() {
    if  (   $("#DianJiangTai").visible){ $("#DianJiangTai").visible = false;}
    else{   $("#DianJiangTai").visible = true;}
}
function openPanel(i){
    $.Msg("openPanel");	
	if  (   $("#find"+i).visible){  
	 	    $("#find"+i).visible = false;}
	else{   $("#find"+i).visible = true;
        if ($("#find"+i).BHasClass("find"+i+"AnimO")){
            $("#find"+i).RemoveClass("find"+i+"AnimO");
            $("#find"+i).AddClass("find"+i+"AnimO");
            }
        else{
            $("#find"+i).AddClass("find"+i+"AnimO");
            }     
        }
    if (i==1){i=2;openPanel(i)}
    //if (i==2){i=3;openPanel(i)} 
    $("#soujiangtext").RemoveClass("ElementShopText");//移除闪烁特效
    $("#ElementShop").RemoveClass("ElementShopText");//移除闪烁特效

}

function close(i){
    $.Msg("close");
    if  (    $("#find"+i).visible == true){  
        if ( $("#find"+i).BHasClass("find"+i+"AnimC"))
        	{
             $("#find"+i).RemoveClass("find"+i+"AnimC");
             $("#find"+i).AddClass("find"+i+"AnimC");
        	}
        else{$("#find"+i).AddClass("find"+i+"AnimC");
    		}
    		//$("#find"+i).visible = false;
    		//$("#find"+i).setTimeout(function () {$("#find"+i).visible = false;$.Msg("close1");}, 600);
    		$.Schedule(0.5,function(){$("#find1").visible = false;$("#find2").visible = false;});            
            //if (i==2){i=3;close(i)} 
        }
        if (i==1){i=2;close(i)} 
}

function shopUp(data){
    if(data.event == "noget"){GameUI.SendCustomHUDError( "#noget", "ui_find_match_change_options" )}
    else if(data.event == "poorguy"){ GameUI.SendCustomHUDError( "#poorguy", "General.NoGold" )    }
    else if(typeof(data.event) == "number"){
            //$("#gethero3").visible = false;
            //$('#hero0').GetChild(0).itemname = "item_empty_block";
            //$('#hero0').GetChild(1).text = "item_empty_block";
            RemoveitemButton(data.event)
            //CreatePanel(data.event,"item_empty_block")
            }    
    else{
        
        for (var i=1;i<maxhero+1;i++){
            if ( !$('#DianJiangTai').FindChild("hero"+i)) {
                CreateitemButton(i,data.event)
                //$.Msg($('#DianJiangTai').GetChild(i).GetChild(1).text)
                break;} 
            
            }
        /*
        else if ( $('#DianJiangTai').GetChild(i).GetChild(0).itemname =="item_empty_block") {
                RemovePanel(i)
                CreatePanel(i,data.event)
                break;}
        for (var i=1;i<maxhero+1;i++){
           if ( $('#DianJiangTai').FindChild("hero"+i) ){
                
            $.Msg($('#DianJiangTai').GetChild(i).GetChild(0).itemname)
            }            
        }*/
        $.Msg("shopUp",data,data.event);
        $("#DianJiangTai").visible = true;
        //$("#gethero3").visible = true;
    }
}

function CreateitemButton(num,itemName) {
    var NewButton = $.CreatePanel('Button', $('#DianJiangTai'),"hero"+num);
        NewButton.BLoadLayoutSnippet("QuestLine");
        NewButton.GetChild(0).itemname = itemName
        NewButton.GetChild(1).text = $.Localize("DOTA_Tooltip_ability_"+itemName)
        NewButton.SetPanelEvent('onactivate',function() {    goget(num); }  ) ;
        NewButton.SetPanelEvent('oncontextmenu',function() { CreateitemPanel(num,itemName); }  ) ;
    //NewButton.GetChild(0).id = String(itemName)
    //NewButton.AddClass("Panle_MarginStyle") 
    
}

function RemoveitemButton(num) {
    var RemoveButton=$('#DianJiangTai').FindChild("hero"+num)
        RemoveButton.deleted = true;
        RemoveButton.DeleteAsync(0);
}

function CreateitemPanel(num,itemName) {
    if ( $('#DianJiangTai').GetParent().FindChild("itemMenu")){ RemoveitemPanel() }
    //var localnum
    var NewPanel = $.CreatePanel('Panel',$('#DianJiangTai').GetParent(),"itemMenu");
        NewPanel.BLoadLayoutSnippet("RightClick"); 
        NewPanel.GetParent().hittest=true;
        NewPanel.GetParent().SetPanelEvent('onactivate',function() { RemoveitemPanel(); }  ) ; 
      //NewPanel.GetChild(0).SetDialogVariable('item_panel_name', itemName)
        NewPanel.GetChild(0).SetPanelEvent('onactivate',function() { 
            GameUI.SendCustomHUDError( "#noreadyforlvlup", "Loot_Drop_Stinger_Short" );
          //GameEvents.SendCustomGameEventToServer( "item_lvl_up", {num: num,item:itemName} ); 
            RemoveitemPanel();}  ) ;
        NewPanel.GetChild(1).SetPanelEvent('onactivate',function() { 
            GameEvents.SendCustomGameEventToServer( "item_on_sell", {num: num,item:itemName} ); 
            RemoveitemPanel();}  ) ;

    for (var i=0;i<maxhero+1;i++){
        if ( $('#DianJiangTai').FindChild("hero"+num) == $('#DianJiangTai').GetChild(i)) {
            var localnum=i
            break;} 
        }
        $.Msg("xxx",localnum);
        NewPanel.SetPositionInPixels( 89.5*localnum-510 , 750, 0);
    //312 _ 485 _ 58 _ 0 _ 49 _ 0.614814817905426 _ 312 _ 0 _ 553 _ 0.614814817905426
    //var posa=$('#DianJiangTai').GetPositionWithinWindow()
    //var posb=$('#DianJiangTai').GetParent().GetPositionWithinWindow()
    //$.Msg(posa.x," _ ",posa.y," _ ",
    //$('#DianJiangTai').GetChild(0).actualxoffset," _ ",
    //$('#DianJiangTai').GetChild(0).scrolloffset_x," _ ",
    //$('#DianJiangTai').GetChild(0).actuallayoutwidth," _ ",
    //$('#DianJiangTai').GetChild(0).actualuiscale_y," _ ",
    //$('#DianJiangTai').actualxoffset," _ ",
    //$('#DianJiangTai').scrolloffset_x," _ ",
    //$('#DianJiangTai').actuallayoutwidth," _ ",
    //$('#DianJiangTai').actualuiscale_y,)
    //var tttx=90*localnum-300*$('#DianJiangTai').actualuiscale_x/0.614814817905426
    //var ttty=750*$('#DianJiangTai').actualuiscale_y/0.614814817905426
    //NewPanel.style.transform=translate2d( 1153.0+'px', 914.0+'px'  );
       //NewPanel.style.marginLeft = $('#DianJiangTai').actuallayoutwidth*100+"%";
    //if(localnum<0){ 
        //NewPanel.style.marginLeft = String(80+88*localnum)+"px";
    //}
        //NewPanel.SetPositionInPixels(96*localnum,0px,0px)
    //else{
        //NewPanel.SetPositionInPixels(96*localnum,0px,0px)
        //NewPanel.style.marginLeft = String(192+2*(90+90*localnum))+"px";
    //}
    
}
function RemoveitemPanel() {
    var RemoveButton=$("#itemMenu")
    RemoveButton.GetParent().hittest=false;
    RemoveButton.deleted = true;
    RemoveButton.DeleteAsync(0);
}

/*function OnGameInProgress(data){
    if (data.event = 0){  $("#NoPoint").visible = true; }
    if (data.event = 1){  $("#NoPoint").visible = false;}
    if (data.event = 2){  $("#NoPoint").visible = true; }
}
GameEvents.Subscribe( "OnGameInProgress", OnGameInProgress)*/
(function(){    
    GameEvents.Subscribe( "wujiang_shopUp", shopUp)
    GameEvents.Subscribe( "item_selled",function(params) { RemoveitemButton(params.num) } )
    //$('#hero3').GetChild(0).itemname="item_empty_block";
    $("#find1").visible = false;
    $("#find2").visible = false;
    //$("#gethero3").visible = false;
    $("#DianJiangTai").visible = false;
    
    //$("#NoPoint").visible = false;
})();


