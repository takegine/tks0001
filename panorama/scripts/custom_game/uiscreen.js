
function OpenInfo( keys, hero ){
	$.Msg("uiscreen input keys=" + keys ,hero); 
	var sendnum = {event:keys}
	if(hero){ sendnum.unit= hero }

	var stat= $("#UIstartmain").GetAttributeInt("hero",1)
	$('#UIstartmain').SetAttributeInt("hero",stat+1)

	$.Msg('stat: ', stat)
	if(stat==1){
		}
	else if(stat==2){
		$("#UIstartmain").SetAttributeInt("hero",3)
		$("#UIstartmain").visible = false;
		if(keys==5) {
			sendnum.unit={
				1:$('#UIstartmain').GetChild(0).GetChild(2).GetChild(0).id,
				2:$('#UIstartmain').GetChild(1).GetChild(2).GetChild(0).id,
				3:$('#UIstartmain').GetChild(2).GetChild(2).GetChild(0).id,
				4:$('#UIstartmain').GetChild(3).GetChild(2).GetChild(0).id,
			};
		}
	}
	else {return}

	$.Msg("uiscreen input event=" + sendnum.event , " unit ", sendnum.unit); 
	GameEvents.SendCustomGameEventToServer( "player_get_country", sendnum );
}

function wujiang_first(params) {
	$.Msg("uiscreen input keys=" + params.event ); 
	var num		 = params.num
	var itemName = params.event
	var cagPanel = $('#sele_'+num)
		cagPanel.SetPanelEvent('onactivate',() => {OpenInfo(num, itemName) }  ) ;
		
		upclass(cagPanel, num+10);
	if (num<5)
		cagPanel.GetChild(1).SetUnit(itemName,'nil' ,true);
		cagPanel.GetChild(2).text = $.Localize(itemName);
		$.CreatePanel('Panel', cagPanel.GetChild(2), itemName)
	
}

function upclass(panel,num) {
	panel.SetHasClass('Options', num<5);
	panel.SetHasClass('Options_'+num, num<6);
}

function createselectpanel(num) {
	var selPanel = $.CreatePanel('Button', $('#UIstartmain'),"sele_"+num);
		selPanel.BLoadLayoutSnippet("selectSnip");
		selPanel.SetPanelEvent(`onactivate`,() => {OpenInfo(num) }  ) ;
		upclass(selPanel,num);
}

(function()	{ 
	// $("#UIstartmain").visible = true;
	GameEvents.Subscribe( "wujiang_first", wujiang_first);
	for(var i=1;i<=5;i++){createselectpanel(i)}
	$.Schedule(25, () => { OpenInfo( 5 ); })

})();