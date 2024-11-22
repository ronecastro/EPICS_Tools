#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.
#pragma rtFunctionErrors = 1

//Essa função analisa os dados baixados e gera as waves usando-os
Function ParseTxtData(data, wave_name)
	string data
	string wave_name
	variable index
	variable start
	variable timestamp
	string timestamp_txt
	variable value
	string value_txt
	variable secs_start, secs_end
	variable nanos_start, nanos_end
	variable value_start, value_end
	variable i
	string wave_values, wave_timestamp
	string nanos
	variable egu_start, egu_end
	string egu
	
	wave_values = wave_name //temporariamente uso essa variavel para nomes
	wave_timestamp = (wave_name + "_TS") //variavel de timestamp baseada no nome
	make/O /D /N=0 $wave_values, $wave_timestamp
	start = 0
	index = strsearch(data, "\"secs\":", start)
	i = 0
	do
		if (index != -1) 
			index = strsearch(data, "\"secs\":", start) 
			if (index != -1)
				secs_start = strsearch(data, "\"secs\":" , index) + 8
				secs_end = strsearch(data, ",", secs_start) -1
				timestamp_txt = data[secs_start, secs_end]
				nanos_start = strsearch(data,  "\"nanos\":", index) + 9
				nanos_end = strsearch(data, ",", nanos_start)
				nanos = data[nanos_start, nanos_end-1]
				if (strlen(nanos) < 9)
					do
						nanos = "0" + nanos
					while(strlen(nanos) < 9)
				endif
				timestamp_txt = timestamp_txt + "." + nanos
				
				value_start = strsearch(data,  "\"val\":", index) + 7
				value_end = strsearch(data, ",", value_start)
				value_txt = data[value_start, value_end]
				
				//print "timestamp_txt", timestamp_txt
				timestamp = str2num(timestamp_txt) + 2082844800 //difference between epoch and unix timestamp
				//print "value", value
				value = str2num(value_txt)
				
				InsertPoints /V=(timestamp) (numpnts($wave_timestamp)), 1, $wave_timestamp
				InsertPoints /V=(value) (numpnts($wave_values)), 1, $wave_values
				
				start = nanos_start
				i = i + 1
				//print i, index, timestamp, value
			endif
		endif
	while (index != -1)
		SetScale d -inf, inf, "dat", $wave_timestamp
End

//Essa função faz requisita dados de uma PV atraves de uma URL
Function archiver2igor_(url, pvname)
	string url
	string pvname
	string data
	string wave_name
	
	data = FetchURL(url)
	wave_name = ReplaceString(":", pvname, "_")
	ParseTxtData(data, wave_name)
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
//de data/hora inicial e data/hora final, as quais correspondem aos controles da janela LOAD DATA
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

//Aplica funções à chamada via url dos dados do archiver
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

//Adquire valor de um controle em determinado panel, em numero
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

//Adquire valor de um controle em determinado panel, em texto
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

//Constroi URL apontando para dados de uma PV do Archiver
Function/S BuildArchiverURL(pvname, startdata, enddata)
	string pvname
	string startdata
	string enddata
	NVAR/Z Method = root:GlobalVariables:gMethod
	NVAR/Z Interval = root:GlobalVariables:gInterval
	SVAR/Z gArchiverURLaffix0 = root:GlobalVariables:gArchiverURLaffix0
	SVAR/Z gArchiverURLaffix1 = root:GlobalVariables:gArchiverURLaffix1
	SVAR/Z gArchiverURLaffix2 = root:GlobalVariables:gArchiverURLaffix2
	SVAR/Z gArchiverURLaffix3 = root:GlobalVariables:gArchiverURLaffix3
	string archiverURL
	variable Timezone
	variable PrintURL
	string result
	string aux1 = gArchiverURLaffix0 //"http://10.0.38.42/retrieval/data/getData.json?pv="
	string aux2 = gArchiverURLaffix1 //"&from="
	string aux3 = gArchiverURLaffix2 //"&to="
	string Z = gArchiverURLaffix3 //"Z"
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
	result = replaceString("\n", result, "")
	result = replaceString("\r", result, "")
	
	if (GetControlValueNbr(cbPrintURL, panel) == 1)
		print result
	endif
	
	return result	
End

