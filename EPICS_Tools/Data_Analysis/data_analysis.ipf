#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

//Abre janela LoadData
Function OpenLoadDataWindow()
	DoWindow/HIDE=? LoadDataWindow
	if (V_Flag == 1 || V_Flag == 2)
		KillWindow/Z LoadDataWindow
	endif
	Execute/Q "LoadDataWindow()"
	ControlUpdate /A /W=LoadDataWindow
	KillVariables/Z V_Flag
End

Function/S Wave2TraceListL()
	wave/T/Z wPVs = root:VarList:wPVs
	SVAR/Z gLTfilter = root:GlobalVariables:gLTfilter
	string list = ""
	variable i

	for (i=0;numpnts(wPVs)>i;i+=1)
		list = list + wPVs[i] + ";"
	endfor
	list = ReplaceString(":", list, "_")
	list = GrepList(list, gLTfilter)
return list
End

Function/S Wave2TraceListR()
	wave/T/Z wPVs = root:VarList:wPVs
	SVAR/Z gRTfilter = root:GlobalVariables:gRTfilter
	string list = ""
	variable i

	for (i=0;numpnts(wPVs)>i;i+=1)
		list = list + wPVs[i] + ";"
	endfor
	list = ReplaceString(":", list, "_")
	list = GrepList(list, gRTfilter)
return list
End

//Abre janela de Wave vs wave Graph
Function WaveVsWaveGraph() 
	String SWave
	wave/T/Z wPVs = root:VarList:wPVs
	SVAR/Z gLTfilter = root:GlobalVariables:gLTfilter
	SVAR/Z gRTfilter = root:GlobalVariables:gRTfilter
	string lista

	SWave = ReplaceString(":", wPVs[0], "_")
	
	lista = WaveList("*", ",", "")
	if (ItemsInList(lista, ",") == 0)
		print "Não há Waves carregadas!"
	else
		//NewPanel /N=WaveVsWave /K=1 as "WaveVsWave"
		PauseUpdate; Silent 1		// building window...
		DoWindow/K WaveVsWave
		Display/N=WaveVsWave /W=(25.25,55.75,1020.25,558) $SWave vs $(SWave + "_TS")
		ModifyGraph/W=WaveVsWave axisEnab(left)={0,0.5}
		ModifyGraph rgb=(1,16019,65535)
		AppendToGraph/W=WaveVsWave /R $SWave vs $(SWave + "_TS")
		ModifyGraph/W=WaveVsWave axisEnab(right)={0.5,1}
		ModifyGraph tick=2
		ModifyGraph dateInfo(bottom)={0,0,0}
		Legend/C/N=text0/H={0,8,10}/A=MC/X=-44.00/Y=48.12
		Label bottom " "
		SetAxis/A/N=1 left
		SetAxis/A/N=1 bottom
		ControlBar 40
		PopupMenu popup0,pos={30,10},size={20,21},bodyWidth=300,title="Left Trace:  "
		PopupMenu popup0,mode=1,popvalue=SWave,value=Wave2TraceListL() //WaveList("!*_TS", ";", "")
		PopupMenu popup0 proc=PopMenuProc_LeftTrace
		SetVariable setvar0 title=" ",bodyWidth=180,pos={500,11},value=:GlobalVariables:gLTfilter
		SetVariable setvar0 help={"Hints:\r(.) = one character;\r(.+) = one or more characters;\r(.*) = zero or more characters;\r(^) = 'start with' character;\r($) = 'end with' character;\rEx: ^SI-02.+CCG-...:Pressure-Mon$\rEx: ^SI-....:DI-BPM.*:PosX-Mon$"}
		PopupMenu popup1,pos={920,10},size={20,21},bodyWidth=300,title="Right Trace:  "
		PopupMenu popup1,mode=1,popvalue=SWave,value=Wave2TraceListR() //WaveList("!*_TS", ";", "")
		PopupMenu popup1 proc=PopMenuProc_RightTrace
		SetVariable setvar1 title=" ",bodyWidth=180,pos={1080,11},value=:GlobalVariables:gRTfilter
		SetVariable setvar1 help={"Hints:\r(.) = one character;\r(.+) = one or more characters;\r(	.*) = zero or more characters;\r(^) = 'start with' character;\r($) = 'end with' character;\rEx: ^SI-02.+CCG-...:Pressure-Mon$\rEx: ^SI-....:DI-BPM.*:PosX-Mon$"}
		//Button btnplay title="►", proc=ButtonProc_PlayLiveMode
		//Button btnstop title="ǁ", proc=ButtonProc_PauseLiveMode
	endif		
End

//Abre janela CompareData
Function OpenCompareDataWindow()
	DoWindow/HIDE=? CompareDataWindow
	if (V_Flag == 1 || V_Flag == 2)
		KillWindow/Z CompareDataWindow
	endif
	Execute/Q "CompareDataWindow()"
	ControlUpdate /A /W=CompareDataWindow
	KillVariables/Z V_Flag
End

