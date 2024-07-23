#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.


Function OpenPDG_Comp()
	DoWindow/F PreDefinedGroups_Comp
	if (V_Flag == 1)
		KillWindow /Z PreDefinedGroups_Comp
	endif
	Execute/Q "PreDefinedGroups_Comp()"
	//GlobalReset()
	ControlUpdate /A /W=PreDefinedGroups_Comp
	KillVariables/Z V_flag, V_value, V_startParagraph, S_fileName, S_path, S_Value 
End

Function AddPDGSel_Comp()
	wave/T wPDG = root:Compare:VarWaves:wPDG
	SVAR/Z PVsFile = root:GlobalVariables:gPVsfile
	wave/T wGrepRes = root:Compare:VarWaves:wGrepRes
	wave/T wParameters2Search = root:Compare:VarWaves:wParameters2Search
	wave wParameterSel = root:Compare:VarWaves:wParameterSel
	string PDGlist = ""
	variable i
	
	Redimension/N=0 wGrepRes //esvazio a wave
	
	for(i=0;DimSize(wPDG,0)>i;i+=1)
		if(GrepString(wPDG[i][3],"1"))
			PDGlist = PDGlist + wPDG[i][4] //faço a lista PDGlist de filtros a serem carregados
		endif
	endfor
	//print "pdglist", PDGlist
	for(i=0;ItemsInList(PDGlist)>i;i+=1)
		Grep/A/E=StringFromList(i,PDGlist) PVsFile as wGrepRes //pesquiso filtros no arquivo de PVs
	endfor
	
	killstrings/Z V_flag, V_value, V_startParagraph, S_fileName, S_path, S_Value  //mato as strings geradas no Grep acima
	killvariables/Z V_flag, V_value, V_startParagraph, S_fileName, S_path, S_Value  //idem para variáveis
	
	if (WaveDims(wGrepRes) == 0) //verifico se há items que correspondem à pesquisa
		print "There's no item that corresponds to that EPICS Name / Search Filters!" //emito aviso
	else
		for(i=0;ItemsInList(PDGlist)>i;i+=1) //para cada item da lista
			InsertPoints (inf), 1, wParameterSel, wParameters2Search //insiro um ponto nas waves. ^BO-01.+PS.+Current-Mon$
			wParameters2Search[inf] = StringFromList(i,PDGlist) //adiciono o valor i da lista à wave de itens a serem carregados
		endfor
		//make/T/O/N=0 wGrepRes //esvazio a wave
	endif	
End

Function PDGcheckboxSel_Comp(controlname, controlvalue)
	string controlname
	variable controlvalue
	wave/T/Z wPDG = root:Compare:VarWaves:wPDG
	variable i
	
	for(i=0;DimSize(wPDG,0)>i;i+=1)
		if(stringmatch(wPDG[i][2],controlname))
			wPDG[i][3] = num2str(controlvalue)
		endif
	endfor
	
End

Function EditSelection()
	SVAR/Z SearchField = root:Compare:Variables:gSearchField
	wave/T wParameters2Search = root:Compare:VarWaves:wParameters2Search
	wave wParameterSel = root:Compare:VarWaves:wParameterSel
	string Selection = ""
	int i

	for (i=0;i<numpnts(wParameterSel);i+=1)
		if (wParameterSel[i] == 1)
			Selection = Selection + wParameters2Search[i] + ";"
		endif
	endfor
	for (i=0;i<ItemsInList(Selection);i+=1)
		FindValue/TEXT=stringfromlist(i,Selection) wParameters2Search
		SearchField = wParameters2Search[V_Value]
		//print wParameterSel
		DeletePoints V_Value, 1, wParameterSel, wParameters2Search
		KillVariables/Z V_Value
	endfor
End
	
Function DeleteFromSelection_Comp()
	wave/T wParameters2Search = root:Compare:VarWaves:wParameters2Search
	wave/T wParameters2SearchHelp = root:Compare:VarWaves:wParameters2SearchHelp
	wave wParameterSel = root:Compare:VarWaves:wParameterSel
	string Selection = ""
	int i
	
	for (i=0;i<numpnts(wParameterSel);i+=1)
		if (wParameterSel[i] == 1)
			Selection = Selection + wParameters2Search[i] + ";"
		endif
	endfor
	for (i=0;i<ItemsInList(Selection);i+=1)
		FindValue/TEXT=stringfromlist(i,Selection) wParameters2Search
		DeletePoints V_Value, 1, wParameterSel, wParameters2Search, wParameters2SearchHelp
		KillVariables/Z V_Value
	endfor
End

Function SetVarsDefault()
	NVAR gPeriod = root:Compare:Variables:gPeriod
	NVAR gMethod = root:Compare:Variables:gMethod
	NVAR gInterval = root:Compare:Variables:gInterval
	NVAR gTimezone = root:Compare:Variables:gTimezone
	NVAR gAdjustDH = root:Compare:Variables:gAdjustDH
	
	gPeriod = 1
	gMethod = 1
	gInterval = 1
	gTimezone = -3
	gAdjustDH = -10800
End

