#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.
#pragma rtFunctionErrors = 1

Function DownloadPVList()
	GetAllPvs("https://10.0.38.42/mgmt/bpl/getAllPVs?limit=-1") //executa XOP para baixar lista de PVs
End

//Esta função preenche as variáveis globais relativas aos controles da tela "LOAD DATA" baseadas
//no argumento "datehour", que é uma string no formato <aaaa-mm-ddThh:mm:ss.sss>
Function/S FillGlobalDateHourVars(datehour, mode)
	string datehour //data/hora formato padrão <aaaa-mm-ddThh:mm:ss.sss>
	int mode //0 = inicial / 1 = final
	SVAR/Z gEPICSName = root:GlobalVariables:gEPICSName //nome da variável EPICS
	SVAR/Z gStartDate = root:GlobalVariables:gStartDate //texto da data/hora inicial formato padrão <aaaa-mm-ddThh:mm:ss.sss>
	SVAR/Z gEndDate = root:GlobalVariables:gEndDate //texto da data/hora final formato padrão <aaaa-mm-ddThh:mm:ss.sss>
	NVAR/Z dds = root:GlobalVariables:dds //dia inicial
	NVAR/Z mms = root:GlobalVariables:mms //mês inicial
	NVAR/Z yyyys = root:GlobalVariables:yyyys //ano inicial
	NVAR/Z hs = root:GlobalVariables:hs //hora inicial
	NVAR/Z ms = root:GlobalVariables:ms //minuto inicial
	NVAR/Z ss = root:GlobalVariables:ss //segundo inicial
	NVAR/Z dde = root:GlobalVariables:dde //dia final
	NVAR/Z mme = root:GlobalVariables:mme //mês final
	NVAR/Z yyyye = root:GlobalVariables:yyyye //ano final
	NVAR/Z he = root:GlobalVariables:he //hora final
	NVAR/Z me = root:GlobalVariables:me //minuto final
	NVAR/Z se = root:GlobalVariables:se //segundo final
	
	if (mode == 0) //preenche as variáveis relativas ao início
		sscanf datehour , "%4d-%2d-%2dT%2d:%2d:%f", yyyys, mms, dds, hs, ms, ss
	endif
	if (mode == 1) //preenche as variáveis relativas ao fim
		sscanf datehour , "%4d-%2d-%2dT%2d:%2d:%f", yyyye, mme, dde, he, me, se
	endif
End

//Esta função gera data/hora em formato MAC (segundos desde 01/01/1904). Essa data/hora gerada serve para
//calcular diferenças de 1, 2, 6 e 24 horas entre data/hora inicial e data/hora final, permitindo manipular
//os dados
Function MacDateFromString(strdatehour)
	string strdatehour
	variable day, month, year, hours, minutes
	double seconds
	double datehourMac
	
	sscanf strdatehour, "%4d-%2d-%2dT%2d:%2d:%f", year, month, day, hours, minutes, seconds
	datehourMac = date2secs(year, month, day) + (hours*3600) + (minutes*60) + seconds
	return datehourMac
End

//Esta função gera uma string no formato <aaaa-mm-ddThh:mm:ss.sss> a partir da data/hora no formato MAC
//(segundos desde 01/01/1904) 
Function/S SetUpStringFromMacDate(MacDate)
	double MacDate
	string strdatehour
	
	strdatehour = secs2date(MacDate, -2) + "T" + secs2time(MacDate, 3, 3)
	return strdatehour
End

