
function OpenInfo( keys ){
	$.Msg("input keys=" + keys ); 
	var sendnum
	if(keys<10){
		$("#UIstartmain").visible = false;
		$("#btn").SetPanelEvent('onactivate',function() { OpenInfo(10) }  ) ;
		//randomvote(11) 
		sendnum=keys;
	}
	else {
		if(keys==10){  sendnum={  	1:$('#FirstHero').GetChild(0).GetChild(1).GetChild(0).id,
									2:$('#FirstHero').GetChild(1).GetChild(1).GetChild(0).id,
									3:$('#FirstHero').GetChild(2).GetChild(1).GetChild(0).id,
									4:$('#FirstHero').GetChild(3).GetChild(1).GetChild(0).id,
								};
					}
		else{ 	sendnum = $('#FirstHero').FindChild("hero"+keys).GetChild(1).GetChild(0).id; }
		//var itemname=$('#FirstHero').FindChild("hero"+keys).GetChild(1).GetChild(0).id
		//GameEvents.SendCustomGameEventToServer( "find_wujiang", {id: Players.GetLocalPlayer(),way: itemname,No:0} ); 
				$("#FirstHero").visible = false;
				$("#btn").visible = false; 
		} 
	$.Msg("input sendnum=" + sendnum ); 
	GameEvents.SendCustomGameEventToServer( "player_get_country", {event:sendnum} );
}

function wujiang_first(params) {
	$.Msg("input keys=" + params.event ); 
	var num		 =params.num+10
	var itemName =params.event
	var NewPanel = $.CreatePanel('Button', $('#FirstHero'),"hero"+num);
		NewPanel.BLoadLayoutSnippet("QuestLine");
        NewPanel.GetChild(0).SetUnit(itemName,'nil' ,true);
        //NewPanel.GetChild(0).scr = 'file://{resources}/images/custom_game/unithead/wujiang_'+itemName.slice(9)+'.jpg'
		NewPanel.GetChild(1).text = $.Localize(itemName)
		NewPanel.SetPanelEvent('onactivate',function() {OpenInfo(num) }  ) ;
        $.CreatePanel('Panel', NewPanel.GetChild(1),itemName);
}

/*function randomvote(num) {
	var NewPanel = $.CreatePanel('Button', $('#psd'),"voterandom"+num);
		NewPanel.BLoadLayoutSnippet("voterandom");
		NewPanel
}*/

(function()	{ 
	$("#UIstartmain").visible = true;
	GameEvents.Subscribe( "wujiang_first", wujiang_first);

})();