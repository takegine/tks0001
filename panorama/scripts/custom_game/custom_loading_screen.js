"use strict";

var iIndexTip = 1;
var LOADINGTIP_CHANGE_DELAY = 6;

// 注释掉不需要的即可 也可以新增需要的 
var availableIndexTable = [
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	17,
	18,
	19,
	20,
]

var tempCourierList = [
	1, 2, 3, 4, 5,
]
var hSchedule;

function NextTip_Delay() {
	NextTip();
	hSchedule = $.Schedule(LOADINGTIP_CHANGE_DELAY, NextTip_Delay);
}

function RandomTipIndex() {
	var randomIndex = Math.floor(Math.random() * availableIndexTable.length);
	while (availableIndexTable[(randomIndex).toString()] == iIndexTip) {

		randomIndex = Math.floor(Math.random() * availableIndexTable.length);
	}
	return availableIndexTable[(randomIndex).toString()];
}

function NextTip() {
	iIndexTip = RandomTipIndex();
	var sTip = "#LoadingTip_" + iIndexTip;
	//$("#TipLabel").text = $.Localize(sTip);
	// $.CancelScheduled(hSchedule);
	// $.Schedule(LOADINGTIP_CHANGE_DELAY, NextTip_Delay);
}

function InitCourierChoose() {
	var CourierChoose = $("#CourierChoose");
	for (var index = 0; index < tempCourierList.length; index++) {
		var panelID = "CourierRow" + index;
		var panel = CourierChoose.FindChildTraverse(panelID);

		if (panel == null || panel == undefined) {
			panel = $.CreatePanel("Panel", CourierChoose, panelID);
			panel.BLoadLayoutSnippet("CourierRow");
			InitChooseRow(panel);

		}
	}
}
function InitChooseRow(panel) {
	panel.SetPanelEvent("onactivate", function () {
		var CourierChoose = $("#CourierChoose");
		for (var i = 0; i < tempCourierList.length; i++) {
			var panelID = "CourierRow" + i;
			var Panel = CourierChoose.FindChildTraverse(panelID);
			if (Panel != null && Panel != undefined) {
				Panel.RemoveClass("OnChoose");
			}
		}
		panel.SetHasClass("OnChoose", true);

	});
}

(function () {
	iIndexTip = RandomTipIndex();
	var sTip = "#LoadingTip_" + iIndexTip;
	//$("#TipLabel").text = $.Localize(sTip);
	NextTip_Delay();
})();