//Esta função gera o valor das strings globais de data/hora inicial e data/hora final 
//no formato <aaaa-mm-ddThh:mm:ss.sss>, baseados nos valores das variáveis globais 
//de data/hora inicial e data/hora final, as quais correspondme aos controles da janela LOAD DATA
Function SetUpDateHourGVar()
	SVAR/Z gStartDate = root:GlobalVariables:gStartDate //referência à variável global gDataInicial
	SVAR/Z gEndDate = root:GlobalVariables:gEndDate //referência à variável global gDataFinal
	NVAR dds = root:GlobalVariables:dds //dia inicial
	NVAR mms = root:GlobalVariables:mms //mês inicial
	NVAR yyyys = root:GlobalVariables:yyyys //ano inicial
	NVAR hs = root:GlobalVariables:hs //hora inicial
	NVAR ms = root:GlobalVariables:ms //minuto inicial
	NVAR ss = root:GlobalVariables:ss //segundo inicial
	NVAR dde = root:GlobalVariables:dde //dia final
	NVAR mme = root:GlobalVariables:mme //mês final
	NVAR yyyye = root:GlobalVariables:yyyye //ano final
	NVAR he = root:GlobalVariables:he //hora final
	NVAR me = root:GlobalVariables:me //minuto final
	NVAR se = root:GlobalVariables:se //segundo final
	
	//Formação da string "gDataInicial" com data/hora inicial
	if (ss < 10)
		sprintf gStartDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:0%.3f", yyyys, mms, dds, hs, ms, ss
	else
		sprintf gStartDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:%.3f", yyyys, mms, dds, hs, ms, ss
	endif
	
	//Formação da string "gDataFinal" com data/hora final
	if (se < 10)
		sprintf gEndDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:0%.3f", yyyye, mme, dde, he, me, se
	else
		sprintf gEndDate ,"%.2d-%.2d-%.2dT%.2d:%.2d:%.3f", yyyye, mme, dde, he, me, se
	endif
End

//Esta função preenche as variáveis globais de data/hora com os valores relativos à última hora
//de diferença entre data/hora inicial e data/hora final
Function UpdatePeriodControls(interval)
	int interval //in hours
	string datehours, datehoure
	datehours = SetUpStringFromMacDate(datetime - (interval*3600))
	datehoure = SetUpStringFromMacDate(datetime)
	FillGlobalDateHourVars(datehours, 0)
	FillGlobalDateHourVars(datehoure, 1)
End

//apenas para manter o padrão de existência das funções
Function FixedStartFixedEnd()

End

//Esta função preenche as variáveis globais de data/hora final com os valores relativos atuais.
//Não altera a data/hora inicial
Function FixedStartEndNow()
	string datehour
	datehour = SetUpStringFromMacDate(datetime)
	FillGlobalDateHourVars(datehour, 1)
End

//recebe lista de nomes Mnemonicos para verificar um a um se possuem um único ponto na wave correspondente
Function FixOnePointWaves(pvswave) 
	wave/T pvswave
	string namewave = ""
	string namewave_TS = ""
	SVAR/Z gStartDate = root:GlobalVariables:gStartDate
	SVAR/Z gEndDate = root:GlobalVariables:gEndDate
	NVAR/Z gAdjustDH = root:GlobalVariables:gAdjustDH
	NVAR/Z gTimezone = root:GlobalVariables:gTimezone
	wave/Z/T wPVs = root:Varlist:wPVs
	variable frst_pnt, lst_pnt, max_pnts, sum_pnts, med
	int i = 0
	variable y, m, d, hh, mm, ss
	int macdt
	
	for(i=0; i < numpnts(pvswave); i+=1) // para cada item na lista recebida
		namewave = pvswave[i]
		namewave = ReplaceString(":", namewave, "_")
		wave aux = $namewave
		if (WaveExists(aux))
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
			
		else
			Print namewave + " do not exist!"
		endif	
	endfor
End

//função para aplicar funções à chamada via url dos dados do archiver
Function/S ApplyFunction(EPICSname)
	string EPICSname
	NVAR/Z Method = root:GlobalVariables:gMethod
	NVAR/Z Interval = root:GlobalVariables:gInterval
	string EPICSnameRes
	
	switch (Method)
		case 1:
			EPICSnameRes = EPICSname
			break
		case 2:
			EPICSnameRes = "mean_" + num2str(Interval) + "(" + EPICSname + ")"
			break
		case 3:
			EPICSnameRes = "min_" + num2str(Interval) + "(" + EPICSname + ")"
			break
		case 4:
			EPICSnameRes = "max_" + num2str(Interval) + "(" + EPICSname + ")"
			break
		case 5:
			EPICSnameRes = "nth_" + num2str(Interval) + "(" + EPICSname + ")"
			break
		default:
			EPICSnameRes = EPICSname
			break
	endswitch
	return EPICSnameRes
End

