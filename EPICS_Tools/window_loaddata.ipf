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
	NewPanel /K=1 /W=(1394,218,1910,846) as "LOAD DATA"
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
	SetVariable svStartDay,pos={57.00,150.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svStartDay,help={"Day"},format="%02d"
	SetVariable svStartDay,limits={1,31,1},value= root:GlobalVariables:dds
	SetVariable svStartMonth,pos={114.00,150.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svStartMonth,help={"Month"},format="%02d"
	SetVariable svStartMonth,limits={1,12,1},value= root:GlobalVariables:mms
	SetVariable svStartYear,pos={171.00,150.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svStartYear,help={"Year"},format="%04d"
	SetVariable svStartYear,limits={2000,3000,1},value= root:GlobalVariables:yyyys
	SetVariable svStartHour,pos={267.00,150.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svStartHour,help={"Hour"},format="%02d"
	SetVariable svStartHour,limits={0,23,1},value= root:GlobalVariables:hs
	SetVariable svStartMin,pos={328.00,150.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svStartMin,help={"Minute"},format="%02d"
	SetVariable svStartMin,limits={0,59,1},value= root:GlobalVariables:ms
	SetVariable svStartSec,pos={392.00,150.00},size={58.00,18.00},disable=2,title=" "
	SetVariable svStartSec,help={"Second"},format="%.3f"
	SetVariable svStartSec,limits={0,59,1},value= root:GlobalVariables:ss
	SetVariable svEndDay,pos={57.00,246.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svEndDay,help={"Day"},format="%02d"
	SetVariable svEndDay,limits={1,31,1},value= root:GlobalVariables:dde
	SetVariable svEndMonth,pos={114.00,246.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svEndMonth,help={"Month"},format="%02d"
	SetVariable svEndMonth,limits={1,12,1},value= root:GlobalVariables:mme
	SetVariable svEndYear,pos={171.00,246.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svEndYear,help={"Year"},format="%04d"
	SetVariable svEndYear,limits={2000,3000,1},value= root:GlobalVariables:yyyye
	SetVariable svEndHour,pos={267.00,246.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svEndHour,help={"Hour"},format="%02d"
	SetVariable svEndHour,limits={0,23,1},value= root:GlobalVariables:he
	SetVariable svEndMin,pos={328.00,246.00},size={50.00,18.00},disable=2,title=" "
	SetVariable svEndMin,help={"Minute"},format="%02d"
	SetVariable svEndMin,limits={0,59,1},value= root:GlobalVariables:me
	SetVariable svEndSec,pos={392.00,246.00},size={58.00,18.00},disable=2,title=" "
	SetVariable svEndSec,help={"Second"},format="%.3f"
	SetVariable svEndSec,limits={0,59,1},value= root:GlobalVariables:se
	SetVariable svSearchField,pos={48.00,358.00},size={315.00,18.00},title=" "
	SetVariable svSearchField,help={"Hints:\r(.) = one character;\r(.+) = one or more characters;\r(.*) = zero or more characters;\r(^) = 'start with' character;\r($) = 'end with' character;\rEx: ^SI-02.+CCG-...:Pressure-Mon$\rEx: ^SI-....:DI-BPM.*:PosX-Mon$"}
	SetVariable svSearchField,value= root:GlobalVariables:gSearchField,live= 1
	GroupBox group0,pos={27.00,8.00},size={460.00,289.00},title="\\BPERIOD",fSize=20
	PopupMenu puPeriod,pos={45.00,35.00},size={141.00,19.00},bodyWidth=141,proc=PopMenuProc_Period
	PopupMenu puPeriod,mode=1,popvalue="Last Hour",value= #"\"Last Hour;Last 3 Hours;Last 6 Hours;Last 24 Hours;Fixed Start / Fixed End;Fixed Start / End Now\""
	PopupMenu puInterval,pos={45.00,61.00},size={247.00,19.00},bodyWidth=247,disable=2,proc=PopMenuProc_Interval
	PopupMenu puInterval,mode=1,popvalue="Default Variable Interval",value= #"\"Default Variable Interval;Interval: 10 Seconds;Interval: 30 Seconds;Interval: 1 Minute;Interval: 5 Minutes;Interval: Custom\""
	PopupMenu puMethod,pos={212.00,34.00},size={80.00,19.00},bodyWidth=80,proc=PopMenuProc_Method
	PopupMenu puMethod,mode=1,popvalue="Normal",value= #"\"Normal;Average;Minimum;Maximum;N-th\""
	SetVariable svNth,pos={245.00,89.00},size={47.00,18.00},disable=1,title=" "
	SetVariable svNth,format="%d"
	SetVariable svNth,limits={2,inf,0},value= root:GlobalVariables:gInterval
	GroupBox group1,pos={27.00,309.00},size={460.00,289.00},title="\\BPARAMETERS SELECTION"
	GroupBox group1,fSize=20
	Button btnLoadSelection,pos={379.00,418.00},size={90.00,29.00},proc=ButtonProc_LoadSelection,title="Load Selection"
	Button btnAddSelection,pos={379.00,358.00},size={56.00,19.00},proc=ButtonProc_AddSelection,title="Add"
	Button brnDel,pos={47.00,557.00},size={125.00,20.00},proc=ButtonProc_DeleteFromSelection,title="Delete from Selection"
	Button brnDel,help={"Hint:\rYou can 'Shift+Click' the lines above to delete multiple ones."}
	ListBox lbSelectionList,pos={48.00,394.00},size={315.00,146.00}
	ListBox lbSelectionList,listWave=root:VarList:wParameters2Search
	ListBox lbSelectionList,selWave=root:VarList:wParameterSel,mode= 4
	SetVariable svAdjustDH,pos={405.00,62.00},size={60.00,18.00},title=" "
	SetVariable svAdjustDH,value= root:GlobalVariables:gAdjustDH
	CheckBox cburl,pos={381.00,526.00},size={65.00,15.00},title="Print URL"
	CheckBox cburl,variable= root:GlobalVariables:gPrintURL
	SetVariable svAdjustTimezone,pos={405.00,35.00},size={60.00,18.00},title=" "
	SetVariable svAdjustTimezone,help={"Archiver solicitations must have\rfuse adjust for current timezone"}
	SetVariable svAdjustTimezone,format="%d"
	SetVariable svAdjustTimezone,limits={-11,14,1},value= root:GlobalVariables:gTimezone
	CheckBox cbBPMs,pos={381.00,454.00},size={87.00,15.00},title="BPMs to Zero"
	CheckBox cbBPMs,variable= root:GlobalVariables:gZRbpms
	CheckBox cbPS,pos={381.00,478.00},size={87.00,15.00},title="PS to Zero"
	CheckBox cbPS,variable= root:GlobalVariables:gZRps
	CheckBox cbTemp,pos={381.00,502.00},size={87.00,15.00},title="TEMP to Zero"
	CheckBox cbTemp,variable= root:GlobalVariables:gZRtemp
	Button btnMore,pos={440.00,358.00},size={28.00,19.00},proc=ButtonProc_OpenPDG,title="..."
	Button btnMore,help={"Hint:\rClick to select predefined groups to add to Selection Parameters."}
	ValDisplay vdBar,pos={27.00,604.00},size={459.00,17.00},disable=1
	ValDisplay vdBar,limits={0,100,0},barmisc={0,0},mode= 3,highColor= (0,65535,0)
	ValDisplay vdBar,value= _NUM:100
	Button btnCancel,pos={379.00,550.00},size={90.00,29.00},disable=1,title="Cancel"
	SetWindow kwTopWin,hook(spinner)=LoadDataWindowSpinHook
EndMacro