Function OpenAddPeriodWindow()
	string title = "ADD PERIOD"
	DoWindow/HIDE=? AddPeriodWindow
	if (V_Flag == 1 || V_Flag == 2)
		KillWindow/Z AddPeriodWindow
	endif
	Execute/Q "AddPeriodWindow()"
	ControlUpdate /A /W=AddPeriodWindow
	DoWIndow/T AddPeriodWindow, title
	KillVariables/Z V_Flag
End

Function UpdateAddPeriodVars(str)
	string str
	SVAR/Z gStartDate = root:Compare:Variables:gStartDate //referência à variável global gDataInicial
	SVAR/Z gEndDate = root:Compare:Variables:gEndDate //referência à variável global gDataFinal
	NVAR dds = root:Compare:Variables:dds //dia inicial
	NVAR mms = root:Compare:Variables:mms //mês inicial
	NVAR yyyys = root:Compare:Variables:yyyys //ano inicial
	NVAR hs = root:Compare:Variables:hs //hora inicial
	NVAR ms = root:Compare:Variables:ms //minuto inicial
	NVAR ss = root:Compare:Variables:ss //segundo inicial
	NVAR dde = root:Compare:Variables:dde //dia final
	NVAR mme = root:Compare:Variables:mme //mês final
	NVAR yyyye = root:Compare:Variables:yyyye //ano final
	NVAR he = root:Compare:Variables:he //hora final
	NVAR me = root:Compare:Variables:me //minuto final
	NVAR se = root:Compare:Variables:se //segundo final
	NVAR gPeriod = root:Compare:Variables:gPeriod
	NVAR gMethod = root:Compare:Variables:gMethod
	NVAR gInterval = root:Compare:Variables:gInterval
	NVAR gTimezone = root:Compare:Variables:gTimezone
	NVAR gAdjustDH = root:Compare:Variables:gAdjustDH
	wave/T wPeriods2Compare = root:Compare:VarWaves:wPeriods2Compare
	wave wPeriodSel = root:Compare:VarWaves:wPeriodSel
	
	sscanf str, "%d-%d-%d %d:%d:%f to %d-%d-%d %d:%d:%f            ,%d,%d,%d,%d,%d", yyyys, mms, dds, hs, ms, ss, yyyye, mme, dde, he, me, se, gPeriod, gMethod, gInterval, gTimezone, gAdjustDH
End

Function UpdateAddPeriodMenus()
	NVAR/Z gPeriod = root:Compare:Variables:gPeriod
	NVAR/Z gMethod = root:Compare:Variables:gMethod
	NVAR/Z gInterval = root:Compare:Variables:gInterval
	string list, item, str
	variable match, i
	
	PopupMenu puPeriod win=AddPeriodWindow, mode=gPeriod
	PopupMenu puMethod win=AddPeriodWindow, mode=gMethod
	if (gPeriod == 1 || gPeriod == 2 || gPeriod == 3 || gPeriod == 4)
		SetVariable svStartDay win=AddPeriodWindow, disable=2
		SetVariable svStartMonth win=AddPeriodWindow, disable=2
		SetVariable svStartYear win=AddPeriodWindow, disable=2
		SetVariable svStartHour win=AddPeriodWindow, disable=2
		SetVariable svStartMin win=AddPeriodWindow, disable=2
		SetVariable svStartSec win=AddPeriodWindow, disable=2
		SetVariable svEndDay win=AddPeriodWindow, disable=2
		SetVariable svEndMonth win=AddPeriodWindow, disable=2
		SetVariable svEndYear win=AddPeriodWindow, disable=2
		SetVariable svEndHour win=AddPeriodWindow, disable=2
		SetVariable svEndMin win=AddPeriodWindow, disable=2
		SetVariable svEndSec win=AddPeriodWindow, disable=2
	endif
	if (gPeriod == 5)
		SetVariable svStartDay win=AddPeriodWindow, disable=0
		SetVariable svStartMonth win=AddPeriodWindow, disable=0
		SetVariable svStartYear win=AddPeriodWindow, disable=0
		SetVariable svStartHour win=AddPeriodWindow, disable=0
		SetVariable svStartMin win=AddPeriodWindow, disable=0
		SetVariable svStartSec win=AddPeriodWindow, disable=0
		SetVariable svEndDay win=AddPeriodWindow, disable=0
		SetVariable svEndMonth win=AddPeriodWindow, disable=0
		SetVariable svEndYear win=AddPeriodWindow, disable=0
		SetVariable svEndHour win=AddPeriodWindow, disable=0
		SetVariable svEndMin win=AddPeriodWindow, disable=0
		SetVariable svEndSec win=AddPeriodWindow, disable=0
	endif
	if (gPeriod == 6)
		SetVariable svStartDay win=AddPeriodWindow, disable=0
		SetVariable svStartMonth win=AddPeriodWindow, disable=0
		SetVariable svStartYear win=AddPeriodWindow, disable=0
		SetVariable svStartHour win=AddPeriodWindow, disable=0
		SetVariable svStartMin win=AddPeriodWindow, disable=0
		SetVariable svStartSec win=AddPeriodWindow, disable=0
		SetVariable svEndDay win=AddPeriodWindow, disable=2
		SetVariable svEndMonth win=AddPeriodWindow, disable=2
		SetVariable svEndYear win=AddPeriodWindow, disable=2
		SetVariable svEndHour win=AddPeriodWindow, disable=2
		SetVariable svEndMin win=AddPeriodWindow, disable=2
		SetVariable svEndSec win=AddPeriodWindow, disable=2
	endif	
	if (gMethod != 1)
		PopupMenu puInterval win=AddPeriodWindow, disable=0
		PopUpMenu/Z puInterval disable=0, value= #"\"Interval: 10 Seconds;Interval: 30 Seconds;Interval: 60 Seconds;Interval: 300 Seconds;Interval: Custom\""
		list = "Interval: 10 Seconds;Interval: 30 Seconds;Interval: 60 Seconds;Interval: 300 Seconds;Interval: Custom"
		for (i=0; i<ItemsinList(list);i+=1)
			item = StringFromList(i, list)
			str = ("* " + num2str(gInterval) + " *")
			match = StringMatch(item, str)
			if (match  == 1)
				PopUpMenu/Z puInterval disable=0, mode=i+1
				DoUpdate /W=AddPeriodWindow
				break
			else
				str = "Interval: Custom"
				match = StringMatch(item, str)
				if (match == 1)
					PopUpMenu/Z puInterval win=AddPeriodWindow, disable=0, mode=5 //svNth habilitada
					SetVariable/Z svNth win=AddPeriodWindow, disable=0
					PopUpMenu puInterval win=AddPeriodWindow, mode=5, disable=0
					PopupMenu puInterval bodyWidth=175, win=AddPeriodWindow
					ControlUpdate /W=AddPeriodWindow puInterval
					PopupMenu puInterval pos={34,62}, win=AddPeriodWindow
					DoUpdate /W=AddPeriodWindow
				endif
			endif
		endfor
	endif