Function GetControlValueNbr(control, panel)
	string control
	string panel
	variable value
	
	DFREF DFR = GetDataFolderDFR()
	SetDataFolder root:
	ControlInfo/W=$panel $control
	value = V_Value
	KillVariables/Z V_Value
	KillStrings/Z V_Value
	SetDataFolder DFR
	
	return value
End

Function GetControlValueTxt(control, panel)
	string control
	string panel
	variable value
	
	DFREF DFR = GetDataFolderDFR()
	SetDataFolder root:
	ControlInfo/W=$panel $control
	value = V_Value
	KillVariables/Z/A
	KillStrings/Z/A
	SetDataFolder DFR
	
	return value
End


Function/S BuildArchiverURL(pvname, startdata, enddata)
	string pvname
	string startdata
	string enddata
	NVAR/Z Method = root:GlobalVariables:gMethod
	NVAR/Z Interval = root:GlobalVariables:gInterval
	variable Timezone
	variable PrintURL
	string result
	string aux1 = "http://10.0.38.42/retrieval/data/getData.json?pv="
	string aux2 = "&from="
	string aux3 = "&to="
	string Z = "Z"
	string panel = "LoadDataWindow"
	string cbPrintURL = "cburl"
	string svTimeZone = "svAdjustTimezone"
	
	Timezone = GetControlValueNbr(svTimeZone, panel)
	
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
	
	result = aux1 + ApplyFunction(pvname) + aux2 + startdata + Z + aux3 + enddata + Z
	
	if (GetControlValueNbr(cbPrintURL, panel) == 1)
		print result
	endif
	
	return result	
End

Function LoadSelection(pvname)
	string pvname
	SVAR/Z gStartDate = root:GlobalVariables:gStartDate
	SVAR/Z gEndDate = root:GlobalVariables:gEndDate
	NVAR/Z gAdjustDH = root:GlobalVariables:gAdjustDH
	NVAR/Z gTimezone = root:GlovalVariables:gTimezone
	SVAR/Z gEmptyPV = root:GlobalVariables:gEmptyPV
	SVAR/Z gParseFail = root:GlobalVariables:gParseFail
	NVAR/Z gECode = root:GlobalVariables:gECode
	string url
	int result = 0
	string pvname_TS
	
	gEmptyPV = ""
	
	SetUpDateHourGVar() //função preenche variaveis globais de data/hora inicio/fim
	url = BuildArchiverURL(pvname, gStartDate, gEndDate)
	
	result = archiver2igor(url)

	if (strlen(gEmptyPV) == 0 && strlen(gParseFail) == 0 && gECode == 0)
		print "Wave " + pvname + " Carregada!"
	endif
					
	pvname_TS = ReplaceString(":", pvname, "_") + "_TS" //gera nome da timestamp baseada no nome da PV
	wave aux_TS = $pvname_TS
	aux_TS += gAdjustDH //ajuste horário da wave de timestamp de acordo com controle correspondente
	
	gECode = 0
	return result
End

Function GlobalReset()
	SVAR/Z gEPICSName = root:GlobalVariables:gNomeEPICS //nome da variável EPICS
	SVAR/Z gMnemonicName = root:GlobalVariables:gMnemonicName
	SVAR/Z gStartDate = root:GlobalVariables:gStartDate //texto da data/hora inicial formato padrão <aaaa-mm-ddThh:mm:ss.sss>
	SVAR/Z gEndDate = root:GlobalVariables:gEndDate //texto da data/hora final formato padrão <aaaa-mm-ddThh:mm:ss.sss>
	SVAR/Z gEmptyPV = root:GlobalVariables:gEmptyPV //variável EPICS vazia, preenchida pelo XOP quando se carrega as variáveis no Igor
	SVAR/Z gSearchField = root:GlobalVariables:gSearchField // campo com filtro de selecao da variável
	WAVE/Z wParameters2Search = root:VarList:wParameters2Search
	WAVE/Z wParameterSel = root:VarList:wParameterSel
	WAVE/Z wGrepRes = root:VarList:wGrepRes
	NVAR/Z gPeriod = root:GlobalVariables:gPeriod //variável relativa ao período predefinido no controle correspondente da janela CARREGA DADOS
	NVAR/Z gInterval = root:GlobalVariables:gInterval //variável relativa ao Intervalo entre Pontos no controle correspondente da janela CARREGA DADOS
	NVAR/Z gAbort = root:GlobalVariables:gAbort //comando para abortar ação
	NVAR/Z gAdjustDH = root:GlobalVariables:gAdjustDH
	gEPICSName = ""
	gMnemonicName = ""
	gStartDate = ""
	gEndDate = ""
	gEmptyPV = ""
	gSearchField = ""
	gPeriod = 5
	gInterval = 1
	gAbort = 0
	gAdjustDH = 0
	Redimension/N=0 wParameters2Search
	Redimension/N=0 wParameterSel
	Redimension/N=0 wGrepRes
	UpdatePeriodControls(1)
	PopUpMenu/Z puInterval disable=2, mode=1
	DisableControls(0, 0)
	//SetDataFolder root:EPICSChannels
	//Redimension/N=(numpnts(wnameE)) EPICSChannels
	SetDataFolder root:
End

Function OpenLoadDataWindow()
	DoWindow/HIDE=? LoadDataWindow
	if (V_Flag == 1 || V_Flag == 2)
		KillWindow/Z LoadDataWindow
	endif
	Execute/Q "LoadDataWindow()"
	//GlobalReset()
	//GetAllPVs("https://10.0.38.42/mgmt/bpl/getAllPVs?limit=-1")
	ControlUpdate /A /W=LoadDataWindow
	KillVariables/Z V_Flag
End

Function OpenCompareDataWindow()
	DoWindow/HIDE=? CompareDataWindow
	if (V_Flag == 1 || V_Flag == 2)
		KillWindow/Z CompareDataWindow
	endif
	Execute/Q "CompareDataWindow()"
	ControlUpdate /A /W=CompareDataWindow
	KillVariables/Z V_Flag
End

Function RefreshEPICSpvlist()
	SVAR/Z gGetAllPVsURL = root:GlobalVariables:gGetAllPVsURL
	//GetAllPVs("http://10.0.38.42/retrieval/bpl/getMatchingPVs?pv=*&limit=-1")
	GetAllPVslocal(gGetAllPVsURL)
End

//Essa função gera uma lista com todas as PVs do Archiver
Function GetAllPVslocal(url)
	string url
	string data
	wave/T wAllPVsList = root:VarList:wAllPVsList
	SVAR/Z PVsFile = root:GlobalVariables:gPVsfile
	variable refnum, i, offset, totalpvs, multiplier
	variable ten_perc
	string filename
	
	data = FetchURL("https://ais-eng-srv-ta.cnpem.br/mgmt/bpl/getAllPVs?limit=-1")
	print "data:", strlen(data)
	print "url:", url
	variable error = GetRTError(1)
	if (error != 0)
		string err = getErrMEssage(error)
		print "Error on downloading from Archiver Server!", err
	else
		print("Downloaded Data! Parsing...")
		data = ReplaceString("[", data, "")
		data = ReplaceString("\"", data, "")
		data = ReplaceString("\r", data, "")
		data = ReplaceString("\n", data, "")
		data = ReplaceString("]", data, "")
		offset = 0
		Redimension/N=0 wAllPVsList
		totalpvs = ItemsInList(data,",")
		ToCommandLine "["
		multiplier = 1
		ten_perc = round(totalpvs/100)
		for (i=0; totalpvs>=i; i+=1)
			InsertPoints inf, 1, wAllPVsList
			wAllPVsList[i] = stringfromlist(i, data, ",")
			if (i == (ten_perc*multiplier))
				ToCommandLine "="
				multiplier += 1
			endif
		endfor
		ToCommandLine "]"
		print("Parsed! Saving to Disk...")
		Save/O/G/M="\r\n"/P=IgorUserFiles wAllPVsList as "EPICSpvlist.dat"
		print("Data Saved to Disk!")
	endif
End

Function URLtest()
	string pvs = "https://ais-eng-srv-ta.cnpem.br/mgmt/bpl/getAllPVs?limit=-1"
	string header = "rejectUnauthorized: false;"
	URLRequest /V=2 method=GET, url=pvs, headers=header
End