//Essa funçao controi URL e baixa os dados do Archiver, gerando waves de dados e timestamp
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
	
	result = archiver2igor_(url, pvname)

	if (strlen(gEmptyPV) == 0 && strlen(gParseFail) == 0 && gECode == 0)
		print "Wave " + pvname + " Carregada!"
	endif
					
	pvname_TS = ReplaceString(":", pvname, "_") + "_TS" //gera nome da timestamp baseada no nome da PV
	wave aux_TS = $pvname_TS
	aux_TS += gAdjustDH //ajuste horário da wave de timestamp de acordo com controle correspondente
	
	gECode = 0
	return result
End

//Reset de variaveis globais
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

//Abre janela DataAnalysis
Function OpenDataAnalysisWindow()
	DoWindow/F DataAnalysis
	if (V_Flag == 1)
		KillWindow /Z DataAnalysis
	endif
	Execute/Q "DataAnalysis()"
	//GlobalReset()
	ControlUpdate /A /W=DataAnalysis
End

//Função para desabilitar controles na janela LoadData quando necessario
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

//Procura item no campo de pesquisa
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

Function AddPDGSel() 
	wave/T wPDG = root:VarList:wPDG
	SVAR/Z PVsFile = root:GlobalVariables:gPVsfile
	wave/T wGrepRes = root:VarList:wGrepRes
	wave/T wParameters2Search = root:VarList:wParameters2Search
	wave wParameterSel = root:VarList:wParameterSel
	string PDGlist = ""
	variable i
	string PVsFile_
	
	Redimension/N=0 wGrepRes //esvazio a wave
	
	for(i=0;DimSize(wPDG,0)>i;i+=1)
		if(GrepString(wPDG[i][3],"1"))
			PDGlist = PDGlist + wPDG[i][4] //faço a lista PDGlist de filtros a serem carregados
		endif
	endfor
	
	PathInfo EPICS_Tools
	if (V_Flag == 1)
		PVsFile_ = S_path + PVsFile
	else
		print "Problems finding EPICSpvlist.dat"
		return 0
	endif
	KillVariables/Z V_Flag
	KillStrings/Z S_path

	for(i=0;ItemsInList(PDGlist)>i;i+=1)
		Grep/A/E=StringFromList(i,PDGlist) PVsFile_ as wGrepRes //pesquiso filtros no arquivo de PVs
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

Function ZeroSel()
	wave/T wPDG = root:VarList:wPDG
	variable i
	
	for(i=0;DimSize(wPDG,0)>i;i+=1)
		wPDG[i][3] = "0"
	endfor
End

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

//reseta estado dos botoes da tela LoadData
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

//função que aplica o shift de todos os BPMs
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

//Função para shiftar valores da wave de FONTES para a referência. 
//Recebe um valor de referência (valor do primeiro ponto de uma wave
//ou zero, por exemplo) e um wave como argumentos.
Function PsShiftWave(ref, wname_PS)
	variable ref
	string wname_PS
	variable diff
	variable NEWpntval
	variable i
	string name_PS
	string cmd
	wave/Z mywave = $wname_PS
	
	if (numpnts(mywave) > 0)
	diff = ref - mywave[0]
		for(i=0;numpnts(mywave)>i;i+=1)
			NEWpntval = mywave[i] + diff
			mywave[i] = NEWpntval
		endfor
	else
		name_PS = NameOfWave(mywave)
		sprintf cmd, "Wave %s vazia!", wname_PS
		print cmd
	endif
End

//função que aplica o shift em fontes
Function ShiftAllPS()
	string fulllist = WaveList("*Current*|*Voltage*|*PWM*", ";", "")
	string name_PS, cmd
	variable i
   
   if (ItemsInList(fulllist) > 0)
		for(i=0; i<itemsinlist(fulllist); i+=1)
			name_PS = stringfromlist(i, fulllist)
			sprintf cmd, "PsShiftWave(0, '%s')", name_PS
			execute cmd    
		endfor
	print "PS Shifting Operation Complete!"
	print " "
	endif
end

//Função para shiftar valores da wave de TEMPERATURA para a referência. 
//Recebe um valor de referência (valor do primeiro ponto de uma wave
//ou zero, por exemplo) e um wave como argumentos.
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

//função que aplica o shift em temperaturas.
Function ShiftAllTEMP()
	string fulllist = WaveList("*emp*|*T-Mon*", ";", "")
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