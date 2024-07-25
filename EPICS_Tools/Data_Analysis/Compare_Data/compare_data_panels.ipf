#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.
//Window LoadDataWindow() : Panel
//	PauseUpdate; Silent 1		// building window...
//	KillWindow /Z LoadDataWindow
//	NewPanel /K=1 /FLT=0 /N=LoadDataWindow /W=(9,55,525,677) as "LOAD DATA"
//	SetActiveSubwindow _endfloat_
//	ModifyPanel fixedSize=1
//	SetDrawLayer UserBack
// SetWindow CompareDataWindow hook(CompareDataWindow)=CDWHook

Window CompareDataWindow() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /W=(1313,210,1813,738) as "COMPARE DATA"
	ModifyPanel fixedSize=1
	SetDrawLayer UserBack
	DrawText 36,54,"EPICS Name / Search Filter (RegEx syntax):"
	SetVariable svSearchField,pos={36.00,56.00},size={319.00,17.00},title=" "
	SetVariable svSearchField,help={"Hints:\r(.) = one character;\r(.+) = one or more characters;\r(.*) = zero or more characters;\r(^) = 'start with' character;\r($) = 'end with' character;\rEx: ^SI-02.+CCG-...:Pressure-Mon$\rEx: ^SI-....:DI-BPM.*:PosX-Mon$"}
	SetVariable svSearchField,value= root:Compare:Variables:gSearchField,live= 1
	SetVariable svNth,pos={245.00,89.00},size={47.00,18.00},disable=1,title=" "
	SetVariable svNth,format="%d"
	SetVariable svNth,limits={2,inf,0},value= root:GlobalVariables:gInterval
	GroupBox group1,pos={15.00,7.00},size={467.00,236.00},title="\\BPARAMETERS SELECTION"
	GroupBox group1,fSize=20
	Button btnLoadCompare,pos={60.00,447.00},size={100.00,40.00},proc=ButtonProc_LoadCompare,title="Load"
	Button btnAddSelection,pos={372.00,56.00},size={56.00,19.00},proc=ButtonProc_AddSelection_Comp,title="Add"
	Button btnDel,pos={391.00,145.00},size={70.00,30.00},proc=ButtonProc_DeleteFromSelection_Comp,title="Delete"
	Button btnDel,help={"Hint:\rYou can 'Shift+Click' the lines above to delete multiple ones."}
	ListBox lbSelectionList,pos={36.00,92.00},size={341.00,129.00}
	ListBox lbSelectionList,listWave=root:Compare:VarWaves:wParameters2Search
	ListBox lbSelectionList,selWave=root:Compare:VarWaves:wParameterSel,mode= 4
	CheckBox cburl,pos={171.00,471.00},size={66.00,14.00},title="Print URL"
	CheckBox cburl,variable= root:Compare:Variables:gPrintURL
	CheckBox cbBPMs,pos={171.00,448.00},size={89.00,14.00},title="BPMs to Zero"
	CheckBox cbBPMs,variable= root:Compare:Variables:gZRbpms
	Button btnMore,pos={433.00,56.00},size={28.00,19.00},proc=ButtonProc_OpenPDG_Comp,title="..."
	Button btnMore,help={"Hint:\rClick to select predefined groups to add to Selection Parameters."}
	ValDisplay vdBar,pos={15.00,500.00},size={414.00,17.00},disable=1,title="1/1"
	ValDisplay vdBar,limits={0,100,0},barmisc={0,0},mode= 3,highColor= (0,65535,0)
	ValDisplay vdBar,value= _NUM:100
	GroupBox group2,pos={36.00,256.00},size={426.00,177.00},title="\\BPERIODS TO COMPARE"
	GroupBox group2,fSize=20
	ListBox lbSelectionList1,pos={57.00,284.00},size={295.00,129.00}
	ListBox lbSelectionList1,listWave=root:Compare:VarWaves:wPeriods2Compare
	ListBox lbSelectionList1,selWave=root:Compare:VarWaves:wPeriodSel,mode= 4
	Button btnDelComp,pos={369.00,375.00},size={70.00,30.00},proc=ButtonProc_DeleteFromCompare,title="Delete"
	Button btnEditComp,pos={369.00,334.00},size={70.00,30.00},proc=ButtonProc_EditPeriod,title="Edit"
	Button btnAddComp,pos={369.00,292.00},size={70.00,30.00},proc=ButtonProc_ADDPERIOD_WINDOW,title="Add"
	Button btnEditSelection,pos={391.00,104.00},size={70.00,30.00},proc=ButtonProc_EdictSelection,title="Edit"
	Button btnCancelComp,pos={330.00,447.00},size={100.00,40.00},disable=1,title="Cancel"
	SetWindow kwTopWin,hook(CompareDataWindow)=CDWHook
	SetWindow kwTopWin,hook(spinner)=LoadDataWindowSpinHook
EndMacro