Function OpenDataAnalysisWindow()
	DoWindow/F DataAnalysis
	if (V_Flag == 1)
		KillWindow /Z DataAnalysis
	endif
	Execute/Q "DataAnalysis()"
	//GlobalReset()
	ControlUpdate /A /W=DataAnalysis
End

Function DisableControls(StartControls, EndControls)
	int StartControls
	int EndControls
	string DateHourSControlList = ControlNameList("LoadDataWindow",";","*Start*") //gera lista com nomes dos controles data/hora inicial
	string DateHourEControlList = ControlNameList("LoadDataWindow",";","*End*") //gera lista com nomes dos controles data/hora final

	if (StartControls == 0)
		ModifyControlList DateHourSControlList disable=2 //desabilita edição dos controles data/hora inicial
	else
		ModifyControlList DateHourSControlList disable=0 //desabilita edição dos controles data/hora inicial
	endif

	if (EndControls == 0)
		ModifyControlList DateHourEControlList disable=2 //desabilita edição dos controles data/hora inicial
	else
		ModifyControlList DateHourEControlList disable=0 //desabilita edição dos controles data/hora inicial
	endif
End

Function/T SearchFieldInterpreter(in)
	string in
	variable index
	string ex = ""
	SVAR/Z gSearchField = root:GlobalVariables:gSearchField
	WAVE/T/Z wSFA = root:VarList:wSearchFieldAliases
	WAVE/T/Z wSFAE = root:VarList:wSearchFieldAliasesExplicit

	FindValue/TEXT=gSearchField/TXOP=4/Z wSFA
	If (V_Value != -1)
		index = V_Value
		ex = (wSFAE[index])
	endif
	return ex
End


Function reset()

Button btnLoadSelection, disable=0
ControlUpdate /W=LoadDataWindow btnLoadSelection
Button btnCancel, disable=2
ControlUpdate /W=LoadDataWindow btnCancel

End


//Função para shiftar valores da wave de bpm para a referência. Recebe um valor de referência (valor do primeiro ponto de uma wave
//ou zero, por exemplo) e um wave como argumentos
Function BpmShiftWave(ref, wname)
	variable ref
	string wname
	variable diff
	variable NEWpntval
	variable i
	string name
	string cmd
	wave/Z mywave = $wname
	
	if (numpnts(mywave) > 0)
	diff = ref - mywave[0]
		for(i=0;numpnts(mywave)>i;i+=1)
			NEWpntval = mywave[i] + diff
			mywave[i] = NEWpntval
		endfor
	else
		name = NameOfWave(mywave)
		sprintf cmd, "Wave %s vazia!", wname
		print cmd
	endif
End

Function ShiftAllBPMs()
	string fulllist = WaveList("*BPM*Mon*", ";", "")
	string name, cmd
	variable i
   
   if (ItemsInList(fulllist) > 0)
		for(i=0; i<itemsinlist(fulllist); i+=1)
			name = stringfromlist(i, fulllist)
			sprintf cmd, "BpmShiftWave(0, '%s')", name
			execute cmd    
		endfor
	print "BPMs Shifting Operation Complete!"
	print " "
	endif
end

Function PsShiftWave(ref, wname)
	variable ref
	string wname
	variable diff
	variable NEWpntval
	variable i
	string name
	string cmd
	wave/Z mywave = $wname
	
	if (numpnts(mywave) > 0)
	diff = ref - mywave[0]
		for(i=0;numpnts(mywave)>i;i+=1)
			NEWpntval = mywave[i] + diff
			mywave[i] = NEWpntval
		endfor
	else
		name = NameOfWave(mywave)
		sprintf cmd, "Wave %s vazia!", wname
		print cmd
	endif
End

Function ShiftAllPS()
	string fulllist = WaveList("*PS*Current-Mon*", ";", "")
	string name, cmd
	variable i
   
   if (ItemsInList(fulllist) > 0)
		for(i=0; i<itemsinlist(fulllist); i+=1)
			name = stringfromlist(i, fulllist)
			sprintf cmd, "PsShiftWave(0, '%s')", name
			execute cmd    
		endfor
	print "PS Shifting Operation Complete!"
	print " "
	endif
end

Function TempShiftWave(ref, wname)
	variable ref
	string wname
	variable diff
	variable NEWpntval
	variable i
	string name
	string cmd
	wave/Z mywave = $wname
	
	if (numpnts(mywave) > 0)
	diff = ref - mywave[0]
		for(i=0;numpnts(mywave)>i;i+=1)
			NEWpntval = mywave[i] + diff
			mywave[i] = NEWpntval
		endfor
	else
		name = NameOfWave(mywave)
		sprintf cmd, "Wave %s vazia!", wname
		print cmd
	endif
End

Function ShiftAllTEMP()
	string fulllist = WaveList("*Temp**T-Mon**temp*", ";", "")
	string name, cmd
	variable i
   
   if (ItemsInList(fulllist) > 0)
		for(i=0; i<itemsinlist(fulllist); i+=1)
			name = stringfromlist(i, fulllist)
			sprintf cmd, "TempShiftWave(0, '%s')", name
			execute cmd    
		endfor
	print "Temperatures Shifting Operation Complete!"
	print " "
	endif
end



//Function ShiftSIBPMs()
//	string fulllist = WaveList("^SI*BPM*Mon", ";", "")
//	string name, cmd
//	variable i
//   
//	for(i=0; i<itemsinlist(fulllist); i +=1)
//		name = stringfromlist(i, fulllist)
//		sprintf cmd, "BpmShiftWave(0, '%s')", name
//		execute cmd    
//	endfor
//	print "SI BPMs shifted towards zero!"
//end

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
	endif		
End

//Função para atualizar a wave que guarda quais os checkboxes estão selecionados da tela de 'Predefined Groups'
//é acionado sempre que clicamos em alguma checkbox daquela janela
Function PDGcheckboxSel(controlname, controlvalue)
	string controlname
	variable controlvalue
	wave/T/Z wPDG = root:VarList:wPDG
	variable i
	
	for(i=0;DimSize(wPDG,0)>i;i+=1)
		if(stringmatch(wPDG[i][2],controlname))
			wPDG[i][3] = num2str(controlvalue)
		endif
	endfor
	
End

Function AddPDGSel()
	wave/T wPDG = root:VarList:wPDG
	SVAR/Z PVsFile = root:GlobalVariables:gPVsfile
	wave/T wGrepRes = root:VarList:wGrepRes
	wave/T wParameters2Search = root:VarList:wParameters2Search
	wave wParameterSel = root:VarList:wParameterSel
	string PDGlist = ""
	variable i
	
	Redimension/N=0 wGrepRes //esvazio a wave
	
	for(i=0;DimSize(wPDG,0)>i;i+=1)
		if(GrepString(wPDG[i][3],"1"))
			PDGlist = PDGlist + wPDG[i][4] + ";" //faço a lista PDGlist de filtros a serem carregados
		endif
	endfor
	
	PDGlist = ReplaceString(";;", PDGlist, ";")
	string lastchar = PDGlist[strlen(PDGlist)-1, inf]
	if (stringmatch(lastchar, ";"))
		PDGlist = PDGlist[0, strlen(PDGlist)-1]
	endif
	
	for(i=0;ItemsInList(PDGlist)>i;i+=1)
		Grep/A/E=StringFromList(i,PDGlist) PVsFile as wGrepRes //pesquiso filtros no arquivo de PVs
	endfor
	
	killstrings/A/Z //mato as strings geradas no Grep acima
	killvariables/A/Z //idem para variáveis
	
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

Function OpenPDG()
	DoWindow/F PreDefinedGroups
	if (V_Flag == 1)
		KillWindow /Z PreDefinedGroups
	endif
	Execute/Q "PreDefinedGroups()"
	//GlobalReset()
	ControlUpdate /A /W=PreDefinedGroups
	KillVariables/Z V_flag, V_value, V_startParagraph, S_fileName, S_path, S_Value 
End

//Function/T ReturnCtrlTitle(name)
//	string name
//	string title
//	ControlInfo/W=PreDefinedGroups name 
//	killstrings/A/Z //mato as strings geradas no Grep acima
//	killvariables/A/Z //idem para variáveis
//	return title
//End


Function ZeroSel()
	wave/T wPDG = root:VarList:wPDG
	variable i
	
	for(i=0;DimSize(wPDG,0)>i;i+=1)
		wPDG[i][3] = "0"
	endfor
End


//Function aux()
//	variable controlnumber
//	variable windex
//	variable i
//	string controllist
//	string controltitle
//	string controlname
//	wave/T wPDG = root:VarList:wPDG
//	
//	controllist = ControlNameList("PreDefinedGroups")
//	
//	for(i=0;ItemsInList(controllist)>i;i+=1)
//		if(StringMatch(StringFromList(i,controllist),"group*")||StringMatch(StringFromList(i,controllist),"button*"))
//			continue
//		else
//			if(stringmatch(wPDG[i][2],"0"))
//				controlname = StringFromList(i,controllist)
//				ControlInfo/W=PreDefinedGroups $controlname
//				FindValue/TEXT=S_title/TXOP=1 wPDG
//				windex = V_row
//				wPDG[windex][2] = controlname
//			else
//				FindValue/S=(V_row+1)/TEXT=S_title/TXOP=1/Z wPDG
//				windex = V_row
//				wPDG[windex][2] = controlname
//			endif
//			
//			
//		endif
//	endfor	
//End

Function ClearWaves()
	string list
	string wname
	DFREF DFR = GetDataFolderDFR()
	variable i
	variable YesOrNo
	
	DoAlert/T="Continue?" 1, "Are you sure?\r\rIf you click 'Yes', the content of all waves will be erased!\r\rUse this if you want to make this Experiment's file smaller or to release memory."
	
	if (V_Flag == 1)
		SetDataFolder root:
		list = WaveList("*",";","")
		for(i=0;ItemsInList(list)>i;i+=1)
			wname = stringfromlist(i,list)
			Redimension/N=0 $wname
		endfor
		//print "YES"
		print "Waves's Content Erased!"
		print " "
		SetDataFolder DFR
	else
		//print "NO"
	endif
	KillVariables/Z V_Flag
End

//Função para criar gráfico com waves que respeitem o filtro fornecido como argumento.
Function CreateGraph(wfilter, leg)
	string wfilter
	string leg
	variable i
	string displaywave
	string displaywave_TS
	string command
	wave/T wGrepRes = root:VarList:wGrepRes
	wave/T wGrepResTotal
	SVAR/Z PVsFile = root:GlobalVariables:gPVsfile
	
	
	for(i=0;ItemsInList(wfilter)>i;i+=1)
		Grep/O/E=StringFromList(i,wfilter) PVsFile as wGrepRes //pesquiso filtros no arquivo de PVs
		Concatenate/T/NP {wGrepRes}, wGrepResTotal
	endfor
	
	killstrings/A/Z //mato as strings geradas no Grep acima
	killvariables/A/Z //idem para variáveis
	
	if(numpnts(wGrepResTotal)>0)
		displaywave = ReplaceString(":",wGrepResTotal[0],"_")
		displaywave_TS = displaywave + "_TS"
		Display $displaywave vs $displaywave_TS
	
		for(i=1;numpnts(wGrepResTotal)>i;i+=1)
			AppendToGraph $(ReplaceString(":",wGrepResTotal[i],"_")) vs $(ReplaceString(":",wGrepResTotal[i] + "_TS","_"))
		endfor
		Legend/C/N=text0/J/X=0/Y=0 leg
		CommonColorsButtonProc("")
		KillWaves/Z wGrepResTotal
	endif
End

Function CreateBPMGraph(wfilter, leg)
	string wfilter
	string leg
	variable i
	string displaywave
	string displaywave_TS
	string command
	wave/T wGrepRes = root:VarList:wGrepRes
	wave/T wGrepResTotal
	SVAR/Z PVsFile = root:GlobalVariables:gPVsfile
	
	
	for(i=0;ItemsInList(wfilter)>i;i+=1)
		Grep/O/E=StringFromList(i,wfilter) PVsFile as wGrepRes //pesquiso filtros no arquivo de PVs
		Concatenate/T/NP {wGrepRes}, wGrepResTotal
	endfor
	
	killstrings/A/Z //mato as strings geradas no Grep acima
	killvariables/A/Z //idem para variáveis
	
	if(numpnts(wGrepResTotal)>0)
		displaywave = ReplaceString(":",wGrepResTotal[0],"_")
		displaywave_TS = displaywave + "_TS"
		Display $displaywave vs $displaywave_TS
	
		for(i=1;numpnts(wGrepResTotal)>i;i+=1)
			AppendToGraph $(ReplaceString(":",wGrepResTotal[i],"_")) vs $(ReplaceString(":",wGrepResTotal[i] + "_TS","_"))
		endfor
		Legend/C/N=text0/J/X=0/Y=0 leg
		Label left "Posição (µm)"
		CommonColorsButtonProc("")
		KillWaves/Z wGrepResTotal
	endif
End

//Função para configurar waves por eixo nos gráficos. Funciona no gráfico do topo, sem window target
Function GraphModifier(leftaxis, rightaxis, mode)
	variable leftaxis //quantidade de eixos na esquerda
	//variable leftpercent //percentagem do eixo em relação ao gráfico, de 0 a 1
	variable rightaxis
	//variable rightpercent
	//variable traceleft //quantidade de traços no eixo da esquerda
	//variable traceright
	string mode
	string windowname = winname(0,1)
	string traces = tracenamelist(windowname,";",1)
	variable i
	string leftaxisname
	variable qdivaxis
	variable lowfracdivaxis
	variable highfracdivaxis
	variable lowfracdivaxisold
	
		//ModifyGraph axisEnab(left)={0,0.23}
		
		qdivaxis = (leftaxis-1) //quantidade de divisões do eixo
		for(i=0;i<leftaxis-1;i+=1)
			leftaxisname = "left" + num2str(i+1)
			NewFreeAxis $leftaxisname
			if (i==0)
				lowfracdivaxis = 0
				lowfracdivaxisold = 0
				highfracdivaxis = (round(100/leftaxis)/100 * (i+1)) - (0.01 * (i+1))
				ModifyGraph axisEnab(left)={lowfracdivaxis, highfracdivaxis}
			else
				lowfracdivaxis = lowfracdivaxis + (round(100/leftaxis)/100 * (i+1) ) - (0.01 * (i+1))
				//lowfracdivaxisold = lowfracdivaxis
				highfracdivaxis = lowfracdivaxis + (round(100/leftaxis)/100 * (i+1) ) + (0.01 * (i+1))
				Modifygraph axisEnab($leftaxisname) = {lowfracdivaxis, highfracdivaxis}
			endif
			
		endfor
	
		//for(i=0;i 
End

Function KillAllGraphs()
    string fulllist = WinList("*", ";","WIN:1")
    string name, cmd
    variable i
   
    for(i=0; i<itemsinlist(fulllist); i +=1)
        name = stringfromlist(i, fulllist)
        sprintf cmd, "Dowindow/K %s", name
        execute cmd    
    endfor
end

Function axhook(s)
STRUCT WMAxisHookStruct &s
Variable t= s.max
s.max= s.min
s.min= t
return 0
End

Function CDWHook(s)
	STRUCT WMWinHookStruct &s
	Variable hookResult = 0
	switch(s.eventCode)
		case 2: // Activate
			// Handle activate
			CancelAddPeriodWindow()
			break
		case 1: // Deactivate
			// Handle deactivate
			break
			// And so on . . .
	endswitch
	return hookResult // 0 if nothing done, else 1
End

Function HookGetWindowAction(s)
	STRUCT WMWinHookStruct &s
	NVAR/Z gMode = root:Compare:Variables:gMode
	strswitch(s.eventName)
		case "resize":
			GetWindow $(s.winName) hide
			if (V_value)
				//Print "Resized while hidden"
			else
				//Print "Resized while visible"
			endif
			break
		case "moved":
			GetWindow $(s.winName) hide
			if (V_value)
				//Print "Moved while hidden"
			else
				//Print "Moved while visible"
			endif
			break
		case "hide":
			//print "Hide event"
			break
		case "show":
			print "Show event"
			break
		case "kill":
			//print "Kill event"
			gMode = 0
			break
		case "Activate":
			//print "Activate event"
			break
	endswitch
	return 0 // Don't interfere with Igor's handling of events
End