End

Function AddPeriod()
	SVAR/Z gStartDate = root:Compare:Variables:gStartDate //referência à variável global gDataInicial
	SVAR/Z gEndDate = root:Compare:Variables:gEndDate //referência à variável global gDataFinal
	NVAR dds = root:Compare:Variables:dds //dia inicial
	NVAR mms = root:Compare:Variables:mms //mês inicial
	NVAR yyyys = root:Compare:Variables:yyyys //ano inicial
	NVAR hs = root:Compare:Variables:hs //hora inicial
	NVAR ms = root:Compare:Variables:ms //minuto inicial
	NVAR ss = root:Compare:Variables:ss //segundo inicial
	NVAR dde = root:Compare:Variables:dde //dia final
	NVAR mme = root:Compare:Variables:mme //mês final
	NVAR yyyye = root:Compare:Variables:yyyye //ano final
	NVAR he = root:Compare:Variables:he //hora final
	NVAR me = root:Compare:Variables:me //minuto final
	NVAR se = root:Compare:Variables:se //segundo final
	NVAR gPeriod = root:Compare:Variables:gPeriod
	NVAR gMethod = root:Compare:Variables:gMethod
	NVAR gInterval = root:Compare:Variables:gInterval
	NVAR gTimezone = root:Compare:Variables:gTimezone
	NVAR gAdjustDH = root:Compare:Variables:gAdjustDH
	NVAR gMode = root:Compare:Variables:gMode //Modo de Adição = 0, mode de Edição = 1
	wave/T wPeriods2Compare = root:Compare:VarWaves:wPeriods2Compare
	wave wPeriodSel = root:Compare:VarWaves:wPeriodSel
	string Period2Show
	string Period
	string StartDate
	string EndDate
	variable i
	string title = "ADD DATA"
	
	//Formação da string "gDataInicial" com data/hora inicial
	if (ss < 10)
		sprintf gStartDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:0%.3f", yyyys, mms, dds, hs, ms, ss
		sprintf StartDate ,"%.2d-%.2d-%.2d %.2d:%.2d:0%.3f", yyyys, mms, dds, hs, ms, ss
	else
		sprintf gStartDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:%.3f", yyyys, mms, dds, hs, ms, ss
		sprintf StartDate ,"%.2d-%.2d-%.2d %.2d:%.2d:%.3f", yyyys, mms, dds, hs, ms, ss
	endif
	
	//Formação da string "gDataFinal" com data/hora final
	if (se < 10)
		sprintf gEndDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:0%.3f", yyyye, mme, dde, he, me, se
		sprintf EndDate ,"%.2d-%.2d-%.2d %.2d:%.2d:0%.3f", yyyye, mme, dde, he, me, se
	else
		sprintf gEndDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:%.3f", yyyye, mme, dde, he, me, se
		sprintf EndDate ,"%.2d-%.2d-%.2d %.2d:%.2d:%.3f", yyyye, mme, dde, he, me, se
	endif

	Period = StartDate + " to " + EndDate + "            ," + num2str(gPeriod) + "," + num2str(gMethod) + "," + num2str(gInterval) + "," + num2str(gTimezone) + "," + num2str(gAdjustDH)
	//print "period", Period
	if (gMode==0)
		InsertPoints (inf), 1, wPeriodSel, wPeriods2Compare //insiro um ponto nas waves. ^BO-01.+PS.+Current-Mon$
		wPeriods2Compare[inf] = Period //adiciono o valor à wave de itens a serem carregados
	else
		for (i=0;i<numpnts(wPeriodSel);i+=1)
			if (wPeriodSel[i] == 1)
				wPeriods2Compare[i] = Period
				DoWIndow/T AddPeriodWindow, title
				break
			endif
		endfor
	endif
End

Function EditPeriod()
	SVAR/Z SearchField = root:Compare:Variables:gSearchField
	wave/T wPeriods2Compare = root:Compare:VarWaves:wPeriods2Compare
	wave wPeriodSel = root:Compare:VarWaves:wPeriodSel
	string Selection = ""
	string title = "EDIT PERIOD"
	int i
	
	for (i=0;i<numpnts(wPeriodSel);i+=1)
		if (wPeriodSel[i] == 1)
			Selection = Selection + wPeriods2Compare[i] + ";"
		endif
	endfor
	
	if (itemsinlist(Selection) == 1)
		for (i=0;i<ItemsInList(Selection);i+=1)
			FindValue/TEXT=stringfromlist(i,Selection) wPeriods2Compare
			UpdateAddPeriodVars(wPeriods2Compare[V_Value])
			OpenAddPeriodWindow()
			DoUpdate/W=AddDataWindow
			DoWIndow/T AddPeriodWindow, title
			UpdateAddPeriodMenus()
			KillVariables/Z V_Value
		endfor
	else
		print "select only one line!"
	endif
End

Function CancelAddPeriodWindow()
	DoWindow/HIDE=? AddPeriodWindow
	if (V_Flag == 1 || V_Flag == 2)
		KillWindow/Z AddPeriodWindow
	endif
	KillVariables/Z V_Flag
End

Function/S FillGlobalDateHourVars_Comp(datehour, mode)
	string datehour //data/hora formato padrão <aaaa-mm-ddThh:mm:ss.sss>
	int mode //0 = inicial / 1 = final
	SVAR/Z gStartDate = root:Compare:Variables:gStartDate //referência à variável global gDataInicial
	SVAR/Z gEndDate = root:Compare:Variables:gEndDate //referência à variável global gDataFinal
	NVAR dds = root:Compare:Variables:dds //dia inicial
	NVAR mms = root:Compare:Variables:mms //mês inicial
	NVAR yyyys = root:Compare:Variables:yyyys //ano inicial
	NVAR hs = root:Compare:Variables:hs //hora inicial
	NVAR ms = root:Compare:Variables:ms //minuto inicial
	NVAR ss = root:Compare:Variables:ss //segundo inicial
	NVAR dde = root:Compare:Variables:dde //dia final
	NVAR mme = root:Compare:Variables:mme //mês final
	NVAR yyyye = root:Compare:Variables:yyyye //ano final
	NVAR he = root:Compare:Variables:he //hora final
	NVAR me = root:Compare:Variables:me //minuto final
	NVAR se = root:Compare:Variables:se //segundo final
	
	if (mode == 0) //preenche as variáveis relativas ao início
		sscanf datehour , "%4d-%2d-%2dT%2d:%2d:%f", yyyys, mms, dds, hs, ms, ss
	endif
	if (mode == 1) //preenche as variáveis relativas ao fim
		sscanf datehour , "%4d-%2d-%2dT%2d:%2d:%f", yyyye, mme, dde, he, me, se
	endif
End

Function UpdatePeriodControls_Comp(interval)
	int interval //in hours
	string datehours, datehoure
	datehours = SetUpStringFromMacDate(datetime - (interval*3600))
	datehoure = SetUpStringFromMacDate(datetime)
	FillGlobalDateHourVars_Comp(datehours, 0)
	FillGlobalDateHourVars_Comp(datehoure, 1)
End

Function FixedStartEndNow_Comp()
	string datehour
	datehour = SetUpStringFromMacDate(datetime)
	FillGlobalDateHourVars_Comp(datehour, 1)
End

Function UpdateIntervalMenu(num)
	variable num
	NVAR/Z Method = root:Compare:Variables:gMethod
	NVAR/Z Interval = root:Compare:Variables:gInterval
	switch (num)
				case 1: //Normal
					Method = 1
					PopUpMenu/Z puInterval disable=2, mode=1, value= #"\"Default Variable Interval;Interval: 10 Seconds;Interval: 30 Seconds;Interval: 60 Seconds;Interval: 300 Seconds;Interval: Custom\""
					Interval = 1
					SetVariable/Z svNth win=AddPeriodWindow, disable=1
					PopupMenu puInterval bodyWidth=227, win=AddPeriodWindow
					ControlUpdate /W=AddPeriodWindow puInterval
					PopupMenu puInterval pos={34,62}, win=AddPeriodWindow
					break
				case 2: //Average
					Method = 2
					PopUpMenu/Z puInterval disable=0, mode=1, value= #"\"Interval: 10 Seconds;Interval: 30 Seconds;Interval: 60 Seconds;Interval: 300 Seconds;Interval: Custom\""
					Interval = 10
					SetVariable/Z svNth win=AddPeriodWindow, disable=1
					PopUpMenu puInterval mode=1, disable=0
					PopupMenu puInterval bodyWidth=227, win=AddPeriodWindow
					ControlUpdate /W=AddPeriodWindow puInterval
					PopupMenu puInterval pos={34,62}, win=AddPeriodWindow
				break
				case 3: //Minimum
					Method = 3
					PopUpMenu/Z puInterval disable=0, mode=1, value= #"\"Interval: 10 Seconds;Interval: 30 Seconds;Interval: 60 Seconds;Interval: 300 Seconds;Interval: Custom\""
					Interval = 10
					SetVariable/Z svNth win=AddPeriodWindow, disable=1
					PopUpMenu puInterval mode=1, disable=0
					PopupMenu puInterval bodyWidth=227, win=AddPeriodWindow
					ControlUpdate /W=AddPeriodWindow puInterval
					PopupMenu puInterval pos={34,62}, win=AddPeriodWindow
					break
				case 4: //Maximum
					Method = 4
					PopUpMenu/Z puInterval disable=0, mode=1, value= #"\"Interval: 10 Seconds;Interval: 30 Seconds;Interval: 60 Seconds;Interval: 300 Seconds;Interval: Custom\""
					Interval = 10
					SetVariable/Z svNth win=AddPeriodWindow, disable=1
					PopUpMenu puInterval mode=1, disable=0
					PopupMenu puInterval bodyWidth=227, win=AddPeriodWindow
					ControlUpdate /W=AddPeriodWindow puInterval
					PopupMenu puInterval pos={34,62}, win=AddPeriodWindow
					break
				case 5: //N-th
					Method = 5
					PopUpMenu/Z puInterval disable=0, mode=1, value= #"\"Interval: 10 Seconds;Interval: 30 Seconds;Interval: 60 Seconds;Interval: 300 Seconds;Interval: Custom\""
					Interval = 10
					SetVariable/Z svNth win=AddPeriodWindow, disable=1
					PopUpMenu puInterval mode=1, disable=0
					PopupMenu puInterval bodyWidth=227, win=AddPeriodWindow
					ControlUpdate /W=AddPeriodWindow puInterval
					PopupMenu puInterval pos={34,62}, win=AddPeriodWindow
					break
			endswitch
End

Function UpdateInterval_Comp(str)
	string str
	NVAR/Z Interval = root:Compare:Variables:gInterval
	NVAR/Z Method = root:Compare:Variables:gMethod
	strswitch (str)
		case "Default Variable Interval":
			Interval = 1 //Padrão da Variável - nunca chamado
			//print "Default Variable Interval"
			SetVariable/Z svNth win=AddPeriodWindow, disable=1
			PopupMenu puInterval bodyWidth=227, win=AddPeriodWindow
			ControlUpdate /W=AddPeriodWindow puInterval
			PopupMenu puInterval pos={34,62}, win=AddPeriodWindow
		break
		case "Interval: 10 Seconds":
			Interval = 10
			//print "Interval: 10 Seconds"
			SetVariable/Z svNth win=AddPeriodWindow, disable=1
			PopupMenu puInterval bodyWidth=227, win=AddPeriodWindow
			ControlUpdate /W=AddPeriodWindow puInterval
			PopupMenu puInterval pos={34,62}, win=AddPeriodWindow
		break
		case "Interval: 30 Seconds":
			Interval = 30
			//print "Interval: 30 Seconds"
			SetVariable/Z svNth win=AddPeriodWindow, disable=1
			PopupMenu puInterval bodyWidth=227, win=AddPeriodWindow
			ControlUpdate /W=AddPeriodWindow puInterval
			PopupMenu puInterval pos={34,62}, win=AddPeriodWindow
		break
		case "Interval: 60 Seconds":
			Interval = 60
			//print "Interval: 1 Minute"
			SetVariable/Z svNth win=AddPeriodWindow, disable=1
			PopupMenu puInterval bodyWidth=227, win=AddPeriodWindow
			ControlUpdate /W=AddPeriodWindow puInterval
			PopupMenu puInterval pos={34,62}, win=AddPeriodWindow
		break
		case "Interval: 300 Seconds":
			Interval = 300
			//print "Interval: 5 Minutes"
			SetVariable/Z svNth win=AddPeriodWindow, disable=1
			PopupMenu puInterval bodyWidth=227, win=AddPeriodWindow
			ControlUpdate /W=AddPeriodWindow puInterval
			PopupMenu puInterval pos={34,62}, win=AddPeriodWindow
		break
		case "Interval: Custom":
			Interval = 2.000 //Customizado
			PopupMenu puInterval bodyWidth=160, win=AddPeriodWindow
			ControlUpdate /W=AddPeriodWindow puInterval
			PopupMenu puInterval pos={34,62}, win=AddPeriodWindow
			switch (Method)
				case 1: //Normal - nunca ocorrerá
					SetVariable/Z svNth win=AddPeriodWindow, limits={1,inf,0}
					Interval = 1
					break
				case 2: //Médias
					SetVariable/Z svNth win=AddPeriodWindow, limits={1,inf,0}
					Interval = 1
					break
				case 3: //Mínimos
					SetVariable/Z svNth win=AddPeriodWindow, limits={1,inf,0}
					Interval = 1
					break
				case 4: //Máximos
					SetVariable/Z svNth win=AddPeriodWindow, limits={1,inf,0}
					Interval = 1
					break
				case 5: //N-Ésimos
					SetVariable/Z svNth win=AddPeriodWindow, limits={1,inf,0}
					Interval = 1
					break
			endswitch
			SetVariable/Z svNth win=AddPeriodWindow, disable=0, activate
		break
	endswitch
End

Function LoadCompare(pvname, centry)
	string pvname
	string centry
	SVAR/Z gEmptyPV = root:Compare:Variables:gEmptyPV
	SVAR/Z gParseFail = root:Compare:Variables:gParseFail
	NVAR/Z gECode = root:Compare:Variables:gECode
	string url
	int result = 0
	string pvname_TS
	NVAR dds = root:Compare:Variables:dds //dia inicial
	NVAR mms = root:Compare:Variables:mms //mês inicial
	NVAR yyyys = root:Compare:Variables:yyyys //ano inicial
	NVAR hs = root:Compare:Variables:hs //hora inicial
	NVAR ms = root:Compare:Variables:ms //minuto inicial
	NVAR ss = root:Compare:Variables:ss //segundo inicial
	NVAR dde = root:Compare:Variables:dde //dia final
	NVAR mme = root:Compare:Variables:mme //mês final
	NVAR yyyye = root:Compare:Variables:yyyye //ano final
	NVAR he = root:Compare:Variables:he //hora final
	NVAR me = root:Compare:Variables:me //minuto final
	NVAR se = root:Compare:Variables:se //segundo final
	SVAR/Z gStartDate = root:Compare:Variables:gStartDate //referência à variável global gDataInicial
	SVAR/Z gEndDate = root:Compare:Variables:gEndDate //referência à variável global gDataFinal
	NVAR gPeriod = root:Compare:Variables:gPeriod
	NVAR gMethod = root:Compare:Variables:gMethod
	NVAR gInterval = root:Compare:Variables:gInterval
	NVAR gTimezone = root:Compare:Variables:gTimezone
	NVAR gAdjustDH = root:Compare:Variables:gAdjustDH
	
	gEmptyPV = ""
	sscanf centry, "%d-%d-%d %d:%d:%f to %d-%d-%d %d:%d:%f            ,%d,%d,%d,%d,%d", yyyys, mms, dds, hs, ms, ss, yyyye, mme, dde, he, me, se, gPeriod, gMethod, gInterval, gTimezone, gAdjustDH
	
	if (ss < 10)
		sprintf gStartDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:0%.3f", yyyys, mms, dds, hs, ms, ss
	else
		sprintf gStartDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:%.3f", yyyys, mms, dds, hs, ms, ss
	endif
	
	if (se < 10)
		sprintf gEndDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:0%.3f", yyyye, mme, dde, he, me, se
	else
		sprintf gEndDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:%.3f", yyyye, mme, dde, he, me, se	
	endif

	
	//SetDHVars() //função preenche variaveis globais de data/hora inicio/fim
	url = BuildArchiverURL_Comp(pvname, gStartDate, gEndDate)
	
	result = archiver2igor(url, pvname)

	if (strlen(gEmptyPV) == 0 && strlen(gParseFail) == 0 && gECode == 0)
		result = 0
	endif
					
	pvname_TS = ReplaceString(":", pvname, "_") + "_TS" //gera nome da timestamp baseada no nome da PV
	wave aux_TS = $pvname_TS
	aux_TS += gAdjustDH //ajuste horário da wave de timestamp de acordo com controle correspondente
	
	gECode = 0
	return result
End

Function FixOnePointWaves_Comp(pvswave) //recebe lista de nomes Mnemonicos para verificar um a um se possuem um único ponto na wave correspondente
	wave/T pvswave
	string namewave = ""
	string namewave_TS = ""
	SVAR/Z gStartDate = root:Compare:Variables:gStartDate
	SVAR/Z gEndDate = root:Compare:Variables:gEndDate
	NVAR/Z gAdjustDH = root:Compare:Variables:gAdjustDH
	NVAR/Z gTimezone = root:Compare:Variables:gTimezone
	int i = 0
	variable y, m, d, hh, mm, ss
	int macdt
	
	for(i=0; i < numpnts(pvswave); i+=1) // para cada item na lista recebida
		namewave = pvswave[i]
		namewave = ReplaceString(":", namewave, "_")
		wave aux = $namewave
		namewave_TS = pvswave[i] + "_TS"
		namewave_TS = ReplaceString(":", namewave_TS, "_")
		wave aux_TS = $namewave_TS
		if (numpnts($namewave) == 1) //se a wave contiver um único ponto
			InsertPoints (inf), 1, aux //Adiciona um ponto na wave de valores
			InsertPoints (inf), 1, aux_TS //adiciona um ponto na wave de timestamp
			aux[1] = aux[0] //na wave de valores, primeiro ponto tem valor igual ao segundo ponto
			sscanf gStartDate, "%4d%*[-]%2d%*[-]%2d%*[T]%2d%*[:]%2d%*[:]%2d", y, m, d, hh, mm, ss //scaneia data inicial dos controles da janela CARREGA DADOS
			macdt = date2secs(y, m, d) + hh*3600 + mm*60 + ss
			aux_TS[0] = macdt //primeiro ponto da wave de timestamp recebe valor de data inicial
			sscanf gEndDate, "%4d%*[-]%2d%*[-]%2d%*[T]%2d%*[:]%2d%*[:]%2d", y, m, d, hh, mm, ss
			macdt = date2secs(y, m, d) + hh*3600 + mm*60 + ss
			aux_TS[1] += macdt //segundo ponto da wave de timestamp recebe valor de data final
			//aux_TS += gAdjustDH
		endif	
	endfor
End

Function/S ApplyFunction_Comp(EPICSname)
	string EPICSname
	NVAR/Z Method = root:Compare:Variables:gMethod
	NVAR/Z Interval = root:Compare:Variables:gInterval
	string EPICSnameRes
	switch (Method)
		case 1:
			EPICSnameRes = EPICSname
			break
		case 2:
			EPICSnameRes = "mean_" + num2str(Interval) + "(" + EPICSname + ")"
			//print "case 2 mean"
			break
		case 3:
			EPICSnameRes = "min_" + num2str(Interval) + "(" + EPICSname + ")"
			//print "case 3 min"
			break
		case 4:
			EPICSnameRes = "max_" + num2str(Interval) + "(" + EPICSname + ")"
			//print "case 4 max"
			break
		case 5:
			EPICSnameRes = "nth_" + num2str(Interval) + "(" + EPICSname + ")"
			//print "case 5 nth"
			break
		default:
			EPICSnameRes = EPICSname
			break
	endswitch
	return EPICSnameRes
End

Function/S BuildArchiverURL_Comp(pvname, startdata, enddata)
	string pvname
	string startdata
	string enddata
	NVAR/Z Timezone = root:Compare:Variables:gTimezone
	string result
	string aux1 = "http://10.0.38.42/retrieval/data/getData.json?pv="
	string aux2 = "&from="
	string aux3 = "&to="
	string Z = "Z"
	string panel = "CompareDataWindow"
	string cbPrintURL = "cburl"
	string svTimeZone = "svAdjustTimezone"
	variable value
	if (Timezone != 0)
		if (Timezone <= -10)
			Z = "-" + num2str(abs(round(Timezone))) + ":" + "00"
		elseif (-9 <= Timezone && -1 >= Timezone)
			Z = "-0" + num2str(abs(round(Timezone))) + ":" + "00"
		elseif (0 < Timezone && 9 >= Timezone)
			Z = "+0" + num2str(round(Timezone)) + ":" + "00"
		elseif (10 <= Timezone)
			Z = "+" + num2str(round(Timezone)) + ":" + "00"
		endif
	endif
	result = aux1 + ApplyFunction_Comp(pvname) + aux2 + startdata + Z + aux3 + enddata + Z
	if (GetControlValueNbr(cbPrintURL, panel) == 1)
		print result
	endif
	return result	
End

Function/T IdAxisWave(axis)
	string axis
	string wname
	string aux
	aux = AxisInfo("", axis)
	aux = StringFromList(2, aux)
	wname = aux[6, inf]
	return wname
End

Function/T SimetrizaEixos(axis, Panels4Simetrization) //simetriza o eixo escolhido
	string axis
	string Panels4Simetrization
	NVAR lowvalueL = root:Compare:Variables:lowvalueL
	NVAR highvalueL = root:Compare:Variables:highvalueL
	NVAR lowvalueR = root:Compare:Variables:lowvalueR
	NVAR highvalueR = root:Compare:Variables:highvalueR
	variable lowvalue, highvalue, i
	string allwindows, CompareWindows
	
	for (i=0;i<itemsinList(Panels4Simetrization);i+=1)
		if (stringmatch(axis, "left"))
			SetAxis/W=$(stringfromlist(i,Panels4Simetrization)) left lowvalueL, highvalueL
		endif
		if (stringmatch(axis, "right"))
			SetAxis/W=$(stringfromlist(i,Panels4Simetrization)) right lowvalueR, highvalueR
		endif
	endfor
End

Function FindPeaks(index, wname, axis)
	variable index
	wave wname
	string axis
	NVAR lowvalueL = root:Compare:Variables:lowvalueL
	NVAR highvalueL = root:Compare:Variables:highvalueL
	NVAR lowvalueR = root:Compare:Variables:lowvalueR
	NVAR highvalueR = root:Compare:Variables:highvalueR
	variable peak, valley
	variable i
	variable StartP, EndP
	
	if (stringmatch(axis, "left"))
		SetAxis/A=2 left
		DoUpdate
		GetAxis/Q Left
		if (index==0)
			highvalueL = V_max
		else
			if (highvalueL < V_max)
				highvalueL = V_max
			endif
		endif
		if (index==0)
			lowvalueL = V_min
		else
			if (lowvalueL > V_min)
				lowvalueL = V_min
			endif
		endif
	endif
	if (stringmatch(axis, "right"))
		SetAxis/A=2 right
		DoUpdate
		GetAxis/Q Right
		if (index==0)
			highvalueR = V_max
		else
			if (highvalueR < V_max)
				highvalueR = V_max
			endif
		endif
		if (index==0)
			lowvalueR = V_min
		else
			if (lowvalueR > V_min)
				lowvalueR = V_min
			endif
		endif
		//print "left valley", valley
	endif
End

Function IsInstaceOne(trace, axis) //use with window graph focus active
	string trace
	string axis
	string aux
	aux = (StringFromList(1, TraceInfo("", trace, 1))) //eixo onde a instancia 1 do trace está
	if (stringmatch(StringFromList(0, aux), "*" + axis + "*")) //se a instancia 1 está no eixo pedido
		return 1
	else //se não achou
		return 0
	endif
	
End

Function CompareGraphWin(wnumber)
	variable wnumber
	string wname = "CompareGraph" + num2str(wnumber)
	wave/T wPVsCompWin = root:Compare:VarWaves:wPVsCompWin
	wave/T wPVsCompWinSel = root:Compare:VarWaves:wPVsCompWin
	PauseUpdate; Silent 1		// building window...
	DoWindow $wname
	Display/N=$wname /W=(15.75+wnumber*10,227+wnumber*10,339.75+wnumber*10,623.75+wnumber*10) //Left vs BottomLeft
	Legend/C/N=text0/J/X=0.00/Y=-40.00/H={0,8,10}/A=MC
End

Function OpenCompareWindow()
	DoWindow/HIDE=? window_compare
	if (V_Flag == 1 || V_Flag == 2)
		KillWindow/Z window_compare
	endif
	Execute/Q "window_compare()"
	ControlUpdate /A /W=window_compare
	KillVariables/Z V_Flag
End

Function OpenCompareGraphWindow()
	wave/T wPVsCompWin = root:Compare:VarWaves:wPVsCompWin
	wave/T wPVsCompL = root:Compare:VarWaves:wPVsCompL
	wave/T wPVsCompR = root:Compare:VarWaves:wPVsCompR
	wave wPVsCompWinSel = root:Compare:VarWaves:wPVsCompWinSel
	wave wPVsCompLSel = root:Compare:VarWaves:wPVsCompLSel
	wave wPVsCompRSel = root:Compare:VarWaves:wPVsCompRSel
	wave wPeriodsWinSel = root:Compare:VarWaves:wPeriodsWinSel
	
	Duplicate/T/O wPVsCompWin, wPVsCompL, wPVsCompR
	Duplicate/O wPVsCompWinSel, wPVsCompLSel, wPVsCompRSel
	wPeriodsWinSel = 0
	OpenCompareWindow()
	ListBox list0,win=window_compare,selWave=root:Compare:VarWaves:wPVsCompLSel,mode= 5,selRow= -1
	ListBox list1,win=window_compare,selWave=root:Compare:VarWaves:wPVsCompRSel,mode= 5,selRow= -1
End

Function ZeroSel_Comp()
	wave/T wPDG = root:Compare:VarWaves:wPDG
	variable i
	
	for(i=0;DimSize(wPDG,0)>i;i+=1)
		wPDG[i][3] = "0"
	endfor
End

Function SetDHVars() //função para selecinar o intervalo para a variavel global
	SVAR/Z gStartDate = root:Compare:Variables:gStartDate //referência à variável global gDataInicial
	SVAR/Z gEndDate = root:Compare:Variables:gEndDate //referência à variável global gDataFinal
	NVAR gPeriod = root:Compare:Variables:gPeriod
	NVAR gMethod = root:Compare:Variables:gMethod
	NVAR gInterval = root:Compare:Variables:gInterval
	NVAR gTimezone = root:Compare:Variables:gTimezone
	NVAR gAdjustDH = root:Compare:Variables:gAdjustDH
	NVAR dds = root:Compare:Variables:dds //dia inicial
	NVAR mms = root:Compare:Variables:mms //mês inicial
	NVAR yyyys = root:Compare:Variables:yyyys //ano inicial
	NVAR hs = root:Compare:Variables:hs //hora inicial
	NVAR ms = root:Compare:Variables:ms //minuto inicial
	NVAR ss = root:Compare:Variables:ss //segundo inicial
	NVAR dde = root:Compare:Variables:dde //dia final
	NVAR mme = root:Compare:Variables:mme //mês final
	NVAR yyyye = root:Compare:Variables:yyyye //ano final
	NVAR he = root:Compare:Variables:he //hora final
	NVAR me = root:Compare:Variables:me //minuto final
	NVAR se = root:Compare:Variables:se //segundo final
	
	//Formação da string "gDataInicial" com data/hora inicial
	if (ss < 10)
		sprintf gStartDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:%0.3f", yyyys, mms, dds, hs, ms, ss
	else
		sprintf gStartDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:%0.3f", yyyys, mms, dds, hs, ms, ss
	endif
	
	//Formação da string "gDataFinal" com data/hora final
	if (se < 10)
		sprintf gEndDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:%0.3f", yyyye, mme, dde, he, me, se
	else
		sprintf gEndDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:%0.3f", yyyye, mme, dde, he, me, se
	endif
End

