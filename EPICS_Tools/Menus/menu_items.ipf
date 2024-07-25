Menu "Macros"
	"Data Analysis", /Q, OpenDataAnalysisWindow()
	"LOAD DATA", /Q, OpenLoadDataWindow()
	"COMPARE DATA", /Q, OpenCompareDataWindow()
	"-"
	"Wave vs Wave Graph", /Q, WaveVsWaveGraph()
	"Compare Graph", /Q, OpenCompareGraphWindow()
	"-"
	Submenu "AS"
		Submenu "Temperatures"
	 		"Tunnel", /Q, PT100_Tunel()
	 		"Hall", /Q, Temp_Hall_HLS()
	 		"Hall Fancoil", /Q, Temp_Hall_Fancoil()
	 		"Conectivity Room", /Q, Temp_Sala_Conect()
	 		Submenu "Hydraulic Circuits"
	 			"C1", /Q, C1_Temperature()
	 			"C4", /Q, C4_Temperature()
	 			"C6", /Q, C6_Temperature()
	 		End
	 		Submenu "Floor"
	 			"3AN-AV", /Q, Temp_Solo_3AN_3AV()
	 			"6AN-AV", /Q, Temp_Solo_6AN_6AV()
	 			"9AN", /Q, Temp_Solo_9AN()
	 		End
	 		Submenu "Racks"
	 			"Control Racks", /Q, Temp_Rack_Ctrl()
	 			"BPM Racks", /Q, Temp_Rack_BPM()
	 			"Power Sources 1", /Q, Temp_Rack_PS1()
	 			"Power Sources 2", /Q, Temp_Rack_PS2()
	 			"Undulators", /Q, Temp_Rack_Und()
	 			"Vaccum", /Q, Temp_Rack_VAC()
	 		End
		End
	End
	Submenu "LI Graphs"
		Submenu "Power Sources"
			"EG", /Q, LINAC_EG()
			"PU"
			"BUN"
			"KLY1"
			"KLY2"
			"PS", /Q, LINAC_PS()
			"VA", /Q, LINAC_VA()
			"CH", /Q, LINAC_CH()
			"CV", /Q, LINAC_CV()
		End
		Submenu "Temperatures"
			"Skid", /Q, Temp_Skid_LINAC()
		End
	End
	//"-"
	Submenu "TB Graphs"
		Submenu "Power Sources"
			"B", /Q, TB_B()
			"QD", /Q, TB_QD()
			"QF", /Q, TB_QF()
			"CH", /Q, TB_CH()
			"CV", /Q, TB_CV()
			"PU", /Q, TB_PU()
			"BPMy", /Q, TB_BPMy()
			"BPMx", /Q, TB_BPMx()
			"VA", /Q, TB_VA()
		End
	End
	//"-"
	Submenu "BO Graphs"
		Submenu "Power Sources"
			"B", /Q, BO_B()
			"QD", /Q, BO_QD()
			"QF", /Q, BO_QF()
			"QS", /Q, BO_QS()
			"SD", /Q, BO_SD()
			"SF", /Q, BO_SF()
			"CH", /Q, BO_CH()
			"CV", /Q, BO_CV()
			"PU", /Q, BO_PU()
			"RF", /Q, BO_RF()
			"BPMx", /Q, BO_BPMx()
			"BPMy", /Q, BO_BPMy()
			"VA", /Q, BO_VA()
		End
		Submenu "Temperatures"
			Submenu "Vaccum Chambers"
				"BO-01 to BO-10", /Q, BO_PT100_01_10()
				"BO-11 to BO-20", /Q, BO_PT100_11_20()
				"BO-21 to BO-30", /Q, BO_PT100_21_30()
				"BO-31 to BO-40", /Q, BO_PT100_31_40()
				"BO-41 to BO-50", /Q, BO_PT100_41_50()
			End
		End
	End
	//"-"
	Submenu "TS Graphs"
		Submenu "Power Sources"
			"B", /Q, TS_B()
			"QD", /Q, TS_QD()
			"QF", /Q, TS_QF()
			"CH", /Q, TS_CH()
			"CV", /Q, TS_CV()
			"PU", /Q, TS_PU()
			"BPMx", /Q, TS_BPMx()
			"BPMy", /Q, TS_BPMy()
			"VA", /Q, TS_VA()
		End
	End
	//"-"
	Submenu "SI Graphs"
		Submenu "Power Sources"
			"B", /Q, SI_B()
			"QF", /Q, SI_QF()
			"QD", /Q, SI_QD()
			"Q", /Q, SI_Q()
			"SFA", /Q, SI_SFA()
			"SFB", /Q, SI_SFB()
			"SFP", /Q, SI_SFP()
			"SDP", /Q, SI_SDP()
			"SDA", /Q, SI_SDA()
			"SDB", /Q, SI_SDB()
			"QS", /Q, SI_QS()
			Submenu "CH"
				"M1", /Q, SI_CH_M1()
				"M2", /Q, SI_CH_M2()
				"C1", /Q, SI_CH_C1()
				"C2", /Q, SI_CH_C2()
				"C3", /Q, SI_CH_C3()
				"C4", /Q, SI_CH_C4()
			End
			Submenu "CV"
				"M1", /Q, SI_CV_M1()
				"M2", /Q, SI_CV_M2()
				"C1", /Q, SI_CV_C1()
				"C4", /Q, SI_CV_C4()
			End
			Submenu "VA"
				"FE", /Q, SI_VA_FE()
				"CCG", /Q, SI_VA_CCG()
				"SIP20", /Q, SI_VA_SIP20()
			End
			Submenu "BPMs"
				Submenu "Horizontal"
					"M1", /Q, SI_BPMx_M1()
					"M2", /Q, SI_BPMx_M2()
					"C1-1", /Q, SI_BPMx_C1_1()
					"C1-2", /Q, SI_BPMx_C1_2()
					"C2", /Q, SI_BPMx_C2()
					"C3-1", /Q, SI_BPMx_C3_1()
					"C3-2", /Q, SI_BPMx_C3_2()
					"C4", /Q, SI_BPMx_C4()
				End
			End
				Submenu "Vertical"
					"M1", /Q, SI_BPMy_M1()
					"M2", /Q, SI_BPMy_M2()
					"C1-1", /Q, SI_BPMy_C1_1()
					"C1-2", /Q, SI_BPMy_C1_2()
					"C2", /Q, SI_BPMy_C2()
					"C3-1", /Q, SI_BPMy_C3_1()
					"C3-2", /Q, SI_BPMy_C3_2()
					"C4", /Q, SI_BPMy_C4()
				End
			End
				Submenu "Pulsed Magnets"
					"SI PU", /Q, SI_PU()
				End
		Submenu "Temperatures"
			Submenu "Vaccum Chambers"
				"SI-01", /Q, SI_PT100_VA01()
				"SI-02", /Q, SI_PT100_VA02()
				"SI-03", /Q, SI_PT100_VA03()
				"SI-04", /Q, SI_PT100_VA04()
				"SI-05", /Q, SI_PT100_VA05()
				"SI-06", /Q, SI_PT100_VA06()
				"SI-07", /Q, SI_PT100_VA07()
				"SI-08", /Q, SI_PT100_VA08()
				"SI-09", /Q, SI_PT100_VA09()
				"SI-10", /Q, SI_PT100_VA10()
				"SI-11", /Q, SI_PT100_VA11()
				"SI-12", /Q, SI_PT100_VA12()
				"SI-13", /Q, SI_PT100_VA13()
				"SI-14", /Q, SI_PT100_VA14()
				"SI-15", /Q, SI_PT100_VA15()
				"SI-16", /Q, SI_PT100_VA16()
				"SI-17", /Q, SI_PT100_VA17()
				"SI-18", /Q, SI_PT100_VA18()
				"SI-19", /Q, SI_PT100_VA19()
				"SI-20", /Q, SI_PT100_VA20()
			End
			Submenu "Magnet Temperatures"
				"Magnets", /Q, SI_MB_Temp_MAG()
				"BCs", /Q, SI_PT100_BC()
			End
			Submenu "DC-Links"
				"Quads", /Q, SI_Temp_DCLink_Quad()
				"SF", /Q, SI_Temp_DCLink_SF()
				"SD", /Q, SI_Temp_DCLink_SD()
				"Dipoles", /Q, SI_Temp_DCLink_Dipolo()
			End
			Submenu "Amb. Temperature"
				"Amb. Temperature 1", /Q, SI_Amb_Temp()
			End
		End
	End
	"-"
	"Kill All Graphs", /Q, KillAllGraphs()
	"Clear All Waves", /Q, ClearWaves()
	"BPMs to Zero", /Q, ShiftAllBPMs()
	"PS to Zero", /Q, ShiftAllPS()
	"TEMPs to Zero", /Q, ShiftAllTEMP()
	"-"
	"↺ EPICSpvlist.dat", /Q, RefreshEPICSpvlist()
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
	string PVsFile_

	PathInfo EPICS_Tools
	if (V_Flag == 1)
		PVsFile_ = S_path + PVsFile
	else
		print "Problems finding EPICSpvlist.dat"
		return 0
	endif
	KillVariables/Z V_Flag
	KillStrings/Z S_path

	for(i=0;ItemsInList(wfilter)>i;i+=1)
		Grep/O/E=StringFromList(i,wfilter) PVsFile_ as wGrepRes //pesquiso filtros no arquivo de PVs
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
	string PVsFile_

	PathInfo EPICS_Tools
	if (V_Flag == 1)
		PVsFile_ = S_path + PVsFile
	else
		print "Problems finding EPICSpvlist.dat"
		return 0
	endif
	KillVariables/Z V_Flag
	KillStrings/Z S_path

	for(i=0;ItemsInList(wfilter)>i;i+=1)
		Grep/O/E=StringFromList(i,wfilter) PVsFile_ as wGrepRes //pesquiso filtros no arquivo de PVs
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
			Redimension/N=2 $wname
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

//Baixa lista com todas PVs do Archiver
Function RefreshEPICSpvlist()
	SVAR/Z gGetAllPVsURL = root:GlobalVariables:gGetAllPVsURL
	//GetAllPVs("http://10.0.38.42/retrieval/bpl/getMatchingPVs?pv=*&limit=-1")
	GetAllPVs_(gGetAllPVsURL)
End

//Essa função gera uma lista com todas as PVs do Archiver
Function GetAllPVs_(url)
	string url
	string data
	wave/T wAllPVsList = root:VarList:wAllPVsList
	SVAR/Z PVsFile = root:GlobalVariables:gPVsfile
	variable refnum, i, offset, totalpvs, multiplier
	variable ten_perc
	string filename

//	data = FetchURL("https://ais-eng-srv-ta.cnpem.br/mgmt/bpl/getAllPVs?limit=-1")
	data = FetchURL(url)
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
		print "[===================================================================================================]"
		ToCommandLine "    ["
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
		Save/O/G/M="\r\n"/P=EPICS_Tools wAllPVsList as PVsFile
		print("Data Saved to Disk!")
	endif
End