Window PreDefinedGroups_Comp() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /W=(594,171,1228,792) as "Predefined Groups..."
	GroupBox group0,pos={12.00,5.00},size={149.00,239.00},title="LI "
	CheckBox check0,pos={27.00,27.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="EG"
	CheckBox check0,value= 0
	CheckBox check1,pos={27.00,52.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="PU"
	CheckBox check1,value= 0
	CheckBox check2,pos={27.00,76.00},size={41.00,15.00},disable=2,proc=CheckProc_PDG_Comp,title="LLRF"
	CheckBox check2,value= 0
	CheckBox check3,pos={45.00,101.00},size={40.00,15.00},proc=CheckProc_PDG_Comp,title="BUN"
	CheckBox check3,value= 0
	CheckBox check4,pos={45.00,126.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="KLY1"
	CheckBox check4,value= 0
	CheckBox check5,pos={45.00,150.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="KLY2"
	CheckBox check5,value= 0
	CheckBox check7,pos={27.00,174.00},size={29.00,15.00},proc=CheckProc_PDG_Comp,title="PS"
	CheckBox check7,value= 0
	GroupBox group1,pos={175.00,5.00},size={173.00,168.00},title="TB"
	CheckBox check22,pos={270.00,26.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="PU"
	CheckBox check22,value= 0
	CheckBox check24,pos={270.00,49.00},size={41.00,15.00},disable=2,title="BPM"
	CheckBox check24,value= 0
	CheckBox check25,pos={187.00,26.00},size={29.00,15.00},disable=2,title="PS"
	CheckBox check25,value= 0
	CheckBox check26,pos={205.00,49.00},size={23.00,15.00},proc=CheckProc_PDG_Comp,title="B"
	CheckBox check26,value= 0
	CheckBox check27,pos={205.00,73.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="QD"
	CheckBox check27,value= 0
	CheckBox check28,pos={205.00,98.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="QF"
	CheckBox check28,value= 0
	CheckBox check29,pos={205.00,123.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="CH"
	CheckBox check29,value= 0
	CheckBox check30,pos={205.00,147.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="CV"
	CheckBox check30,value= 0
	CheckBox check8,pos={27.00,198.00},size={41.00,15.00},disable=2,proc=CheckProc_PDG_Comp,title="BPM"
	CheckBox check8,value= 0
	CheckBox check34,pos={288.00,71.00},size={48.00,15.00},proc=CheckProc_PDG_Comp,title="XBPM"
	CheckBox check34,value= 0
	CheckBox check35,pos={288.00,96.00},size={48.00,15.00},proc=CheckProc_PDG_Comp,title="YBPM"
	CheckBox check35,value= 0
	GroupBox group2,pos={362.00,5.00},size={174.00,238.00},title="BO "
	CheckBox check36,pos={457.00,27.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="PU"
	CheckBox check36,value= 0
	CheckBox check37,pos={457.00,52.00},size={29.00,15.00},proc=CheckProc_PDG_Comp,title="RF"
	CheckBox check37,value= 0
	CheckBox check38,pos={457.00,76.00},size={41.00,15.00},disable=2,title="BPM"
	CheckBox check38,value= 0
	CheckBox check39,pos={374.00,26.00},size={29.00,15.00},disable=2,title="PS"
	CheckBox check39,value= 0
	CheckBox check40,pos={392.00,49.00},size={23.00,15.00},proc=CheckProc_PDG_Comp,title="B"
	CheckBox check40,value= 0
	CheckBox check41,pos={392.00,73.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="QD"
	CheckBox check41,value= 0
	CheckBox check42,pos={392.00,98.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="QF"
	CheckBox check42,value= 0
	CheckBox check43,pos={392.00,123.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="QS"
	CheckBox check43,value= 0
	CheckBox check44,pos={392.00,147.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="SD"
	CheckBox check44,value= 0
	CheckBox check45,pos={392.00,170.00},size={28.00,15.00},proc=CheckProc_PDG_Comp,title="SF"
	CheckBox check45,value= 0
	CheckBox check46,pos={392.00,193.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="CH"
	CheckBox check46,value= 0
	CheckBox check47,pos={392.00,216.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="CV"
	CheckBox check47,value= 0
	CheckBox check48,pos={475.00,98.00},size={48.00,15.00},proc=CheckProc_PDG_Comp,title="XBPM"
	CheckBox check48,value= 0
	CheckBox check49,pos={475.00,123.00},size={48.00,15.00},proc=CheckProc_PDG_Comp,title="YBPM"
	CheckBox check49,value= 0
	GroupBox group3,pos={12.00,252.00},size={174.00,168.00},title="TS"
	CheckBox check31,pos={107.00,274.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="PU"
	CheckBox check31,value= 0
	CheckBox check33,pos={107.00,297.00},size={41.00,15.00},disable=2,title="BPM"
	CheckBox check33,value= 0
	CheckBox check50,pos={24.00,273.00},size={29.00,15.00},disable=2,title="PS"
	CheckBox check50,value= 0
	CheckBox check51,pos={42.00,296.00},size={23.00,15.00},proc=CheckProc_PDG_Comp,title="B"
	CheckBox check51,value= 0
	CheckBox check52,pos={42.00,320.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="QD"
	CheckBox check52,value= 0
	CheckBox check53,pos={42.00,345.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="QF"
	CheckBox check53,value= 0
	CheckBox check54,pos={42.00,370.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="CH"
	CheckBox check54,value= 0
	CheckBox check55,pos={42.00,394.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="CV"
	CheckBox check55,value= 0
	CheckBox check56,pos={125.00,319.00},size={48.00,15.00},proc=CheckProc_PDG_Comp,title="XBPM"
	CheckBox check56,value= 0
	CheckBox check57,pos={125.00,344.00},size={48.00,15.00},proc=CheckProc_PDG_Comp,title="YBPM"
	CheckBox check57,value= 0
	GroupBox group4,pos={194.00,252.00},size={429.00,357.00},title="SI"
	CheckBox check58,pos={225.00,463.00},size={46.00,15.00},proc=CheckProc_PDG_Comp,title="QDP1"
	CheckBox check58,value= 0
	CheckBox check59,pos={225.00,487.00},size={46.00,15.00},proc=CheckProc_PDG_Comp,title="QDP2"
	CheckBox check59,value= 0
	CheckBox check60,pos={291.00,295.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="Q1"
	CheckBox check60,value= 0
	CheckBox check61,pos={207.00,271.00},size={29.00,15.00},disable=2,title="PS"
	CheckBox check61,value= 0
	CheckBox check62,pos={225.00,294.00},size={23.00,15.00},proc=CheckProc_PDG_Comp,title="B"
	CheckBox check62,value= 0
	CheckBox check63,pos={225.00,318.00},size={38.00,15.00},proc=CheckProc_PDG_Comp,title="QFA"
	CheckBox check63,value= 0
	CheckBox check64,pos={225.00,343.00},size={38.00,15.00},proc=CheckProc_PDG_Comp,title="QFB"
	CheckBox check64,value= 0
	CheckBox check65,pos={225.00,368.00},size={38.00,15.00},proc=CheckProc_PDG_Comp,title="QFP"
	CheckBox check65,value= 0
	CheckBox check66,pos={225.00,392.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="QDA"
	CheckBox check66,value= 0
	CheckBox check67,pos={225.00,415.00},size={46.00,15.00},proc=CheckProc_PDG_Comp,title="QDB1"
	CheckBox check67,value= 0
	CheckBox check68,pos={225.00,438.00},size={46.00,15.00},proc=CheckProc_PDG_Comp,title="QDB2"
	CheckBox check68,value= 0
	CheckBox check70,pos={291.00,318.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="Q2"
	CheckBox check70,value= 0
	CheckBox check71,pos={291.00,343.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="Q3"
	CheckBox check71,value= 0
	CheckBox check9,pos={27.00,221.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="VA"
	CheckBox check9,value= 0
	CheckBox check72,pos={270.00,119.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="VA"
	CheckBox check72,value= 0
	CheckBox check73,pos={457.00,147.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="VA"
	CheckBox check73,value= 0
	CheckBox check74,pos={107.00,370.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="VA"
	CheckBox check74,value= 0
	CheckBox check75,pos={291.00,367.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="Q4"
	CheckBox check75,value= 0
	CheckBox check76,pos={291.00,392.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="SFA0"
	CheckBox check76,value= 0
	CheckBox check69,pos={291.00,463.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="SFB0"
	CheckBox check69,value= 0
	CheckBox check77,pos={291.00,487.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="SFB1"
	CheckBox check77,value= 0
	CheckBox check78,pos={353.00,298.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="SFB2"
	CheckBox check78,value= 0
	CheckBox check79,pos={353.00,321.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="SFP0"
	CheckBox check79,value= 0
	CheckBox check80,pos={353.00,346.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="SFP1"
	CheckBox check80,value= 0
	CheckBox check81,pos={353.00,370.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="SFP2"
	CheckBox check81,value= 0
	CheckBox check82,pos={353.00,395.00},size={44.00,15.00},proc=CheckProc_PDG_Comp,title="SDA0"
	CheckBox check82,value= 0
	CheckBox check83,pos={291.00,415.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="SFA1"
	CheckBox check83,value= 0
	CheckBox check84,pos={291.00,439.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="SFA2"
	CheckBox check84,value= 0
	CheckBox check85,pos={353.00,418.00},size={44.00,15.00},proc=CheckProc_PDG_Comp,title="SDA1"
	CheckBox check85,value= 0
	CheckBox check86,pos={353.00,441.00},size={44.00,15.00},proc=CheckProc_PDG_Comp,title="SDA2"
	CheckBox check86,value= 0
	CheckBox check87,pos={353.00,465.00},size={44.00,15.00},proc=CheckProc_PDG_Comp,title="SDA3"
	CheckBox check87,value= 0
	CheckBox check88,pos={353.00,489.00},size={43.00,15.00},proc=CheckProc_PDG_Comp,title="SDB0"
	CheckBox check88,value= 0
	CheckBox check89,pos={418.00,299.00},size={43.00,15.00},proc=CheckProc_PDG_Comp,title="SDB1"
	CheckBox check89,value= 0
	CheckBox check90,pos={418.00,322.00},size={43.00,15.00},proc=CheckProc_PDG_Comp,title="SDB2"
	CheckBox check90,value= 0
	CheckBox check91,pos={418.00,346.00},size={43.00,15.00},proc=CheckProc_PDG_Comp,title="SDB3"
	CheckBox check91,value= 0
	CheckBox check92,pos={418.00,370.00},size={43.00,15.00},proc=CheckProc_PDG_Comp,title="SDP0"
	CheckBox check92,value= 0
	CheckBox check93,pos={418.00,395.00},size={43.00,15.00},proc=CheckProc_PDG_Comp,title="SDP1"
	CheckBox check93,value= 0
	CheckBox check94,pos={418.00,420.00},size={43.00,15.00},proc=CheckProc_PDG_Comp,title="SDP2"
	CheckBox check94,value= 0
	CheckBox check95,pos={418.00,443.00},size={43.00,15.00},proc=CheckProc_PDG_Comp,title="SDP3"
	CheckBox check95,value= 0
	CheckBox check96,pos={407.00,512.00},size={31.00,15.00},disable=2,title="CV"
	CheckBox check96,value= 0
	CheckBox check97,pos={291.00,512.00},size={33.00,15.00},disable=2,title="CH"
	CheckBox check97,value= 0
	CheckBox check98,pos={418.00,466.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="QS"
	CheckBox check98,value= 0
	Button button0,pos={47.00,469.00},size={93.00,33.00},proc=ButtonProc_AddPDG_Comp,title="Add Selection"
	CheckBox check99,pos={479.00,274.00},size={41.00,15.00},disable=2,title="BPM"
	CheckBox check99,value= 0
	CheckBox check00,pos={497.00,299.00},size={48.00,15.00},disable=2,title="XBPM"
	CheckBox check00,value= 0
	CheckBox check01,pos={496.00,418.00},size={48.00,15.00},disable=2,title="YBPM"
	CheckBox check01,value= 0
	CheckBox check02,pos={547.00,556.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="PU"
	CheckBox check02,value= 0
	CheckBox check6,pos={111.00,27.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="CH"
	CheckBox check6,value= 0
	CheckBox check07,pos={111.00,53.00},size={31.00,15.00},proc=CheckProc_PDG_Comp,title="CV"
	CheckBox check07,value= 0
	CheckBox check03,pos={207.00,509.00},size={30.00,15.00},disable=2,title="VA"
	CheckBox check03,value= 0
	CheckBox check04,pos={225.00,532.00},size={40.00,15.00},proc=CheckProc_PDG_Comp,title="CCG"
	CheckBox check04,value= 0
	CheckBox check05,pos={225.00,556.00},size={44.00,15.00},proc=CheckProc_PDG_Comp,title="SIP20"
	CheckBox check05,value= 0
	CheckBox check06,pos={225.00,580.00},size={28.00,15.00},proc=CheckProc_PDG_Comp,title="FE"
	CheckBox check06,value= 0
	CheckBox check08,pos={515.00,324.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="M1"
	CheckBox check08,value= 0
	CheckBox check09,pos={515.00,347.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="M2"
	CheckBox check09,value= 0
	CheckBox check10,pos={515.00,370.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="C1-1"
	CheckBox check10,value= 0
	CheckBox check11,pos={515.00,393.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="C1-2"
	CheckBox check11,value= 0
	CheckBox check12,pos={568.00,324.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="C2"
	CheckBox check12,value= 0
	CheckBox check13,pos={568.00,347.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="C3-1"
	CheckBox check13,value= 0
	CheckBox check14,pos={568.00,370.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="C3-2"
	CheckBox check14,value= 0
	CheckBox check15,pos={568.00,393.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="C4"
	CheckBox check15,value= 0
	CheckBox check16,pos={515.00,439.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="M1"
	CheckBox check16,value= 0
	CheckBox check17,pos={515.00,462.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="M2"
	CheckBox check17,value= 0
	CheckBox check18,pos={515.00,485.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="C1-1"
	CheckBox check18,value= 0
	CheckBox check19,pos={515.00,508.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="C1-2"
	CheckBox check19,value= 0
	CheckBox check20,pos={568.00,439.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="C2"
	CheckBox check20,value= 0
	CheckBox check21,pos={568.00,462.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="C3-1"
	CheckBox check21,value= 0
	CheckBox check23,pos={568.00,485.00},size={41.00,15.00},proc=CheckProc_PDG_Comp,title="C3-2"
	CheckBox check23,value= 0
	CheckBox check32,pos={568.00,508.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="C4"
	CheckBox check32,value= 0
	CheckBox check100,pos={308.00,533.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="M1"
	CheckBox check100,value= 0
	CheckBox check101,pos={308.00,555.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="M2"
	CheckBox check101,value= 0
	CheckBox check102,pos={308.00,577.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="C1"
	CheckBox check102,value= 0
	CheckBox check103,pos={353.00,533.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="C2"
	CheckBox check103,value= 0
	CheckBox check104,pos={353.00,555.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="C3"
	CheckBox check104,value= 0
	CheckBox check105,pos={353.00,577.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="C4"
	CheckBox check105,value= 0
	CheckBox check106,pos={424.00,534.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="M1"
	CheckBox check106,value= 0
	CheckBox check107,pos={424.00,556.00},size={33.00,15.00},proc=CheckProc_PDG_Comp,title="M2"
	CheckBox check107,value= 0
	CheckBox check108,pos={424.00,578.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="C1"
	CheckBox check108,value= 0
	CheckBox check111,pos={469.00,534.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="C2"
	CheckBox check111,value= 0
	CheckBox check109,pos={469.00,556.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="C3"
	CheckBox check109,value= 0
	CheckBox check110,pos={469.00,578.00},size={30.00,15.00},proc=CheckProc_PDG_Comp,title="C4"
	CheckBox check110,value= 0
	Execute/Q/Z "SetWindow kwTopWin sizeLimit={33,48,inf,inf}" // sizeLimit requires Igor 7 or later
EndMacro

Window AddPeriodWindow() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /W=(1112,221,1406,676) as "ADD PERIOD"
	SetDrawLayer UserBack
	DrawRect 44,154,250,252
	DrawText 58,174,"DD"
	DrawText 120,174,"MM"
	DrawText 182,174,"YYYY"
	DrawText 58,218,"HH"
	DrawText 120,218,"MM"
	DrawText 183,218,"SS"
	DrawText 44,151,"START DATE/HOUR:"
	DrawRect 44,288,250,380
	DrawText 58,307,"DD"
	DrawText 121,307,"MM"
	DrawText 182,307,"YYYY"
	DrawText 58,347,"HH"
	DrawText 121,347,"MM"
	DrawText 183,347,"SS"
	DrawText 45,284,"END DATE/HOUR:"
	DrawText 51,105,"TimeZone (h):"
	DrawText 166,105,"TimeStamp(s):"
	SetVariable svStartDay,pos={57.00,178.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svStartDay,help={"Day"},format="%02d"
	SetVariable svStartDay,limits={1,31,1},value= root:Compare:Variables:dds
	SetVariable svStartMonth,pos={119.00,178.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svStartMonth,help={"Month"},format="%02d"
	SetVariable svStartMonth,limits={1,12,1},value= root:Compare:Variables:mms
	SetVariable svStartYear,pos={181.00,178.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svStartYear,help={"Year"},format="%04d"
	SetVariable svStartYear,limits={2000,3000,1},value= root:Compare:Variables:yyyys
	SetVariable svStartHour,pos={57.00,222.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svStartHour,help={"Hour"},format="%02d"
	SetVariable svStartHour,limits={0,23,1},value= root:Compare:Variables:hs
	SetVariable svStartMin,pos={119.00,222.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svStartMin,help={"Minute"},format="%02d"
	SetVariable svStartMin,limits={0,59,1},value= root:Compare:Variables:ms
	SetVariable svStartSec,pos={181.00,222.00},size={58.00,18.00},disable=2,title=" "
	SetVariable svStartSec,help={"Second"},format="%.3f"
	SetVariable svStartSec,limits={0,59,1},value= root:Compare:Variables:ss
	SetVariable svEndDay,pos={57.00,311.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svEndDay,help={"Day"},format="%02d"
	SetVariable svEndDay,limits={1,31,1},value= root:Compare:Variables:dde
	SetVariable svEndMonth,pos={118.00,311.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svEndMonth,help={"Month"},format="%02d"
	SetVariable svEndMonth,limits={1,12,1},value= root:Compare:Variables:mme
	SetVariable svEndYear,pos={181.00,311.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svEndYear,help={"Year"},format="%04d"
	SetVariable svEndYear,limits={2000,3000,1},value= root:Compare:Variables:yyyye
	SetVariable svEndHour,pos={57.00,351.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svEndHour,help={"Hour"},format="%02d"
	SetVariable svEndHour,limits={0,23,1},value= root:Compare:Variables:he
	SetVariable svEndMin,pos={118.00,351.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svEndMin,help={"Minute"},format="%02d"
	SetVariable svEndMin,limits={0,59,1},value= root:Compare:Variables:me
	SetVariable svEndSec,pos={181.00,351.00},size={58.00,18.00},disable=2,title=" "
	SetVariable svEndSec,help={"Second"},format="%.3f"
	SetVariable svEndSec,limits={0,59,1},value= root:Compare:Variables:se
	GroupBox group0,pos={16.00,7.00},size={264.00,433.00},title="\\BPERIOD",fSize=20
	PopupMenu puPeriod,pos={35.00,33.00},size={141.00,19.00},bodyWidth=141,proc=PopMenuProc_Period_Comp
	PopupMenu puPeriod,mode=1,popvalue="Last Hour",value= #"\"Last Hour;Last 3 Hours;Last 6 Hours;Last 24 Hours;Fixed Start / Fixed End;Fixed Start / End Now\""
	PopupMenu puInterval,pos={34.00,62.00},size={227.00,19.00},bodyWidth=227,disable=2,proc=PopMenuProc_Interval_Comp
	PopupMenu puInterval,mode=1,popvalue="Default Variable Interval",value= #"\"Default Variable Interval;Interval: 10 Seconds;Interval: 30 Seconds;Interval: 60 Seconds;Interval: 300 Seconds;Interval: Custom\""
	PopupMenu puMethod,pos={182.00,33.00},size={80.00,19.00},bodyWidth=80,proc=PopMenuProc_Method_Comp
	PopupMenu puMethod,mode=1,popvalue="Normal",value= #"\"Normal;Average;Minimum;Maximum;N-th\""
	SetVariable svNth,pos={215.00,63.00},size={47.00,18.00},disable=1,title=" "
	SetVariable svNth,format="%d"
	SetVariable svNth,limits={2,inf,0},value= root:Compare:Variables:gInterval
	ValDisplay vdBar,pos={27.00,604.00},size={459.00,17.00},disable=1
	ValDisplay vdBar,limits={0,100,0},barmisc={0,0},mode= 3,highColor= (0,65535,0)
	ValDisplay vdBar,value= _NUM:100
	Button btnCancel,pos={379.00,512.00},size={90.00,29.00},disable=1,title="Cancel"
	Button btn_addperiod,pos={56.00,395.00},size={100.00,30.00},proc=ButtonProc_AddPeriod,title="Add Period"
	Button btnCancelComp,pos={167.00,395.00},size={70.00,30.00},proc=ButtonProc_CANCELADDPERIOD,title="Cancel"
	SetVariable svAdjustTimezone,pos={60.00,108.00},size={60.00,18.00},title=" "
	SetVariable svAdjustTimezone,help={"Archiver solicitations must have\rfuse adjust for current timezone"}
	SetVariable svAdjustTimezone,format="%d"
	SetVariable svAdjustTimezone,limits={-11,14,1},value= root:Compare:Variables:gTimezone
	SetVariable svAdjustDH,pos={178.00,108.00},size={60.00,18.00},title=" "
	SetVariable svAdjustDH,value= root:Compare:Variables:gAdjustDH
	SetWindow kwTopWin,hook(UserHook)=HookGetWindowAction
	Execute/Q/Z "SetWindow kwTopWin sizeLimit={33,48,inf,inf}" // sizeLimit requires Igor 7 or later
EndMacro

Window window_compare() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /W=(264,61,1133,272) as "Compare Intervals"
	ModifyPanel fixedSize=1
	ListBox list0,pos={10.00,32.00},size={260.00,165.00},proc=ListBoxProc_Left
	ListBox list0,listWave=root:Compare:VarWaves:wPVsCompL
	ListBox list0,selWave=root:Compare:VarWaves:wPVsCompLSel,mode= 5
	ListBox list2,pos={565.00,32.00},size={293.00,165.00}
	ListBox list2,listWave=root:Compare:VarWaves:wPeriodsWin
	ListBox list2,selWave=root:Compare:VarWaves:wPeriodsWinSel,mode= 8
	ListBox list1,pos={287.00,32.00},size={260.00,165.00},proc=ListBoxProc_Right
	ListBox list1,listWave=root:Compare:VarWaves:wPVsCompR
	ListBox list1,selWave=root:Compare:VarWaves:wPVsCompRSel,mode= 5
	TitleBox title0,pos={10.00,11.00},size={52.00,14.00},title="Left Axis:",frame=0
	TitleBox title1,pos={288.00,11.00},size={59.00,14.00},title="Right Axis:"
	TitleBox title1,frame=0
	TitleBox title2,pos={566.00,11.00},size={39.00,14.00},title="Period:",frame=0
	SetWindow kwTopWin,hook(window_compare)=CompareWinHook
	Execute/Q/Z "SetWindow kwTopWin sizeLimit={28.5,39,inf,inf}" // sizeLimit requires Igor 7 or later
EndMacro

Function ButtonProc_AddSelection_Comp(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	wave/T wGrepRes = root:Compare:VarWaves:wGrepRes
	wave/T wParameters2Search = root:Compare:VarWaves:wParameters2Search
	wave wParameterSel = root:Compare:VarWaves:wParameterSel
	SVAR/Z SearchField = root:Compare:Variables:gSearchField
	SVAR/Z PVsFile = root:GlobalVariables:gPVsfile
	variable i
	string aux = ""
	string PVsFile_
	
	switch( ba.eventCode )
		case 2: // mouse up
			if (strlen(SearchField) != 0) //se há algo no campo SearchField
				PathInfo EPICS_Tools
				if (V_Flag == 1)
					PVsFile_ = S_path + PVsFile
				else
					print "Problems finding EPICSpvlist.dat"
					return 0
				endif
				KillVariables/Z V_Flag
				KillStrings/Z S_path
				Grep/E=SearchField PVsFile_ as wGrepRes //pesquisa no arquivo pvfile pela PV usando como critério SearchField, retorna na wave wGrepRes
				if (wavedims(wGrepRes) == 0) //verifico se há algum resultado que corresponde à pesquisa, se não há...
					print "There's no item that corresponds to that EPICS Name / Search Filters!" //emito aviso
					SetVariable svSearchField activate // e retorno a seleção ao campo do Nome EPICS/Filtro de Pesquisa
				else	 //se há...
					InsertPoints (inf), 1, wParameterSel, wParameters2Search//, wParameters2SearchHelp //^BO-01.+PS.+Current-Mon$
					wParameters2Search[inf] = SearchField //adiciono o valor digitado à wave de itens a serem carregados
					SearchField = "" //esvazio o campo
					SetVariable svSearchField activate //retorno o cursor de texto ao campo do Nome EPICS/Filtro de Pesquisa
					DeletePoints 0, inf, wGrepRes //esvazio a wave
				endif
				killstrings/Z V_flag, V_value, V_startParagraph, S_fileName, S_path, S_Value //mato as strings geradas no Grep acima
				killvariables/Z V_flag, V_value, V_startParagraph, S_fileName, S_path, S_Value  //idem para variáveis
			endif
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_OpenPDG_Comp(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			OpenPDG_Comp()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_EdictSelection(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			EditSelection()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_DeleteFromSelection_Comp(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			DeleteFromSelection_Comp()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_ADDPERIOD_WINDOW(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	NVAR/Z gMode = root:Compare:Variables:gMode
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			//SetDHVars()
			gMode = 0 //'add' mode
		    SetVarsDefault()
			OpenAddPeriodWindow()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_EditPeriod(ba) : ButtonControl //mudar para EditCompare
	STRUCT WMButtonAction &ba
	NVAR/Z gMode = root:Compare:Variables:gMode
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			gMode = 1
			EditPeriod()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_DeleteFromCompare(ba) : ButtonControl //mudar para DeleteCompare
	STRUCT WMButtonAction &ba
	wave/T wPeriods2Compare = root:Compare:VarWaves:wPeriods2Compare
	wave wPeriodSel = root:Compare:VarWaves:wPeriodSel
	string Selection = ""
	int i

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			for (i=0;i<numpnts(wPeriodSel);i+=1)
				if (wPeriodSel[i] == 1)
					Selection = Selection + wPeriods2Compare[i] + ";"
				endif
			endfor
			for (i=0;i<ItemsInList(Selection);i+=1)
				FindValue/TEXT=stringfromlist(i,Selection) wPeriods2Compare
				//print wParameterSel
				DeletePoints V_Value, 1, wPeriodSel, wPeriods2Compare
				KillVariables/Z V_Value
			endfor
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_LoadCompare(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	wave/T wParameters2Search = root:Compare:VarWaves:wParameters2Search
	wave/T wGrepRes = root:Compare:VarWaves:wGrepRes
	SVAR/Z PVsFile = root:GlobalVariables:gPVsfile
	wave/T wPVs = root:Compare:VarWaves:wPVs
	wave/T wPVsCompWin = root:Compare:VarWaves:wPVsCompWin
	wave wPVsCompWinSel = root:Compare:VarWaves:wPVsCompWinSel
	wave/T wPeriodsWin = root:Compare:VarWaves:wPeriodsWin
	wave wPeriodsWinSel = root:Compare:VarWaves:wPeriodsWinSel
	SVAR/Z gZRbpms = root:Compare:Variables:gZRbpms
	NVAR/Z gAbort = root:Compare:Variables:gAbort
	NVAR/Z gMethod = root:Compare:Variables:gMethod
	wave/T wPeriods2Compare = root:Compare:VarWaves:wPeriods2Compare
	int i = 0
	int j = 0
	string changedname
	variable bar
	string pvname
	string pvname_TS
	string oldname, oldname_TS, aux, aux_TS
	string newname, newname_TS
	wave temp
	wave temp_TS
	string wavesinroot = ""
	variable waveexist
	string PVsFile_
		
	switch( ba.eventCode )
		case 2: // mouse up
			try
				// click code here
				Button btnLoadCompare, disable=2
				ControlUpdate /W=CompareDataWindow btnLoadCompare
				Button btnCancelComp, disable=0
				ControlUpdate /W=CompareDataWindow btnCancelComp	
				Redimension/N=0 wPVs //zera wave wPVs
				Redimension /N=0 wPVsCompWin, wPVsCompWinSel
				Redimension /N=0 wPeriodsWin, wPeriodsWinSel
				DoUpdate /E=1 /W=CompareDataWindow /SPIN=1
				//gera wave de pesquisa
				for (i=0; i < numpnts(wParameters2Search); i+=1)//para cada parametro de pesquisa no caixa de pesquisa
					//Redimension/N=(numpnts(wPVs)) wPVstemp //igualo dimensoes de wPVs(1) e wPVstemp(1)
					//wPVstemp = wPVs //copio wPVs para wPVstemp
					PathInfo EPICS_Tools
					if (V_Flag == 1)
						PVsFile_ = S_path + PVsFile
					else
						print "Problems finding EPICSpvlist.dat"
						return 0
					endif
					KillVariables/Z V_Flag
					KillStrings/Z S_path
					Grep/E=wParameters2Search[i] PVsFile_ as wGrepRes //pesquiso no arquivo PVsFile e gero o resultado na wave GrepRes
					//Redimension/N=(numpnts(wPVs)+numpnts(wGrepRes)) wPVs //redimensiono wPVs para acomodar o resultado
					Concatenate/NP/T {wGrepRes}, wPVs //junto todas as iterações de wGrepRes na wave wPVs
					Concatenate/NP/T {wGrepRes}, wPVsCompWin //junto todas as iterações de wGrepRes na wave wPVsCompWin
				endfor
				InsertPoints ((numpnts(wPVsCompWin))+1), (numpnts(wPVsCompWin)), wPVsCompWinSel
				print " "
				ValDisplay vdBar,value= _NUM:0
				ValDisplay vdBar win=CompareDataWindow, disable=0
				DoUpdate /W=CompareDataWindow /E=1 /SPIN=1
				//carrega dados do archiver
				for (i=0; i < numpnts(wPeriods2Compare); i+=1)
					for (j=0; j < numpnts(wPVs); j+=1) //para cada PV na wave
						if(V_flag == 2)
							ValDisplay vdBar win=CompareDataWindow, disable=1
							Button btnLoadCompare, disable=0
							ControlUpdate /W=CompareDataWindow btnLoadCompare
							Button btnCancelComp, disable=1
							ControlUpdate /W=CompareDataWindow btnCancelComp
							break
						endif
						wavesinroot = WaveList(ReplaceString(":", wPVs[j], "_"), ",", "")
						if (ItemsInList(wavesinroot, ",") == 1)
							waveexist = 1
							aux = ReplaceString(":", wPVs[j], "_")
							aux_TS = ReplaceString(":", wPVs[j] + "_TS", "_")
							Duplicate/O $aux, temp
							Duplicate/O $aux_TS, temp_TS
						else
							waveexist = 0
						endif
						if (LoadCompare(wPVs[j], wPeriods2Compare[i]) == 0) //se função de carregar retornar ok
							oldname = ReplaceString(":", wPVs[j], "_")
							oldname_TS = oldname + "_TS"
							newname = oldname + "_" + num2str(i)
							newname_TS = oldname_TS + "_" + num2str(i)
							KillWaves/Z $newname
							//Rename $oldname, $newname
							Duplicate/O $oldname, $newname
							killwaves/Z $oldname
							KillWaves/Z $newname_TS
							//Rename $oldname_TS, $newname_TS
							Duplicate/O $oldname_TS, $newname_TS
							killwaves/Z $oldname_TS
							if (waveexist==1)
								Duplicate/O temp, $oldname
								Duplicate/O temp_TS, $oldname_TS
							endif
							print "Wave " + newname + " Carregada!"
							if(gMethod != 1)
								if (numpnts($newname) > 2)
									DeletePoints 0, 1, $newname
									DeletePoints 0, 1, $newname_TS
								endif
							endif
							if(GetControlValueNbr("cbBPMs", "CompareDataWindow") == 1)
								if(stringmatch(wPVs[j],"*BPM*Mon*"))
									BpmShiftWave(0, newname)
								endif
							endif
						else
							print "Could not load ", wPVs[j], " wave!"
						endif
						bar = 100/numpnts(wPVs)
						ValDisplay vdBar win=CompareDataWindow, value= _NUM:bar+bar*j, title=num2str(i+1)+"/"+num2str(numpnts(wPeriods2Compare))
						DoUpdate/W=CompareDataWindow
					endfor	
				endfor
				Duplicate/O wPeriods2Compare, root:Compare:VarWaves:wPeriodsWin
				InsertPoints 0, (numpnts(wPeriodsWin)), wPeriodsWinSel
				FixOnePointWaves_Comp(wPVs) //altera waves com um único ponto para terem dois pontos
				ValDisplay vdBar win=CompareDataWindow, disable=1
				Button btnLoadCompare, disable=0
				ControlUpdate /W=CompareDataWindow btnLoadCompare
				DoUpdate /W=CompareDataWindow /E=0 /SPIN=0
				Button btnCancelComp, disable=1
				ControlUpdate /W=CompareDataWindow btnCancelComp
				break
			catch
				if (V_AbortCode == -1)
					Button btnLoadCompare, disable=0
					ControlUpdate /W=CompareDataWindow btnLoadCompare
					print "Falha ao carregar dados!"
					break
				endif
			endtry
		case -1: // control being killed
			break
	endswitch
	gAbort = 0
	killWaves/Z temp, temp_TS
End

//↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ funções da janela de adição/edição de período ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓//
Function PopMenuProc_Period_Comp(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa
	NVAR Period = root:Compare:Variables:gPeriod
	string DateHourSControlList = ControlNameList("AddPeriodWindow",";","*Start*") //gera lista com nomes dos controles data/hora inicial
	string DateHourEControlList = ControlNameList("AddPeriodWindow",";","*End*") //gera lista com nomes dos controles data/hora final
	
	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			
			switch (popNum)
				case 1:
					Period = 1 //ButtonProc_AddPeriodSeta variável global com o valor correspondente
					UpdatePeriodControls_Comp(1) //Preenche controles data/hora inicial e final com o intervalo da última hora
					ModifyControlList DateHourSControlList win=AddPeriodWindow, disable=2 //desabilita edição dos controles data/hora inicial
					ModifyControlList DateHourEControlList disable=2 //desabilita edição dos controles data/hora final
					break
				case 2:
					Period = 2
					UpdatePeriodControls_Comp(3)
					ModifyControlList DateHourSControlList win=AddPeriodWindow, disable=2
					ModifyControlList DateHourEControlList win=AddPeriodWindow, disable=2
					break
				case 3:
					Period = 3
					UpdatePeriodControls_Comp(6)
					ModifyControlList DateHourSControlList win=AddPeriodWindow, disable=2
					ModifyControlList DateHourEControlList win=AddPeriodWindow, disable=2
					break
				case 4:
					Period = 4
					UpdatePeriodControls_Comp(24)
					ModifyControlList DateHourSControlList win=AddPeriodWindow, disable=2
					ModifyControlList DateHourEControlList win=AddPeriodWindow, disable=2
					break
				case 5:
					Period = 5
					FixedStartFixedEnd()
					ModifyControlList DateHourSControlList win=AddPeriodWindow, disable=0
					ModifyControlList DateHourEControlList win=AddPeriodWindow, disable=0
					SetVariable svStartDay activate
					break
				case 6:
					Period = 6
					FixedStartEndNow_Comp()
					ModifyControlList DateHourSControlList win=AddPeriodWindow, disable=0
					ModifyControlList DateHourEControlList win=AddPeriodWindow, disable=2
					break
			endswitch
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function PopMenuProc_Method_Comp(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa
	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			UpdateIntervalMenu(popNum)
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function PopMenuProc_Interval_Comp(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa
	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			//print popStr,",", popNum
				UpdateInterval_Comp(popStr)
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_AddPeriod(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			AddPeriod()
			CancelAddPeriodWindow()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_CANCELADDPERIOD(ba) : ButtonControl //mudar caps lock para ficar igual AddPeriod
	STRUCT WMButtonAction &ba
	NVAR gMode = root:Compare:Variables:gMode //Modo de Adição = 0, mode de Edição = 1
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			gMode = 0
			CancelAddPeriodWindow()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ funções da janela de adição/edição de período ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑//

//↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ funções da janela de Compare Graph ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓//
Function CheckProc_PDG_Comp(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba
	switch( cba.eventCode )
		case 2: // mouse up
			PDGcheckboxSel_Comp(cba.ctrlName, cba.checked)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function CompareWinHook(s)
	STRUCT WMWinHookStruct &s
	Variable hookResult = 0
	wave wPeriodsWin = root:Compare:VarWaves:wPeriodsWin
	variable i
	strswitch(s.eventName)
		case "resize":
			//GetWindow $(s.winName) hide
			//if (V_value)
				//Print "Resized while hidden"
			//else
				//Print "Resized while visible"
			//endif
			break
		case "moved":
			//GetWindow $(s.winName) hide
			//if (V_value)
				//Print "Moved while hidden"
			//else
				//Print "Moved while visible"
			//endif
			break
		case "hide":
			//print "Hide event"
			break
		case "show":
			break
		case "kill":
			//print "Kill event"
			for (i=0;i<numpnts(wPeriodsWin);i+=1)
				KillWindow/Z $"CompareGraph" + num2str(i)
			endfor
			break
		case "Activate":
			//print "Activate event"
			break
	endswitch
	return hookResult // 0 if nothing done, else 1
End

Function ListBoxProc_Left(lba) : ListBoxControl
	STRUCT WMListboxAction &lba
	Variable row = lba.row
	Variable col = lba.col
	WAVE/T/Z listWave = lba.listWave
	WAVE/Z selWave = lba.selWave
	wave wPeriodsWinSel = root:Compare:VarWaves:wPeriodsWinSel
	NVAR lowvalueL = root:Compare:Variables:lowvalueL
	NVAR highvalueL = root:Compare:Variables:highvalueL
	NVAR lowvalueR = root:Compare:Variables:lowvalueR
	NVAR highvalueR = root:Compare:Variables:highvalueR
	string currenttraces
	string oldtrace
	string newtrace
	string panel = "CompareGraph"
	string selectedwave, selectedwave_TS
	string SelectedPeriods
	variable i, j, SelectedPeriod_index, items
	variable SelectedLAxisWave_index = -1
	string Ltrace
	string Rtrace
	string Trace1Axis
	string Panels4Simetrization = ""
	variable openwindows = 0

	switch( lba.eventCode )
		case -1: // control being killed
			break
		case 1: // mouse down
			break
		case 3: // double click
			break
		case 4: // cell selection
			//print "listthings", row, col, listWave, selWave
			for (i=0; i<numpnts(selWave); i+=1) //acha qual wave selecionada
				if (selWave[i] == 1)
					SelectedLAxisWave_index = i
					break
				endif
			endfor
			for (i=0; i<numpnts(wPeriodsWinSel); i+=1) //para cada periodo selecionado na wave de seleção
				SelectedPeriod_index = i
				if (wPeriodsWinSel[i] == 1)
					Panels4Simetrization = Panels4Simetrization + panel + num2str(i) + ";"
					if (stringmatch(stringfromlist(0,WinList((panel+num2str(i)), ";", "")), (panel+num2str(i))) == 0) //se janela de graph não está aberta
						CompareGraphWin(i) //abra janela de gráficos c/ indice do periodo selecionado
						openwindows = 1
		 				selectedwave = ReplaceString(":", listWave[row], "_") + "_" + num2str(i)
		 				selectedwave_TS = listWave[row] + "_TS" + "_" + num2str(i)
		 				selectedwave_TS = ReplaceString(":", selectedwave_TS, "_")
						DoWindow /F $(panel+num2str(i)) //foco para a janela do gráfico
						AppendToGraph $selectedwave vs $selectedwave_TS //adiciono trace referente à wave
						Label left "\\c"
						Findpeaks(i, $selectedwave, "left") //atualizo variaveis de low e high values
					else //se a janela e graph já está aberta
						openwindows = 1
						if (SelectedLAxisWave_index != -1) //se waves foram selecionadas na lista Left Axis
							DoWindow /F $(panel+num2str(i)) //foco para a janela do gráfico
							Ltrace = IdAxisWave("Left") //wave usada no axis esquerdo
							Rtrace = IdAxisWave("Right") //wave usada no axis direito
				 			selectedwave = ReplaceString(":", listWave[row], "_") + "_" + num2str(SelectedPeriod_index)
				 			selectedwave_TS = ReplaceString(":", listWave[row] + "_TS" + "_" + num2str(SelectedPeriod_index), "_")
							if (stringmatch(Ltrace, "!") == 1 ) //se há traces no eixo esquerdo
								if (StringMatch(Ltrace,Rtrace)) //se traces são da mesma wave
									Trace1Axis = (StringFromList(1, TraceInfo("", Ltrace, 1))) //eixo onde a instancia 1 do trace está
									if (stringmatch(StringFromList(0, Trace1Axis), "*left*")) //se a instancia 1 está no eixo esquerdo
										//ReplaceWave trace=$Ltrace#1, $selectedwave;DelayUpdate 
										//ReplaceWave /X trace=$Ltrace, $selectedwave_TS
										RemovefromGraph/Z $Ltrace#1
										AppendToGraph $selectedwave vs $selectedwave_TS
										Label left "\\c"
										Findpeaks(i, $selectedwave, "left")
										//RemovefromGraph/Z $Ltrace
										//AppendToGraph $selectedwave vs $selectedwave_TS
									elseif (stringmatch(StringFromList(0, Trace1Axis), "*right*")) //se a instancia 1 está no eixo direito
										//ReplaceWave trace=$Ltrace, $selectedwave;DelayUpdate
										//ReplaceWave /X trace=$Ltrace, $selectedwave_TS
										RemovefromGraph/Z $Ltrace
										AppendToGraph $selectedwave vs $selectedwave_TS
										Label left "\\c"
										Findpeaks(i, $selectedwave, "left")
										//RemovefromGraph/Z $Ltrace#1
										//AppendToGraph $selectedwave vs $selectedwave_TS
									else
										print "Error traces same wave didnt found left or right"
									endif
								else //se traces não são da mesma wave
									RemovefromGraph/Z $Ltrace
									AppendToGraph $selectedwave vs $selectedwave_TS
									//ReplaceWave trace=$Ltrace, $selectedwave;DelayUpdate
									//Ltrace = IdAxisWave("Left") //wave usada no axis esquerdo
									//ReplaceWave /X trace=$Ltrace, $selectedwave_TS
									Label left "\\c"
									Findpeaks(i, $selectedwave, "left")
								endif
								//print "selwaves", selectedwave, selectedwave_TS
							else //se não há traces no gráfico
								//print "selwaves", selectedwave, selectedwave_TS
								//DoWindow /F $(panel+num2str(i))
								AppendToGraph $selectedwave vs $selectedwave_TS
								Label left "\\c"
								Findpeaks(i, $selectedwave, "left")
							endif
						else //se não há waves selecionadas
							//currenttraces = TraceNameList((panel+num2str(i)),";",1)
							DoWindow /F $(panel+num2str(i))
							Rtrace = IdAxisWave("Right") //trace da direita de antes da selecao de outra wave na lista
							Ltrace = IdAxisWave("Left") //trace da esquerda de antes da selecao de outra wave na lista
							if (StringMatch(Rtrace,Ltrace)) //se traces são da mesma wave
								Trace1Axis = (StringFromList(1, TraceInfo("", Ltrace, 1))) //eixo onde a instancia 1 do trace está
								if (stringmatch(StringFromList(0, Trace1Axis), "*left*")) //se a instancia 1 está no eixo esquerdo
									RemovefromGraph/Z $Ltrace#1
								else //se a instancia 0 está no eixo direito
									RemovefromGraph/Z $Ltrace
								endif
							else //se traces não são da mesma wave
								if (stringmatch(Ltrace, "") != 1)
									RemovefromGraph/Z $Ltrace
								endif
							endif
							//RemovefromGraph/Z /W=$(panel+num2str(i)) $Rtrace
						endif
					endif
					if (stringmatch(AxisInfo("","left"),"!"))
						ModifyGraph axRGB(left)=(65535,0,0),tlblRGB(left)=(65535,0,0),alblRGB(left)=(65535,0,0)
					endif
					//ModifyGraph axRGB(left)=(65535,0,0),tlblRGB(left)=(65535,0,0),alblRGB(left)=(65535,0,0)
				endif	
			endfor
			if (openwindows==1)
				if (stringmatch(AxisInfo("","left"),"!"))
					SimetrizaEixos("left", Panels4Simetrization)
				endif
			endif
			lowvalueL = inf
			lowvalueR = inf
			highvalueL = -inf
			highvalueR = -inf
			KillVariables/Z V_max, V_min, V_Flag
			DoWindow /F window_compare
			break
		case 5: // cell selection plus shift key
			break
		case 6: // begin edit
			break
		case 7: // finish edit
			break
		case 13: // checkbox clicked (Igor 6.2 or later)
			break
	endswitch
	return 0
End

Function ListBoxProc_Right(lba) : ListBoxControl
	STRUCT WMListboxAction &lba
	Variable row = lba.row
	Variable col = lba.col
	WAVE/T/Z listWave = lba.listWave
	WAVE/Z selWave = lba.selWave
	wave wPeriodsWinSel = root:Compare:VarWaves:wPeriodsWinSel
	NVAR lowvalueL = root:Compare:Variables:lowvalueL
	NVAR highvalueL = root:Compare:Variables:highvalueL
	NVAR lowvalueR = root:Compare:Variables:lowvalueR
	NVAR highvalueR = root:Compare:Variables:highvalueR
	string currenttraces
	string oldtrace
	string newtrace
	string panel = "CompareGraph"
	string selectedwave, selectedwave_TS
	string SelectedPeriods
	variable i, j, SelectedPeriod_index, items
	variable SelectedRAxisWave_index = -1
	string Ltrace
	string Rtrace
	string Trace1Axis
	string Panels4Simetrization = ""
	variable openwindows = 0

	switch( lba.eventCode )
		case -1: // control being killed
			break
		case 1: // mouse down
			break
		case 3: // double click
			break
		case 4: // cell selection
			//print "listthings", row, col, listWave, selWave
			for (i=0; i<numpnts(selWave); i+=1) //acha qual wave selecionada
				if (selWave[i] == 1)
					SelectedRAxisWave_index = i
					break
				endif
			endfor
			for (i=0; i<numpnts(wPeriodsWinSel); i+=1) //para cada periodo selecionado na wave de seleção
				SelectedPeriod_index = i
				if (wPeriodsWinSel[i] == 1)
					Panels4Simetrization = Panels4Simetrization + panel + num2str(i) + ";"
					if (stringmatch(stringfromlist(0,WinList((panel+num2str(i)), ";", "")), (panel+num2str(i))) == 0) //se janela de graph não está aberta
						CompareGraphWin(i) //abra janela de gráficos c/ indice do periodo selecionado
						openwindows = 1
		 				selectedwave = ReplaceString(":", listWave[row], "_") + "_" + num2str(i)
		 				selectedwave_TS = listWave[row] + "_TS" + "_" + num2str(i)
		 				selectedwave_TS = ReplaceString(":", selectedwave_TS, "_")
						DoWindow /F $(panel+num2str(i)) //foco para a janela do gráfico
						AppendToGraph /R $selectedwave vs $selectedwave_TS //adiciono trace referente à wave
						ModifyGraph rgb($selectedwave)=(1,16019,65535)
						Label left "\\c"
						Findpeaks(i, $selectedwave, "left") //atualizo variaveis de low e high vaelues
					else //se a janela e graph já está aberta
						openwindows = 1
						if (SelectedRAxisWave_index != -1) //se waves foram selecionadas na lista Right Axis
							DoWindow /F $(panel+num2str(i)) //foco para a janela do gráfico
							Ltrace = IdAxisWave("Left") //wave usada no axis esquerdo
							Rtrace = IdAxisWave("Right") //wave usada no axis direito
				 			selectedwave = ReplaceString(":", listWave[row], "_") + "_" + num2str(SelectedPeriod_index)
				 			selectedwave_TS = ReplaceString(":", listWave[row] + "_TS" + "_" + num2str(SelectedPeriod_index), "_")
							if (stringmatch(Rtrace, "!") == 1 ) //se há traces no eixo direito
								if (StringMatch(Ltrace,Rtrace)) //se traces são da mesma wave
									Trace1Axis = (StringFromList(1, TraceInfo("", Rtrace, 1))) //eixo onde a instancia 1 do trace está
									if (stringmatch(StringFromList(0, Trace1Axis), "*right*")) //se a instancia 1 está no eixo direito
										//ReplaceWave trace=$Ltrace#1, $selectedwave;DelayUpdate 
										//ReplaceWave /X trace=$Ltrace, $selectedwave_TS
										RemovefromGraph/Z $Rtrace#1
										AppendToGraph /R $selectedwave vs $selectedwave_TS
										Rtrace = IdAxisWave("Right") //wave usada no axis direito
										if (IsInstaceOne(Rtrace, "right"))
											ModifyGraph rgb($selectedwave#1)=(1,16019,65535)
										else
											ModifyGraph rgb($selectedwave)=(1,16019,65535)
										endif
										Label right "\\c"
										Findpeaks(i, $selectedwave, "right")
										//RemovefromGraph/Z $Ltrace
										//AppendToGraph $selectedwave vs $selectedwave_TS
									elseif (stringmatch(StringFromList(0, Trace1Axis), "*left*")) //se a instancia 1 está no eixo esquerdo
										//ReplaceWave trace=$Ltrace, $selectedwave;DelayUpdate
										//ReplaceWave /X trace=$Ltrace, $selectedwave_TS
										RemovefromGraph/Z $Rtrace
										AppendToGraph /R $selectedwave vs $selectedwave_TS
										Rtrace = IdAxisWave("Right") //wave usada no axis direito
										if (IsInstaceOne(Rtrace, "right"))
											ModifyGraph rgb($selectedwave#1)=(1,16019,65535)
										else
											ModifyGraph rgb($selectedwave)=(1,16019,65535)
										endif
										Label right "\\c"
										Findpeaks(i, $selectedwave, "right")
										//RemovefromGraph/Z $Ltrace#1
										//AppendToGraph $selectedwave vs $selectedwave_TS
									else
										print "Error traces same wave didnt found left or right"
									endif
								else //se traces não são da mesma wave
									RemovefromGraph/Z $Rtrace
									AppendToGraph /R $selectedwave vs $selectedwave_TS
									Rtrace = IdAxisWave("Right") //wave usada no axis direito
									if (IsInstaceOne(Rtrace, "right"))
										ModifyGraph rgb($selectedwave#1)=(1,16019,65535)
									else
										ModifyGraph rgb($selectedwave)=(1,16019,65535)
									endif
									//ReplaceWave trace=$Ltrace, $selectedwave;DelayUpdate
									//Ltrace = IdAxisWave("Left") //wave usada no axis esquerdo
									//ReplaceWave /X trace=$Ltrace, $selectedwave_TS
									Label right "\\c"
									Findpeaks(i, $selectedwave, "right")
								endif
								//print "selwaves", selectedwave, selectedwave_TS
							else //se não há traces no gráfico
								//print "selwaves", selectedwave, selectedwave_TS
								//DoWindow /F $(panel+num2str(i))
								AppendToGraph /R $selectedwave vs $selectedwave_TS
								Rtrace = IdAxisWave("Right") //wave usada no axis direito
								if (IsInstaceOne(Rtrace, "right"))
									ModifyGraph rgb($selectedwave#1)=(1,16019,65535)
								else
									ModifyGraph rgb($selectedwave)=(1,16019,65535)
								endif
								Label right "\\c"
								Findpeaks(i, $selectedwave, "right")
							endif
						else //se não há waves selecionadas
							//currenttraces = TraceNameList((panel+num2str(i)),";",1)
							DoWindow /F $(panel+num2str(i))
							Rtrace = IdAxisWave("Right") //trace da direita de antes da selecao de outra wave na lista
							Ltrace = IdAxisWave("Left") //trace da esquerda de antes da selecao de outra wave na lista
							if (StringMatch(Rtrace,Ltrace)) //se traces são da mesma wave
								Trace1Axis = (StringFromList(1, TraceInfo("", Rtrace, 1))) //eixo onde a instancia 1 do trace está
								if (stringmatch(StringFromList(0, Trace1Axis), "*right*")) //se a instancia 1 está no eixo direito
									RemovefromGraph/Z $Rtrace#1
								else //se a instancia 0 está no eixo direito
									RemovefromGraph/Z $Rtrace
								endif
							else //se traces não são da mesma wave
								if (stringmatch(Rtrace, "") != 1)
									RemovefromGraph/Z $Rtrace
								endif
							endif
							//RemovefromGraph/Z /W=$(panel+num2str(i)) $Rtrace
						endif
					endif
					if (stringmatch(AxisInfo("","right"),"!") && openwindows==1)
						ModifyGraph axRGB(right)=(1,16019,65535),tlblRGB(right)=(1,16019,65535),alblRGB(right)=(1,16019,65535)
					endif
				endif	
			endfor
			if (openwindows==1)
				if (stringmatch(AxisInfo("","right"),"!"))
					SimetrizaEixos("right", Panels4Simetrization)
				endif
			endif
			lowvalueL = inf
			lowvalueR = inf
			highvalueL = -inf
			highvalueR = -inf
			DoWindow /F window_compare
			break
		case 5: // cell selection plus shift key
			break
		case 6: // begin edit
			break
		case 7: // finish edit
			break
		case 13: // checkbox clicked (Igor 6.2 or later)
			break
	endswitch
	return 0
End
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ funções da janela de Compare Graph ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑//

//↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ funções da janela More do Compare ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓//
Function ButtonProc_AddPDG_Comp(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	wave/T wPDG = root:Compare:VarWaves:wPDG
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			AddPDGSel_Comp()
			ZeroSel_Comp()
			KillWindow PreDefinedGroups_Comp
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ funções da janela More do Compare↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑//