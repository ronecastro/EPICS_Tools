#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.
//Window LoadDataWindow() : Panel
//	PauseUpdate; Silent 1		// building window...
//	KillWindow /Z LoadDataWindow
//	NewPanel /K=1 /FLT=0 /N=LoadDataWindow /W=(9,55,525,677) as "LOAD DATA"
//	SetActiveSubwindow _endfloat_
//	ModifyPanel fixedSize=1
//	SetDrawLayer UserBack

Window LoadDataWindow() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /W=(1402,208,1918,836) as "LOAD DATA"
	ModifyPanel fixedSize=1
	SetDrawLayer UserBack
	DrawRect 44,118,464,184
	DrawText 58,146,"DD"
	DrawText 115,146,"MM"
	DrawText 172,146,"YYYY"
	DrawText 268,146,"HH"
	DrawText 329,146,"MM"
	DrawText 394,146,"SS"
	DrawText 44,115,"START DATE/HOUR:"
	DrawRect 44,214,464,280
	DrawText 58,242,"DD"
	DrawText 115,242,"MM"
	DrawText 172,242,"YYYY"
	DrawText 268,242,"HH"
	DrawText 329,242,"MM"
	DrawText 394,242,"SS"
	DrawText 45,210,"END DATE/HOUR:"
	DrawText 48,356,"EPICS Name / Search Filter (RegEx syntax):"
	DrawText 325,52,"TimeZone (h):"
	DrawText 320,79,"TimeStamp(s):"
	SetVariable svStartDay,pos={57.00,150.00},size={50.00,17.00},title=" "
	SetVariable svStartDay,help={"Day"},format="%02d"
	SetVariable svStartDay,limits={1,31,1},value= root:GlobalVariables:dds
	SetVariable svStartMonth,pos={114.00,150.00},size={50.00,17.00},title=" "
	SetVariable svStartMonth,help={"Month"},format="%02d"
	SetVariable svStartMonth,limits={1,12,1},value= root:GlobalVariables:mms
	SetVariable svStartYear,pos={171.00,150.00},size={50.00,17.00},title=" "
	SetVariable svStartYear,help={"Year"},format="%04d"
	SetVariable svStartYear,limits={2000,3000,1},value= root:GlobalVariables:yyyys
	SetVariable svStartHour,pos={267.00,150.00},size={50.00,17.00},title=" "
	SetVariable svStartHour,help={"Hour"},format="%02d"
	SetVariable svStartHour,limits={0,23,1},value= root:GlobalVariables:hs
	SetVariable svStartMin,pos={328.00,150.00},size={50.00,17.00},title=" "
	SetVariable svStartMin,help={"Minute"},format="%02d"
	SetVariable svStartMin,limits={0,59,1},value= root:GlobalVariables:ms
	SetVariable svStartSec,pos={392.00,150.00},size={58.00,17.00},title=" "
	SetVariable svStartSec,help={"Second"},format="%.3f"
	SetVariable svStartSec,limits={0,59,1},value= root:GlobalVariables:ss
	SetVariable svEndDay,pos={57.00,246.00},size={50.00,17.00},disable=2,title=" "
	SetVariable svEndDay,help={"Day"},format="%02d"
	SetVariable svEndDay,limits={1,31,1},value= root:GlobalVariables:dde
	SetVariable svEndMonth,pos={114.00,246.00},size={50.00,17.00},disable=2,title=" "
	SetVariable svEndMonth,help={"Month"},format="%02d"
	SetVariable svEndMonth,limits={1,12,1},value= root:GlobalVariables:mme
	SetVariable svEndYear,pos={171.00,246.00},size={50.00,17.00},disable=2,title=" "
	SetVariable svEndYear,help={"Year"},format="%04d"
	SetVariable svEndYear,limits={2000,3000,1},value= root:GlobalVariables:yyyye
	SetVariable svEndHour,pos={267.00,246.00},size={50.00,17.00},disable=2,title=" "
	SetVariable svEndHour,help={"Hour"},format="%02d"
	SetVariable svEndHour,limits={0,23,1},value= root:GlobalVariables:he
	SetVariable svEndMin,pos={328.00,246.00},size={50.00,17.00},disable=2,title=" "
	SetVariable svEndMin,help={"Minute"},format="%02d"
	SetVariable svEndMin,limits={0,59,1},value= root:GlobalVariables:me
	SetVariable svEndSec,pos={392.00,246.00},size={58.00,17.00},disable=2,title=" "
	SetVariable svEndSec,help={"Second"},format="%.3f"
	SetVariable svEndSec,limits={0,59,1},value= root:GlobalVariables:se
	SetVariable svSearchField,pos={48.00,358.00},size={315.00,17.00},title=" "
	SetVariable svSearchField,help={"Hints:\r(.) = one character;\r(.+) = one or more characters;\r(.*) = zero or more characters;\r(^) = 'start with' character;\r($) = 'end with' character;\rEx: ^SI-02.+CCG-...:Pressure-Mon$\rEx: ^SI-....:DI-BPM.*:PosX-Mon$"}
	SetVariable svSearchField,value= root:GlobalVariables:gSearchField,live= 1
	GroupBox group0,pos={27.00,8.00},size={460.00,289.00},title="\\BPERIOD",fSize=20
	PopupMenu puPeriod,pos={45.00,35.00},size={141.00,17.00},bodyWidth=141,proc=PopMenuProc_Period
	PopupMenu puPeriod,mode=6,popvalue="Fixed Start / End Now",value= #"\"Last Hour;Last 3 Hours;Last 6 Hours;Last 24 Hours;Fixed Start / Fixed End;Fixed Start / End Now\""
	PopupMenu puInterval,pos={45.00,61.00},size={247.00,17.00},bodyWidth=247,disable=2,proc=PopMenuProc_Interval
	PopupMenu puInterval,mode=1,popvalue="Default Variable Interval",value= #"\"Default Variable Interval;Interval: 10 Points;Interval: 30 Points;Interval: 60 Points;Interval: 300 Points;Interval: Custom\""
	PopupMenu puMethod,pos={212.00,34.00},size={80.00,17.00},bodyWidth=80,proc=PopMenuProc_Method
	PopupMenu puMethod,mode=1,popvalue="Normal",value= #"\"Normal;Average;Minimum;Maximum;N-th\""
	SetVariable svNth,pos={245.00,89.00},size={47.00,18.00},disable=1,title=" "
	SetVariable svNth,format="%d"
	SetVariable svNth,limits={2,inf,0},value= root:GlobalVariables:gInterval
	GroupBox group1,pos={27.00,309.00},size={460.00,289.00},title="\\BPARAMETERS SELETION"
	GroupBox group1,fSize=20
	Button btnLoadSelection,pos={379.00,418.00},size={90.00,29.00},proc=ButtonProc_LoadSelection,title="Load Selection"
	Button btnAddSelection,pos={379.00,358.00},size={56.00,19.00},proc=ButtonProc_AddSelection,title="Add"
	Button brnDel,pos={47.00,557.00},size={125.00,20.00},proc=ButtonProc_DeleteFromSelection,title="Delete from Selection"
	Button brnDel,help={"Hint:\rYou can 'Shift+Click' the lines above to delete multiple ones."}
	ListBox lbSelectionList,pos={48.00,394.00},size={315.00,146.00}
	ListBox lbSelectionList,listWave=root:VarList:wParameters2Search
	ListBox lbSelectionList,selWave=root:VarList:wParameterSel,mode= 4
	SetVariable svAdjustDH,pos={405.00,62.00},size={60.00,17.00},title=" "
	SetVariable svAdjustDH,value= root:GlobalVariables:gAdjustDH
	CheckBox cburl,pos={381.00,478.00},size={64.00,14.00},title="Print URL"
	CheckBox cburl,variable= root:GlobalVariables:gPrintURL
	SetVariable svAdjustTimezone,pos={405.00,35.00},size={60.00,17.00},title=" "
	SetVariable svAdjustTimezone,help={"Archiver solicitations must have\rfuse adjust for current timezone"}
	SetVariable svAdjustTimezone,format="%d"
	SetVariable svAdjustTimezone,limits={-11,14,1},value= root:GlobalVariables:gTimezone
	CheckBox cbBPMs,pos={381.00,454.00},size={89.00,14.00},title="BPMs to Zero"
	CheckBox cbBPMs,variable= root:GlobalVariables:gZRbpms
	Button btnMore,pos={440.00,358.00},size={28.00,19.00},proc=ButtonProc_OpenPDG,title="..."
	Button btnMore,help={"Hint:\rClick to select predefined groups to add to Selection Parameters."}
	ValDisplay vdBar,pos={27.00,604.00},size={459.00,17.00},disable=1
	ValDisplay vdBar,limits={0,100,0},barmisc={0,0},mode= 3,highColor= (0,65535,0)
	ValDisplay vdBar,value= _NUM:100
	Button btnCancel,pos={379.00,512.00},size={90.00,29.00},disable=1,title="Cancel"
	SetWindow kwTopWin,hook(spinner)=LoadDataWindowSpinHook
EndMacro

Window PreDefinedGroups() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /W=(897,109,1560,777) as "Predefined Groups..."
	TabControl tab0,pos={6.00,7.00},size={651.00,656.00},proc=tabcontrol_PDG
	TabControl tab0,tabLabel(0)="PS/PU/LLRF/BPMs",tabLabel(1)="Temperatures"
	TabControl tab0,value= 0
	GroupBox tab1_group0,pos={25.00,37.00},size={149.00,239.00},title="LI "
	CheckBox tab1_check0,pos={40.00,59.00},size={32.00,14.00},proc=CheckProc_PDG,title="EG"
	CheckBox tab1_check0,value= 0
	CheckBox tab1_check1,pos={40.00,84.00},size={29.00,14.00},proc=CheckProc_PDG,title="PU"
	CheckBox tab1_check1,value= 0
	CheckBox tab1_check2,pos={40.00,108.00},size={42.00,14.00},title="LLRF",value= 0
	CheckBox tab1_check3,pos={58.00,133.00},size={38.00,14.00},proc=CheckProc_PDG,title="BUN"
	CheckBox tab1_check3,value= 0
	CheckBox tab1_check4,pos={58.00,158.00},size={41.00,14.00},proc=CheckProc_PDG,title="KLY1"
	CheckBox tab1_check4,value= 0
	CheckBox tab1_check5,pos={58.00,182.00},size={42.00,14.00},proc=CheckProc_PDG,title="KLY2"
	CheckBox tab1_check5,value= 0
	CheckBox tab1_check7,pos={40.00,206.00},size={29.00,14.00},proc=CheckProc_PDG,title="PS"
	CheckBox tab1_check7,value= 0
	GroupBox tab1_group1,pos={188.00,37.00},size={173.00,168.00},title="TB"
	CheckBox tab1_check22,pos={283.00,58.00},size={29.00,14.00},proc=CheckProc_PDG,title="PU"
	CheckBox tab1_check22,value= 0
	CheckBox tab1_check24,pos={283.00,81.00},size={38.00,14.00},title="BPM",value= 0
	CheckBox tab1_check25,pos={200.00,58.00},size={29.00,14.00},title="PS",value= 0
	CheckBox tab1_check26,pos={218.00,81.00},size={23.00,14.00},proc=CheckProc_PDG,title="B"
	CheckBox tab1_check26,value= 0
	CheckBox tab1_check27,pos={218.00,105.00},size={33.00,14.00},proc=CheckProc_PDG,title="QD"
	CheckBox tab1_check27,value= 0
	CheckBox tab1_check28,pos={218.00,130.00},size={32.00,14.00},proc=CheckProc_PDG,title="QF"
	CheckBox tab1_check28,value= 0
	CheckBox tab1_check29,pos={218.00,155.00},size={32.00,14.00},proc=CheckProc_PDG,title="CH"
	CheckBox tab1_check29,value= 0
	CheckBox tab1_check30,pos={218.00,179.00},size={32.00,14.00},proc=CheckProc_PDG,title="CV"
	CheckBox tab1_check30,value= 0
	CheckBox tab1_check8,pos={40.00,230.00},size={38.00,14.00},proc=CheckProc_PDG,title="BPM"
	CheckBox tab1_check8,value= 0
	CheckBox tab1_check34,pos={301.00,103.00},size={45.00,14.00},proc=CheckProc_PDG,title="XBPM"
	CheckBox tab1_check34,value= 0
	CheckBox tab1_check35,pos={301.00,128.00},size={45.00,14.00},proc=CheckProc_PDG,title="YBPM"
	CheckBox tab1_check35,value= 0
	GroupBox tab1_group2,pos={375.00,37.00},size={174.00,238.00},title="BO "
	CheckBox tab1_check36,pos={470.00,59.00},size={29.00,14.00},proc=CheckProc_PDG,title="PU"
	CheckBox tab1_check36,value= 0
	CheckBox tab1_check37,pos={470.00,84.00},size={30.00,14.00},proc=CheckProc_PDG,title="RF"
	CheckBox tab1_check37,value= 0
	CheckBox tab1_check38,pos={470.00,108.00},size={38.00,14.00},title="BPM"
	CheckBox tab1_check38,value= 0
	CheckBox tab1_check39,pos={387.00,57.00},size={29.00,14.00},title="PS",value= 0
	CheckBox tab1_check40,pos={405.00,81.00},size={23.00,14.00},proc=CheckProc_PDG,title="B"
	CheckBox tab1_check40,value= 0
	CheckBox tab1_check41,pos={405.00,105.00},size={33.00,14.00},proc=CheckProc_PDG,title="QD"
	CheckBox tab1_check41,value= 0
	CheckBox tab1_check42,pos={405.00,130.00},size={32.00,14.00},proc=CheckProc_PDG,title="QF"
	CheckBox tab1_check42,value= 0
	CheckBox tab1_check43,pos={405.00,155.00},size={32.00,14.00},proc=CheckProc_PDG,title="QS"
	CheckBox tab1_check43,value= 0
	CheckBox tab1_check44,pos={405.00,179.00},size={31.00,14.00},proc=CheckProc_PDG,title="SD"
	CheckBox tab1_check44,value= 0
	CheckBox tab1_check45,pos={405.00,202.00},size={30.00,14.00},proc=CheckProc_PDG,title="SF"
	CheckBox tab1_check45,value= 0
	CheckBox tab1_check46,pos={405.00,225.00},size={32.00,14.00},proc=CheckProc_PDG,title="CH"
	CheckBox tab1_check46,value= 0
	CheckBox tab1_check47,pos={405.00,248.00},size={32.00,14.00},proc=CheckProc_PDG,title="CV"
	CheckBox tab1_check47,value= 0
	CheckBox tab1_check48,pos={488.00,130.00},size={45.00,14.00},proc=CheckProc_PDG,title="XBPM"
	CheckBox tab1_check48,value= 0
	CheckBox tab1_check49,pos={488.00,155.00},size={45.00,14.00},proc=CheckProc_PDG,title="YBPM"
	CheckBox tab1_check49,value= 0
	GroupBox tab1_group3,pos={25.00,284.00},size={174.00,168.00},title="TS"
	CheckBox tab1_check31,pos={120.00,306.00},size={29.00,14.00},proc=CheckProc_PDG,title="PU"
	CheckBox tab1_check31,value= 0
	CheckBox tab1_check33,pos={120.00,329.00},size={38.00,14.00},title="BPM"
	CheckBox tab1_check33,value= 0
	CheckBox tab1_check50,pos={37.00,305.00},size={29.00,14.00},title="PS",value= 0
	CheckBox tab1_check51,pos={55.00,328.00},size={23.00,14.00},proc=CheckProc_PDG,title="B"
	CheckBox tab1_check51,value= 0
	CheckBox tab1_check52,pos={55.00,352.00},size={33.00,14.00},proc=CheckProc_PDG,title="QD"
	CheckBox tab1_check52,value= 0
	CheckBox tab1_check53,pos={55.00,377.00},size={32.00,14.00},proc=CheckProc_PDG,title="QF"
	CheckBox tab1_check53,value= 0
	CheckBox tab1_check54,pos={55.00,402.00},size={32.00,14.00},proc=CheckProc_PDG,title="CH"
	CheckBox tab1_check54,value= 0
	CheckBox tab1_check55,pos={55.00,426.00},size={32.00,14.00},proc=CheckProc_PDG,title="CV"
	CheckBox tab1_check55,value= 0
	CheckBox tab1_check56,pos={138.00,351.00},size={45.00,14.00},proc=CheckProc_PDG,title="XBPM"
	CheckBox tab1_check56,value= 0
	CheckBox tab1_check57,pos={138.00,376.00},size={45.00,14.00},proc=CheckProc_PDG,title="YBPM"
	CheckBox tab1_check57,value= 0
	GroupBox tab1_group4,pos={207.00,284.00},size={429.00,357.00},title="SI"
	CheckBox tab1_check58,pos={238.00,495.00},size={45.00,14.00},proc=CheckProc_PDG,title="QDP1"
	CheckBox tab1_check58,value= 0
	CheckBox tab1_check59,pos={238.00,519.00},size={46.00,14.00},proc=CheckProc_PDG,title="QDP2"
	CheckBox tab1_check59,value= 0
	CheckBox tab1_check60,pos={304.00,327.00},size={31.00,14.00},proc=CheckProc_PDG,title="Q1"
	CheckBox tab1_check60,value= 0
	CheckBox tab1_check61,pos={220.00,303.00},size={29.00,14.00},title="PS",value= 0
	CheckBox tab1_check62,pos={238.00,326.00},size={23.00,14.00},proc=CheckProc_PDG,title="B"
	CheckBox tab1_check62,value= 0
	CheckBox tab1_check63,pos={238.00,350.00},size={38.00,14.00},proc=CheckProc_PDG,title="QFA"
	CheckBox tab1_check63,value= 0
	CheckBox tab1_check64,pos={238.00,375.00},size={38.00,14.00},proc=CheckProc_PDG,title="QFB"
	CheckBox tab1_check64,value= 0
	CheckBox tab1_check65,pos={238.00,400.00},size={37.00,14.00},proc=CheckProc_PDG,title="QFP"
	CheckBox tab1_check65,value= 0
	CheckBox tab1_check66,pos={238.00,424.00},size={41.00,14.00},proc=CheckProc_PDG,title="QDA"
	CheckBox tab1_check66,value= 0
	CheckBox tab1_check67,pos={238.00,447.00},size={46.00,14.00},proc=CheckProc_PDG,title="QDB1"
	CheckBox tab1_check67,value= 0
	CheckBox tab1_check68,pos={238.00,470.00},size={47.00,14.00},proc=CheckProc_PDG,title="QDB2"
	CheckBox tab1_check68,value= 0
	CheckBox tab1_check70,pos={304.00,350.00},size={32.00,14.00},proc=CheckProc_PDG,title="Q2"
	CheckBox tab1_check70,value= 0
	CheckBox tab1_check71,pos={304.00,375.00},size={32.00,14.00},proc=CheckProc_PDG,title="Q3"
	CheckBox tab1_check71,value= 0
	CheckBox tab1_check9,pos={40.00,253.00},size={31.00,14.00},proc=CheckProc_PDG,title="VA"
	CheckBox tab1_check9,value= 0
	CheckBox tab1_check72,pos={283.00,151.00},size={31.00,14.00},proc=CheckProc_PDG,title="VA"
	CheckBox tab1_check72,value= 0
	CheckBox tab1_check73,pos={470.00,179.00},size={31.00,14.00},proc=CheckProc_PDG,title="VA"
	CheckBox tab1_check73,value= 0
	CheckBox tab1_check74,pos={120.00,402.00},size={31.00,14.00},proc=CheckProc_PDG,title="VA"
	CheckBox tab1_check74,value= 0
	CheckBox tab1_check75,pos={304.00,399.00},size={33.00,14.00},proc=CheckProc_PDG,title="Q4"
	CheckBox tab1_check75,value= 0
	CheckBox tab1_check76,pos={304.00,424.00},size={41.00,14.00},proc=CheckProc_PDG,title="SFA0"
	CheckBox tab1_check76,value= 0
	CheckBox tab1_check69,pos={304.00,495.00},size={42.00,14.00},proc=CheckProc_PDG,title="SFB0"
	CheckBox tab1_check69,value= 0
	CheckBox tab1_check77,pos={304.00,519.00},size={42.00,14.00},proc=CheckProc_PDG,title="SFB1"
	CheckBox tab1_check77,value= 0
	CheckBox tab1_check78,pos={366.00,330.00},size={43.00,14.00},proc=CheckProc_PDG,title="SFB2"
	CheckBox tab1_check78,value= 0
	CheckBox tab1_check79,pos={366.00,353.00},size={41.00,14.00},proc=CheckProc_PDG,title="SFP0"
	CheckBox tab1_check79,value= 0
	CheckBox tab1_check80,pos={366.00,378.00},size={41.00,14.00},proc=CheckProc_PDG,title="SFP1"
	CheckBox tab1_check80,value= 0
	CheckBox tab1_check81,pos={366.00,402.00},size={42.00,14.00},proc=CheckProc_PDG,title="SFP2"
	CheckBox tab1_check81,value= 0
	CheckBox tab1_check82,pos={366.00,427.00},size={44.00,14.00},proc=CheckProc_PDG,title="SDA0"
	CheckBox tab1_check82,value= 0
	CheckBox tab1_check83,pos={304.00,447.00},size={41.00,14.00},proc=CheckProc_PDG,title="SFA1"
	CheckBox tab1_check83,value= 0
	CheckBox tab1_check84,pos={304.00,471.00},size={42.00,14.00},proc=CheckProc_PDG,title="SFA2"
	CheckBox tab1_check84,value= 0
	CheckBox tab1_check85,pos={366.00,450.00},size={44.00,14.00},proc=CheckProc_PDG,title="SDA1"
	CheckBox tab1_check85,value= 0
	CheckBox tab1_check86,pos={366.00,473.00},size={45.00,14.00},proc=CheckProc_PDG,title="SDA2"
	CheckBox tab1_check86,value= 0
	CheckBox tab1_check87,pos={366.00,497.00},size={45.00,14.00},proc=CheckProc_PDG,title="SDA3"
	CheckBox tab1_check87,value= 0
	CheckBox tab1_check88,pos={366.00,521.00},size={44.00,14.00},proc=CheckProc_PDG,title="SDB0"
	CheckBox tab1_check88,value= 0
	CheckBox tab1_check89,pos={431.00,331.00},size={44.00,14.00},proc=CheckProc_PDG,title="SDB1"
	CheckBox tab1_check89,value= 0
	CheckBox tab1_check90,pos={431.00,354.00},size={45.00,14.00},proc=CheckProc_PDG,title="SDB2"
	CheckBox tab1_check90,value= 0
	CheckBox tab1_check91,pos={431.00,378.00},size={45.00,14.00},proc=CheckProc_PDG,title="SDB3"
	CheckBox tab1_check91,value= 0
	CheckBox tab1_check92,pos={431.00,402.00},size={43.00,14.00},proc=CheckProc_PDG,title="SDP0"
	CheckBox tab1_check92,value= 0
	CheckBox tab1_check93,pos={431.00,427.00},size={43.00,14.00},proc=CheckProc_PDG,title="SDP1"
	CheckBox tab1_check93,value= 0
	CheckBox tab1_check94,pos={431.00,452.00},size={44.00,14.00},proc=CheckProc_PDG,title="SDP2"
	CheckBox tab1_check94,value= 0
	CheckBox tab1_check95,pos={431.00,475.00},size={44.00,14.00},proc=CheckProc_PDG,title="SDP3"
	CheckBox tab1_check95,value= 0
	CheckBox tab1_check96,pos={420.00,544.00},size={32.00,14.00},title="CV",value= 0
	CheckBox tab1_check97,pos={304.00,544.00},size={32.00,14.00},title="CH",value= 0
	CheckBox tab1_check98,pos={431.00,498.00},size={32.00,14.00},proc=CheckProc_PDG,title="QS"
	CheckBox tab1_check98,value= 0
	Button tab1_button0,pos={60.00,501.00},size={93.00,33.00},proc=ButtonProc_AddPDG,title="Add Selection"
	CheckBox tab1_check99,pos={492.00,306.00},size={38.00,14.00},title="BPM"
	CheckBox tab1_check99,value= 0
	CheckBox tab1_check00,pos={510.00,331.00},size={45.00,14.00},title="XBPM"
	CheckBox tab1_check00,value= 0
	CheckBox tab1_check01,pos={509.00,450.00},size={45.00,14.00},title="YBPM"
	CheckBox tab1_check01,value= 0
	CheckBox tab1_check02,pos={560.00,588.00},size={29.00,14.00},proc=CheckProc_PDG,title="PU"
	CheckBox tab1_check02,value= 0
	CheckBox tab1_check6,pos={124.00,59.00},size={32.00,14.00},proc=CheckProc_PDG,title="CH"
	CheckBox tab1_check6,value= 0
	CheckBox tab1_check07,pos={124.00,85.00},size={32.00,14.00},proc=CheckProc_PDG,title="CV"
	CheckBox tab1_check07,value= 0
	CheckBox tab1_check03,pos={220.00,541.00},size={31.00,14.00},title="VA",value= 0
	CheckBox tab1_check04,pos={238.00,564.00},size={41.00,14.00},proc=CheckProc_PDG,title="CCG"
	CheckBox tab1_check04,value= 0
	CheckBox tab1_check05,pos={238.00,588.00},size={47.00,14.00},proc=CheckProc_PDG,title="SIP20"
	CheckBox tab1_check05,value= 0
	CheckBox tab1_check06,pos={238.00,612.00},size={29.00,14.00},proc=CheckProc_PDG,title="FE"
	CheckBox tab1_check06,value= 0
	CheckBox tab1_check08,pos={528.00,356.00},size={31.00,14.00},proc=CheckProc_PDG,title="M1"
	CheckBox tab1_check08,value= 0
	CheckBox tab1_check09,pos={528.00,379.00},size={32.00,14.00},proc=CheckProc_PDG,title="M2"
	CheckBox tab1_check09,value= 0
	CheckBox tab1_check10,pos={528.00,402.00},size={41.00,14.00},proc=CheckProc_PDG,title="C1-1"
	CheckBox tab1_check10,value= 0
	CheckBox tab1_check11,pos={528.00,425.00},size={42.00,14.00},proc=CheckProc_PDG,title="C1-2"
	CheckBox tab1_check11,value= 0
	CheckBox tab1_check12,pos={581.00,356.00},size={31.00,14.00},proc=CheckProc_PDG,title="C2"
	CheckBox tab1_check12,value= 0
	CheckBox tab1_check13,pos={581.00,379.00},size={42.00,14.00},proc=CheckProc_PDG,title="C3-1"
	CheckBox tab1_check13,value= 0
	CheckBox tab1_check14,pos={581.00,402.00},size={43.00,14.00},proc=CheckProc_PDG,title="C3-2"
	CheckBox tab1_check14,value= 0
	CheckBox tab1_check15,pos={581.00,425.00},size={32.00,14.00},proc=CheckProc_PDG,title="C4"
	CheckBox tab1_check15,value= 0
	CheckBox tab1_check16,pos={528.00,471.00},size={31.00,14.00},proc=CheckProc_PDG,title="M1"
	CheckBox tab1_check16,value= 0
	CheckBox tab1_check17,pos={528.00,494.00},size={32.00,14.00},proc=CheckProc_PDG,title="M2"
	CheckBox tab1_check17,value= 0
	CheckBox tab1_check18,pos={528.00,517.00},size={41.00,14.00},proc=CheckProc_PDG,title="C1-1"
	CheckBox tab1_check18,value= 0
	CheckBox tab1_check19,pos={528.00,540.00},size={42.00,14.00},proc=CheckProc_PDG,title="C1-2"
	CheckBox tab1_check19,value= 0
	CheckBox tab1_check20,pos={581.00,471.00},size={31.00,14.00},proc=CheckProc_PDG,title="C2"
	CheckBox tab1_check20,value= 0
	CheckBox tab1_check21,pos={581.00,494.00},size={42.00,14.00},proc=CheckProc_PDG,title="C3-1"
	CheckBox tab1_check21,value= 0
	CheckBox tab1_check23,pos={581.00,517.00},size={43.00,14.00},proc=CheckProc_PDG,title="C3-2"
	CheckBox tab1_check23,value= 0
	CheckBox tab1_check32,pos={581.00,540.00},size={32.00,14.00},proc=CheckProc_PDG,title="C4"
	CheckBox tab1_check32,value= 0
	CheckBox tab1_check100,pos={321.00,565.00},size={31.00,14.00},proc=CheckProc_PDG,title="M1"
	CheckBox tab1_check100,value= 0
	CheckBox tab1_check101,pos={321.00,587.00},size={32.00,14.00},proc=CheckProc_PDG,title="M2"
	CheckBox tab1_check101,value= 0
	CheckBox tab1_check102,pos={321.00,609.00},size={30.00,14.00},proc=CheckProc_PDG,title="C1"
	CheckBox tab1_check102,value= 0
	CheckBox tab1_check103,pos={366.00,565.00},size={31.00,14.00},proc=CheckProc_PDG,title="C2"
	CheckBox tab1_check103,value= 0
	CheckBox tab1_check104,pos={366.00,587.00},size={31.00,14.00},proc=CheckProc_PDG,title="C3"
	CheckBox tab1_check104,value= 0
	CheckBox tab1_check105,pos={366.00,609.00},size={32.00,14.00},proc=CheckProc_PDG,title="C4"
	CheckBox tab1_check105,value= 0
	CheckBox tab1_check106,pos={437.00,566.00},size={31.00,14.00},proc=CheckProc_PDG,title="M1"
	CheckBox tab1_check106,value= 0
	CheckBox tab1_check107,pos={437.00,588.00},size={32.00,14.00},proc=CheckProc_PDG,title="M2"
	CheckBox tab1_check107,value= 0
	CheckBox tab1_check108,pos={437.00,610.00},size={30.00,14.00},proc=CheckProc_PDG,title="C1"
	CheckBox tab1_check108,value= 0
	CheckBox tab1_check111,pos={482.00,566.00},size={31.00,14.00},proc=CheckProc_PDG,title="C2"
	CheckBox tab1_check111,value= 0
	CheckBox tab1_check109,pos={482.00,588.00},size={31.00,14.00},proc=CheckProc_PDG,title="C3"
	CheckBox tab1_check109,value= 0
	CheckBox tab1_check110,pos={482.00,610.00},size={32.00,14.00},proc=CheckProc_PDG,title="C4"
	CheckBox tab1_check110,value= 0
	CheckBox tab2_check0,pos={35.00,70.00},size={101.00,14.00},disable=1,proc=CheckProc_PDG,title="Racks SI-Septa"
	CheckBox tab2_check0,value= 0
	CheckBox tab2_check1,pos={35.00,96.00},size={96.00,14.00},disable=1,proc=CheckProc_PDG,title="Racks Inj - BO"
	CheckBox tab2_check1,value= 0
	CheckBox tab2_check2,pos={35.00,122.00},size={90.00,14.00},disable=1,proc=CheckProc_PDG,title="Racks Timing"
	CheckBox tab2_check2,value= 0
	CheckBox tab2_check5,pos={35.00,353.00},size={139.00,14.00},disable=1,proc=CheckProc_PDG,title="DC-Links - Sextupoles"
	CheckBox tab2_check5,value= 0
	CheckBox tab2_check6,pos={35.00,378.00},size={114.00,14.00},disable=1,proc=CheckProc_PDG,title="DC-Links - Quads"
	CheckBox tab2_check6,value= 0
	CheckBox tab2_check7,pos={35.00,404.00},size={119.00,14.00},disable=1,proc=CheckProc_PDG,title="DC-Links - Dipoles"
	CheckBox tab2_check7,value= 0
	GroupBox tab2_group0,pos={23.00,43.00},size={141.00,268.00},disable=1,title="Racks"
	GroupBox tab2_group1,pos={23.00,323.00},size={160.00,112.00},disable=1,title="DC-Links"
	GroupBox tab2_group2,pos={23.00,451.00},size={180.00,191.00},disable=1,title="Air Cond."
	CheckBox tab2_check8,pos={36.00,483.00},size={138.00,14.00},disable=1,proc=CheckProc_PDG,title="Tunnel Temperature 1"
	CheckBox tab2_check8,value= 0
	CheckBox tab2_check9,pos={36.00,533.00},size={112.00,14.00},disable=1,proc=CheckProc_PDG,title="Hall Temperature"
	CheckBox tab2_check9,value= 0
	CheckBox tab2_check4,pos={36.00,559.00},size={87.00,14.00},disable=1,proc=CheckProc_PDG,title="Server Room"
	CheckBox tab2_check4,value= 0
	GroupBox tab2_group3,pos={245.00,42.00},size={129.00,141.00},disable=1,title="LINAC"
	CheckBox tab2_check05,pos={258.00,71.00},size={110.00,14.00},disable=1,proc=CheckProc_PDG,title="LINAC 21ºC - C4"
	CheckBox tab2_check05,value= 0
	CheckBox tab2_check06,pos={258.00,99.00},size={83.00,14.00},disable=1,proc=CheckProc_PDG,title="LINAC 45ºC"
	CheckBox tab2_check06,value= 0
	GroupBox tab2_group4,pos={244.00,490.00},size={141.00,134.00},disable=1,title="SI"
	CheckBox tab2_check3,pos={258.00,517.00},size={63.00,14.00},disable=1,proc=CheckProc_PDG,title="Magnets"
	CheckBox tab2_check3,value= 0
	CheckBox tab2_check04,pos={258.00,542.00},size={114.00,14.00},disable=1,proc=CheckProc_PDG,title="Vaccum Chamber"
	CheckBox tab2_check04,value= 0
	Button tab2_button1,pos={492.00,555.00},size={93.00,33.00},disable=1,proc=ButtonProc_AddPDG,title="Add Selection"
	CheckBox tab2_check08,pos={258.00,567.00},size={37.00,14.00},disable=1,proc=CheckProc_PDG,title="BCs"
	CheckBox tab2_check08,value= 0
	CheckBox tab2_check09,pos={36.00,508.00},size={139.00,14.00},disable=1,proc=CheckProc_PDG,title="Tunnel Temperature 2"
	CheckBox tab2_check09,value= 0
	CheckBox tab2_check10,pos={36.00,584.00},size={131.00,14.00},disable=1,proc=CheckProc_PDG,title="Amb. Temp. - Tunnel"
	CheckBox tab2_check10,value= 0
	CheckBox tab2_check03,pos={35.00,149.00},size={92.00,14.00},disable=1,proc=CheckProc_PDG,title="Racks Control"
	CheckBox tab2_check03,value= 0
	CheckBox tab2_check11,pos={35.00,175.00},size={65.00,14.00},disable=1,proc=CheckProc_PDG,title="Racks PS"
	CheckBox tab2_check11,value= 0
	CheckBox tab2_check12,pos={35.00,201.00},size={111.00,14.00},disable=1,proc=CheckProc_PDG,title="Racks Undulators"
	CheckBox tab2_check12,value= 0
	CheckBox tab2_check13,pos={35.00,228.00},size={74.00,14.00},disable=1,proc=CheckProc_PDG,title="Racks VAC"
	CheckBox tab2_check13,value= 0
	CheckBox tab2_check14,pos={35.00,254.00},size={80.00,14.00},disable=1,proc=CheckProc_PDG,title="Racks BPMs"
	CheckBox tab2_check14,value= 0
	GroupBox tab2_group5,pos={244.00,275.00},size={140.00,58.00},disable=1,title="Booster"
	CheckBox tab2_check15,pos={255.00,302.00},size={114.00,14.00},disable=1,proc=CheckProc_PDG,title="Vaccum Chamber"
	CheckBox tab2_check15,value= 0
	CheckBox tab2_check16,pos={36.00,610.00},size={162.00,14.00},disable=1,proc=CheckProc_PDG,title="Amb. Temp. - Conn. Room"
	CheckBox tab2_check16,value= 0
	CheckBox tab2_check17,pos={258.00,153.00},size={39.00,14.00},disable=1,proc=CheckProc_PDG,title="Skid"
	CheckBox tab2_check17,value= 0
	GroupBox tab2_group6,pos={437.00,41.00},size={146.00,66.00},disable=1,title="Floor"
	CheckBox tab2_check18,pos={450.00,73.00},size={91.00,14.00},disable=1,proc=CheckProc_PDG,title="Shallow Floor"
	CheckBox tab2_check18,value= 0
	CheckBox tab2_check19,pos={35.00,281.00},size={73.00,14.00},disable=1,proc=CheckProc_PDG,title="Racks NLK"
	CheckBox tab2_check19,value= 0
	CheckBox tab2_check20,pos={258.00,126.00},size={64.00,14.00},disable=1,proc=CheckProc_PDG,title="Solenoid"
	CheckBox tab2_check20,value= 0
	GroupBox tab2_group7,pos={245.00,194.00},size={128.00,56.00},disable=1,title="TB"
	CheckBox tab2_check21,pos={257.00,218.00},size={85.00,14.00},disable=1,proc=CheckProc_PDG,title="Septa TB-04"
	CheckBox tab2_check21,value= 0
	GroupBox tab2_group8,pos={244.00,350.00},size={140.00,131.00},disable=1,title="TS"
	CheckBox tab2_check22,pos={254.00,379.00},size={127.00,14.00},disable=1,proc=CheckProc_PDG,title="Septas TS-01/TS-04"
	CheckBox tab2_check22,value= 0
	CheckBox tab2_check23,pos={254.00,408.00},size={116.00,14.00},disable=1,proc=CheckProc_PDG,title="Body Septa TS-04"
	CheckBox tab2_check23,value= 0
	CheckBox tab2_check24,pos={254.00,431.00},size={122.00,28.00},disable=1,proc=CheckProc_PDG,title="  Vaccum Chamber\n  Septa TS-01"
	CheckBox tab2_check24,value= 0
	CheckBox tab2_check25,pos={258.00,592.00},size={64.00,14.00},disable=1,proc=CheckProc_PDG,title="NLK/DpK"
	CheckBox tab2_check25,value= 0
	Execute/Q/Z "SetWindow kwTopWin sizeLimit={33,48,inf,inf}" // sizeLimit requires Igor 7 or later
EndMacro

Function tabcontrol_PDG(tca) : TabControl
    STRUCT WMTabControlAction &tca
    string cont_list, cont_item
    variable ncont
    cont_list=controlnamelist("")
    nCont=itemsinlist(cont_list)
   
    switch(tca.eventCode)
        case 2:
            String ctrl_1 = ControlNameList("",";","tab1_*")
            String ctrl_2 = ControlNameList("",";","tab2_*")
            if(tca.tab==0)
                ModifyControlList ctrl_1 disable = 0
                ModifyControlList ctrl_2 disable = 1
            endif
            if(tca.tab==1)
                ModifyControlList ctrl_1 disable = 1
                ModifyControlList ctrl_2 disable = 0
            endif
    endswitch
    return 0
End


//função para atualizar valor dos controles de seleção de período da janela 'LOAD DATA'
Function PopMenuProc_Period(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa
	NVAR Period = root:GlobalVariables:gPeriod
	string DateHourSControlList = ControlNameList("LoadDataWindow",";","*Start*") //gera lista com nomes dos controles data/hora inicial
	string DateHourEControlList = ControlNameList("LoadDataWindow",";","*End*") //gera lista com nomes dos controles data/hora final
	
	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			switch (popNum)
				case 1:
					Period = 1 //Seta variável global com o valor correspondente
					UpdatePeriodControls(1) //Preenche controles data/hora inicial e final com o intervalo da última hora
					ModifyControlList DateHourSControlList disable=2 //desabilita edição dos controles data/hora inicial
					ModifyControlList DateHourEControlList disable=2 //desabilita edição dos controles data/hora final
					break
				case 2:
					Period = 2
					UpdatePeriodControls(3)
					ModifyControlList DateHourSControlList disable=2
					ModifyControlList DateHourEControlList disable=2
					break
				case 3:
					Period = 3
					UpdatePeriodControls(6)
					ModifyControlList DateHourSControlList disable=2
					ModifyControlList DateHourEControlList disable=2
					break
				case 4:
					Period = 4
					UpdatePeriodControls(24)
					ModifyControlList DateHourSControlList disable=2
					ModifyControlList DateHourEControlList disable=2
					break
				case 5:
					Period = 5
					FixedStartFixedEnd()
					ModifyControlList DateHourSControlList disable=0
					ModifyControlList DateHourEControlList disable=0
					SetVariable svStartDay activate
					break
				case 6:
					Period = 6
					FixedStartEndNow()
					ModifyControlList DateHourSControlList disable=0
					ModifyControlList DateHourEControlList disable=2
					break
			endswitch
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

//Seleciona metodo (aplica funcao na url caso necessario)
Function PopMenuProc_Method(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa
	NVAR/Z Method = root:GlobalVariables:gMethod
	NVAR/Z Interval = root:GlobalVariables:gInterval 
	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			strswitch (popStr)
				case "Normal":
					Method = 1
					PopUpMenu/Z puInterval disable=2, mode=1, value= #"\"Default Variable Interval;Interval: 10 Points;Interval: 30 Points;Interval: 60 Points;Interval: 300 Points;Interval: Custom\""
					Interval = 1
					SetVariable/Z svNth disable=1
					break
				case "Average":
					Method = 2
					PopUpMenu/Z puInterval disable=0, mode=1, value= #"\"Interval: 10 Points;Interval: 30 Points;Interval: 60 Points;Interval: 300 Points;Interval: Custom\""
					Interval = 2
					SetVariable/Z svNth disable=1
					PopUpMenu puInterval mode=1, disable=0
				break
				case "Minimum":
					Method = 3
					PopUpMenu/Z puInterval disable=0, mode=1, value= #"\"Interval: 10 Points;Interval: 30 Points;Interval: 60 Points;Interval: 300 Points;Interval: Custom\""
					Interval = 2
					SetVariable/Z svNth disable=1
					PopUpMenu puInterval mode=1, disable=0
					break
				case "Maximum":
					Method = 4
					PopUpMenu/Z puInterval disable=0, mode=1, value= #"\"Interval: 10 Points;Interval: 30 Points;Interval: 60 Points;Interval: 300 Points;Interval: Custom\""
					Interval = 2
					SetVariable/Z svNth disable=1
					PopUpMenu puInterval mode=1, disable=0
					break
				case "N-th":
					Method = 5
					PopUpMenu/Z puInterval disable=0, mode=1, value= #"\"Interval: 10 Points;Interval: 30 Points;Interval: 60 Points;Interval: 300 Points;Interval: Custom\""
					Interval = 2
					SetVariable/Z svNth disable=1
					PopUpMenu puInterval mode=1, disable=0
					break
			endswitch
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

//função para selecionar o intervalo para a variavel global
Function PopMenuProc_Interval(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa
	NVAR/Z Interval = root:GlobalVariables:gInterval
	NVAR/Z Method = root:GlobalVariables:gMethod
	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
				strswitch (popStr)
					case "Default Variable Interval":
						Interval = 0 //Padrão da Variável - nunca chamado
						SetVariable/Z svNth disable=1
					break
					case "Interval: 10 Points":
						Interval = 10 //10 Segundos
						SetVariable/Z svNth disable=1
					break
					case "Interval: 30 Points":
						Interval = 30 //30 Segundos
						SetVariable/Z svNth disable=1
					break
					case "Interval: 60 Points":
						Interval = 60 // 1 Minuto
						SetVariable/Z svNth disable=1
					break
					case "Interval: 300 Points":
						Interval = 300 // 5 Minutos
						SetVariable/Z svNth disable=1
					break
					case "Interval: Custom":
						Interval = 2.000 //Customizado
						switch (Method)
							case 1: //Normal - nunca ocorrerá
								SetVariable/Z svNth limits={1,inf,0}
								Interval = 1.000
								break
							case 2: //Médias
								SetVariable/Z svNth limits={2,inf,0}
								Interval = 2.000
								break
							case 3: //Mínimos
								SetVariable/Z svNth limits={2,inf,0}
								Interval = 2.000
								break
							case 4: //Máximos
								SetVariable/Z svNth limits={2,inf,0}
								Interval = 2.000
								break
							case 5: //N-Ésimos
								SetVariable/Z svNth limits={1,inf,0}
								Interval = 2.000
								break
						endswitch
						SetVariable/Z svNth disable=0, activate
					break
				endswitch
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

//função para botão de Add to Selection do painel principal. Esta função pesquisa do arquivo de PVs na pasta da procedimentos
//de usuário pela PV ou filtro adicionado no campo de pesquisa e se encontra, adiciona o conteúdo da pesquisa à lista para
//carregamento. Se não encontra, emite alerta na área de histórico do Igor.
Function ButtonProc_AddSelection(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	wave/T wGrepRes = root:VarList:wGrepRes
	wave/T wParameters2Search = root:VarList:wParameters2Search
	wave wParameterSel = root:VarList:wParameterSel
	SVAR/Z SearchField = root:GlobalVariables:gSearchField
	SVAR/Z PVsFile = root:GlobalVariables:gPVsfile
	string PVsFile_
	
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			//SearchFieldTemp = ReplaceString("%", SearchFieldTemp, ".+", 0, inf) //.+ procura um ou mais caracteres quaisquer
			//SearchFieldTemp = ReplaceString("*", SearchFieldTemp, ".", 0, inf) //. procura apenas um caracter qualquer
			//SearchFieldTemp = "^" + SearchFieldTemp //^ denota com quais caracteres começa a procura
			//SearchFieldTemp = SearchFieldTemp + "$" //$ denota com quais caracteres termina a procura
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
					InsertPoints (inf), 1, wParameterSel, wParameters2Search //^BO-01.+PS.+Current-Mon$
					wParameters2Search[inf] = SearchField //adiciono o valor digitado à wave de itens a serem carregados
					SearchField = "" //esvazio o campo
					SetVariable svSearchField activate //retorno o cursor de texto ao campo do Nome EPICS/Filtro de Pesquisa
					make/T/O/N=0 root:VarList:wGrepRes //esvazio a wave
				endif
				killstrings/A/Z //mato as strings geradas no Grep acima
				killvariables/A/Z //idem para variáveis
			endif
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End


Function ButtonProc_Cancel(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	NVAR/Z gAbort = root:GlobalVariables:gAbort
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			gAbort = 1
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_DeleteFromSelection(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	wave/T wParameters2Search = root:VarList:wParameters2Search
	wave wParameterSel = root:VarList:wParameterSel
	string Selection = ""
	int i

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			for (i=0;i<numpnts(wParameterSel);i+=1)
				if (wParameterSel[i] == 1)
					Selection = Selection + wParameters2Search[i] + ";"
				endif
			endfor
			
			for (i=0;i<ItemsInList(Selection);i+=1)
				FindValue/TEXT=stringfromlist(i,Selection) wParameters2Search
				//print wParameterSel
				DeletePoints V_Value, 1, wParameterSel, wParameters2Search
				KillVariables/Z V_Value
			endfor
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_OpenPDG(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			OpenPDG()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_AddPDG(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	wave/T wPDG = root:VarList:wPDG
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			AddPDGSel()
			ZeroSel()
			KillWindow PreDefinedGroups
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function CheckProc_PDG(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba
	switch( cba.eventCode )
		case 2: // mouse up
			PDGcheckboxSel(cba.ctrlName, cba.checked)
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End



Function ButtonProc_LoadSelection(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	wave/T wParameters2Search = root:VarList:wParameters2Search
	wave/T wGrepRes = root:VarList:wGrepRes
	SVAR/Z PVsFile = root:GlobalVariables:gPVsfile
	SVAR/Z gEmptyPV = root:GlovalVariables:gEmptyPV
	wave/T wPVs = root:VarList:wPVs
	SVAR/Z gZRbpms = root:GlovalVariables:gZRbpms
	NVAR/Z gAbort = root:GlobalVariables:gAbort
	NVAR/Z Method = root:GlobalVariables:gMethod
	wave/Z/T FrozenWaves = root:VarList:wFrozenWaves
	string pvname
	string pvname_TS
	string currentwave
	//wave/T wPVstemp
	int i = 0
	string changedname
	variable bar
	string PVsFile_
	
	switch( ba.eventCode )
		case 2: // mouse up
			try
				// click code here
				Button btnLoadSelection, disable=2
				ControlUpdate /W=LoadDataWindow btnLoadSelection
				Button btnCancel, disable=0
				ControlUpdate /W=LoadDataWindow btnCancel	
				Redimension/N=0 wPVs //zera wave wPVs	
				Redimension/N=0 FrozenWaves //zera wave wPVs
				DoUpdate /E=1 /W=LoadDataWindow /SPIN=1
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
					//wPVs = wPVstemp + wGrepRes //copio o conteúdo anterior mais o resultado GrepRes para
				endfor
				
				Sort /A=2 wPVs, wPVs
				
				print " "
				ValDisplay vdBar,value= _NUM:0
				ValDisplay vdBar win=LoadDataWindow, disable=0
				DoUpdate /W=LoadDataWindow /E=1 /SPIN=1
				//carrega dados do archiver
				for (i=0; i < numpnts(wPVs); i+=1) //para cada PV na wave
					//DoUpdate /W=LoadDataWindow /E=1 /SPIN=1
					if(V_flag == 2)
						ValDisplay vdBar win=LoadDataWindow, disable=1
						Button btnLoadSelection, disable=0
						ControlUpdate /W=LoadDataWindow btnLoadSelection
						Button btnCancel, disable=1
						ControlUpdate /W=LoadDataWindow btnCancel
						break
					endif
					currentwave = wPVs[i]
					if (LoadSelection(currentwave) == 0) //se função de carregar retornar ok
						//Verifica waves congeladas:
						if (isPVFrozen(currentwave) && stringmatch(currentwave,"!*-SP"))
							InsertPoints (inf), 1, FrozenWaves
							FrozenWaves[inf] = currentwave
						endif
						if(Method != 1)
							pvname = wPVs[i]
							pvname = ReplaceString(":", pvname, "_")
							pvname_TS = pvname + "_TS"
							pvname_TS = ReplaceString(":", pvname_TS, "_")
							DeletePoints 0, 1, $pvname
							DeletePoints 0, 1, $pvname_TS
						endif
						if(GetControlValueNbr("cbBPMs", "LoadDataWindow") == 1)
							if(stringmatch(wPVs[i],"*BPM*Mon"))
								changedname = ReplaceString(":", wPVs[i], "_")
								BpmShiftWave(0, changedname)
							endif
						endif
					endif
					bar = 100/numpnts(wPVs)
					ValDisplay vdBar win=LoadDataWindow, value= _NUM:bar+bar*i
					DoUpdate/W=LoadDataWindow
				endfor
				
				FixOnePointWaves(wPVs) //altera waves com um único ponto para terem dois pontos
				ValDisplay vdBar win=LoadDataWindow, disable=1
				Button btnLoadSelection, disable=0
				ControlUpdate /W=LoadDataWindow btnLoadSelection
				DoUpdate /W=LoadDataWindow /E=0 /SPIN=0
				Button btnCancel, disable=1
				ControlUpdate /W=LoadDataWindow btnCancel
				break
			catch
				if (V_AbortCode == -1)
					Button btnLoadSelection, disable=0
					ControlUpdate /W=LoadDataWindow btnLoadSelection
					break
				endif
			endtry
		case -1: // control being killed
			break
	endswitch
	gAbort = 0
End
