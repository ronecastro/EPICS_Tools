#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Window DataAnalysis() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /W=(1402,46,1916,184) as "Data Analysis"
	ModifyPanel fixedSize=1
	SetDrawLayer UserBack
	SetDrawEnv fsize= 10
	DrawText 7,132,"version: 0.0.1"
	Button btn0,pos={12.00,14.00},size={90.00,40.00},proc=ButtonProc_LOADDATA,title="LOAD DATA"
	Button btn1,pos={131.00,69.00},size={90.00,40.00},proc=ButtonProc_WaveVsWave,title="Wave vs Wave\rGraph"
	Button btn2,pos={110.00,14.00},size={100.00,40.00},proc=ButtonProc_COMPAREDATA,title="COMPARE DATA"
	GroupBox g0,pos={6.00,7.00},size={505.00,54.00}
	Button btn3,pos={12.00,69.00},size={110.00,40.00},proc=ButtonProc_CompareWin,title="Compare Graph"
	Button btn4,pos={341.00,69.00},size={110.00,40.00},proc=ButtonProc_ListFrozenPVs,title="List Frozen PVs"
	Button btnOrbProfile,pos={230.00,69.00},size={102.00,40.00},proc=ButtonProc_GetOrbProfile,title="Orbit Profile"
	GroupBox g1,pos={6.00,62.00},size={505.00,54.00}
EndMacro

Function ButtonProc_LOADDATA(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			OpenLoadDataWindow()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_WaveVsWave(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			WaveVsWaveGraph()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_COMPAREDATA(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			OpenCompareDataWindow()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_CompareWin(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	wave/T wPVsCompWin = root:Compare:VarWaves:wPVsCompWin
	wave/T wPVsCompL = root:Compare:VarWaves:wPVsCompL
	wave/T wPVsCompR = root:Compare:VarWaves:wPVsCompR
	wave wPVsCompWinSel = root:Compare:VarWaves:wPVsCompWinSel
	wave wPVsCompLSel = root:Compare:VarWaves:wPVsCompLSel
	wave wPVsCompRSel = root:Compare:VarWaves:wPVsCompRSel
	wave wPeriodsWinSel = root:Compare:VarWaves:wPeriodsWinSel
	string aux

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			OpenCompareGraphWindow()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function ButtonProc_GetOrbProfile(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			getorbprofile()
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End

Function PopMenuProc_LeftTrace(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa

	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			
			string panel = "WaveVsWave"
			string control = "popup0"
			variable controlvalue = GetControlValueNbr(control, panel)
			wave/T wPVs = root:VarList:wPVs
			string controlvaluetxt
			string controlvaluetxt_TS
			string currenttraces
			string oldtrace
			string newtrace
	
			currenttraces = TraceNameList("",";",1)
			currenttraces = ReplaceString("'",currenttraces,"")
			oldtrace = stringfromlist(0,currenttraces)
	
			controlvaluetxt = ReplaceString(":",popStr,"_")//wPVs[controlvalue-1],"_")
			controlvaluetxt_TS = ReplaceString(":",popStr,"_") + "_TS"
	
			ReplaceWave trace=$oldtrace, $controlvaluetxt
			
			currenttraces = TraceNameList("",";",1)
			currenttraces = ReplaceString("'",currenttraces,"")
			newtrace = stringfromlist(0,currenttraces)
			
			ReplaceWave/X trace=$newtrace, $controlvaluetxt_TS
	
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function PopMenuProc_RightTrace(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa

	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			
			string panel = "WaveVsWave"
			string control = "popup1"
			variable controlvalue = GetControlValueNbr(control, panel)
			wave/T wPVs = root:VarList:wPVs
			string controlvaluetxt
			string controlvaluetxt_TS
			string currenttraces
			string oldtrace
			string newtrace
	
			currenttraces = TraceNameList("",";",1)
			currenttraces = ReplaceString("'",currenttraces,"")
			oldtrace = stringfromlist(1,currenttraces)
	
			controlvaluetxt = ReplaceString(":",popStr,"_")//wPVs[controlvalue-1],"_")
			controlvaluetxt_TS = ReplaceString(":",popStr,"_") + "_TS"
	
			ReplaceWave trace=$oldtrace, $controlvaluetxt
			
			currenttraces = TraceNameList("",";",1)
			currenttraces = ReplaceString("'",currenttraces,"")
			newtrace = stringfromlist(1,currenttraces)
			
			ReplaceWave/X trace=$newtrace, $controlvaluetxt_TS
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End
