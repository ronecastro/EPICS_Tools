#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function GenOrbitProfile()
	wave/T CHnames = root:VarList:CHnames
	wave/T CVnames = root:VarList:CVnames
	wave RespMat_CH_BPMsX = root:VarList:RespMat_CH_BPMsX
	wave RespMat_CV_BPMsY = root:VarList:RespMat_CV_BPMsY
	variable i, j, k
	string Corrector_name
	
	SetDataFolder root:VarList:OrbProfiles:CHs //mudo folder para esse path
	
	for(i = 0; numpnts(CHnames) > i; i += 1) //para cada ponto da wave CHnames
		Corrector_name = ReplaceString(":", CHnames[i], "_") //altero nomes a serem usados
		Make/O/N=0 $Corrector_name //crio a wave a cada iteração
		wave Corrector = $Corrector_name //referencio a wave
		for (j = 0; j < DimSize(RespMat_CH_BPMsX, 0); j += 1) //para cada pont
			InsertPoints inf, 1, Corrector
			Corrector[inf] = RespMat_CH_BPMsX[j][i] //pego o ponto correto e insiro na wave
		endfor
	endfor
	
	SetDataFolder root:VarList:OrbProfiles:CVs //mudo folder para esse path
	
	for(i = 0; numpnts(CVnames) > i; i += 1) //mesmo que nas CHs, para CVs
		Corrector_name = ReplaceString(":", CVnames[i], "_")
		Make/O/N=0 $Corrector_name
		wave Corrector = $Corrector_name
		for (j = 0; j < DimSize(RespMat_CV_BPMsY, 0); j += 1)
			InsertPoints inf, 1, Corrector
			Corrector[inf] = RespMat_CV_BPMsY[j][i]
		endfor
	endfor
	
	SetDataFolder root:
End

Function/S Wave2TraceList_orbX() //string "H" or "V" - retorna lista com nomes das CHs e CVs
	string plane
	wave/T CHnames = root:VarList:CHnames
	wave/T CVnames = root:VarList:CVnames
	SVAR/Z gFilterOrbX = root:GlobalVariables:gFilterOrbX
	string listH = ""
	string listV = ""
	string list = ""
	variable i

	for (i=0;numpnts(CHnames)>i;i+=1)
		listH = listH + CHnames[i] + ";"
	endfor
	//for (i=0;numpnts(CVnames)>i;i+=1)
	//	listV = listH + CVnames[i] + ";"
	//endfor
	listH = ReplaceString(":", listH, "_")
	listH = GrepList(listH, gFilterOrbX)
	//listV = ReplaceString(":", listV, "_")
	//listV = GrepList(listV, gFilterOrb)
	list = listH// + listV
	
	return list
End

Function/S Wave2TraceList_orbY() //string "H" or "V" - retorna lista com nomes das CHs e CVs
	string plane
	wave/T CHnames = root:VarList:CHnames
	wave/T CVnames = root:VarList:CVnames
	SVAR/Z gFilterOrbY = root:GlobalVariables:gFilterOrbY
	string listH = ""
	string listV = ""
	string list = ""
	variable i

//	for (i=0;numpnts(CHnames)>i;i+=1)
//		listH = listH + CHnames[i] + ";"
//	endfor
	for (i=0;numpnts(CVnames)>i;i+=1)
		listV = listV + CVnames[i] + ";"
	endfor
//	listH = ReplaceString(":", listH, "_")
//	listH = GrepList(listH, gFilterOrb)
	listV = ReplaceString(":", listV, "_")
	listV = GrepList(listV, gFilterOrbY)
	list = listV //listH + listV
	
	return list
End

Function SwitchTraceX(wname)
	string wname
	string controlvaluetxt
	string controlvaluetxt_TS
	string currenttraces
	string oldtrace

	currenttraces = TraceNameList("",";",1)
	currenttraces = ReplaceString("'",currenttraces,"")
	oldtrace = stringfromlist(1,currenttraces)

	controlvaluetxt = ReplaceString(":",wname,"_")
	setDataFolder root:VarList:OrbProfiles:CHs
	ReplaceWave trace=$oldtrace, $controlvaluetxt
	SetDataFolder root:
End

Function SwitchTraceY(wname)
	string wname
	string controlvaluetxt
	string currenttraces
	string oldtrace

	currenttraces = TraceNameList("",";",1)
	currenttraces = ReplaceString("'",currenttraces,"")
	oldtrace = stringfromlist(1,currenttraces)

	controlvaluetxt = ReplaceString(":",wname,"_")
	SetDataFolder root:VarList:OrbProfiles:CVs
	ReplaceWave trace=$oldtrace, $controlvaluetxt
	SetDataFolder root:
End

Function getorbprofile() //acessado através do botão Orbit Profile em Data Analisys
	string filterXc = "^SI-(..)(C.):DI-BPM.+PosX-Mon$"
	string filterYc = "^SI-(..)(C.):DI-BPM.+PosY-Mon$"
	string filterXm = "^SI-(..)(M.):DI-BPM.+PosX-Mon$"
	string filterYm = "^SI-(..)(M.):DI-BPM.+PosY-Mon$"
	SVAR/Z PVsFile = root:GlobalVariables:gPVsfile
	wave/T bpmsx = root:VarList:bpmsx
	wave/T bpmsy = root:VarList:bpmsy
	wave/T bpmsxc = root:VarList:bpmsxc
	wave/T bpmsyc = root:VarList:bpmsyc
	wave/T bpmsxm = root:VarList:bpmsxm
	wave/T bpmsym = root:VarList:bpmsym
	wave bpmslabelx = root:VarList:bpmslabelx
	wave bpmslabely = root:VarList:bpmslabely
	wave diffBPMsX = root:VarList:diffBPMsX
	wave diffBPMsY = root:VarList:diffBPMsY
	wave/T CHnames = root:VarList:CHnames
	wave/T CVnames = root:VarList:CVnames
	variable cursorA, cursorB
	variable PointA, PointB
	string BPMnamex, BPMnamey, dest, SWaveX, SWaveY
	variable i, j, k, aux
	string firstitem, firstWaveitem, PVsFile_
	
	cursorA = NumberByKey("POINT", CsrInfo(A)) //ponto do cursor A
	cursorB = NumberByKey("POINT", CsrInfo(B)) //ponto do cursor B
	
	if (numtype(cursorA)!=2 && numtype(cursorB)!=2) //test for NaN
		if (cursorA > cursorB) //inverte cursores se necessario
			aux = cursorA
			cursorA = cursorB
			cursorB = aux
			print "Cursor positions switched... Continuing..."
		endif
		//zera waves
		DeletePoints -inf, inf, bpmsx
		DeletePoints -inf, inf, bpmsy
		DeletePoints -inf, numpnts(bpmsxc), bpmsxc
		DeletePoints -inf, numpnts(bpmsyc), bpmsyc
		DeletePoints -inf, numpnts(bpmsxm), bpmsxm
		DeletePoints -inf, numpnts(bpmsym), bpmsym
		DeletePoints -inf, numpnts(bpmslabelx), bpmslabelx
		DeletePoints -inf, numpnts(bpmslabely), bpmslabely
		DeletePoints -inf, numpnts(diffBPMsX), diffBPMsX
		DeletePoints -inf, numpnts(diffBPMsY), diffBPMsY
			
		PathInfo EPICS_Tools
		if (V_Flag == 1)
			PVsFile_ = S_path + PVsFile
		else
			print "Problems finding EPICSpvlist.dat"
			return 0
		endif
		KillVariables/Z V_Flag
		KillStrings/Z S_path
		
		Grep/O/E=(filterXc) PVsFile_ as bpmsxc
		Grep/O/E=(filterYc) PVsFile_ as bpmsyc
		Grep/O/E=(filterXm) PVsFile_ as bpmsxm
		Grep/O/E=(filterYm) PVsFile_ as bpmsym
		sort bpmsxc, bpmsxc //coloca em ordem alfanumerica
		sort bpmsxm, bpmsxm
		sort bpmsyc, bpmsyc
		sort bpmsym, bpmsym
//		InsertPoints inf, numpnts(bpmsxc)+numpnts(bpmsxm), bpmsx
//		InsertPoints inf, numpnts(bpmsyc)+numpnts(bpmsym), bpmsy
		i = 1
		j = 2
		k = 2
		InsertPoints inf, 1, bpmsx //insere um ponto na wave bpmsx
		bpmsx[0] = "SI-01M2:DI-BPM:PosX-Mon" //para este item
		InsertPoints inf, 1, bpmsy //insere um ponto na wave bpmsy
		bpmsy[0] = "SI-01M2:DI-BPM:PosY-Mon" //para este item
		do //monta lista de BPMs X e Y na ordem correta
			InsertPoints inf, 1, bpmsx
			bpmsx[inf] = bpmsxc[i-1] //wave de bpmsx recebe bpm trecho c4
			InsertPoints inf, 1, bpmsy 
			bpmsy[inf] = bpmsyc[i-1] //wave de bpmsy recebe bpm trecho c4
			string bpmx = bpmsxc[i-1] //indice começa em 1, por isso i-1
			string bpmy = bpmsyc[i-1]
			string match = "*C4*"
			if (stringmatch(bpmx, match) == 1) //se ultimo item de bpmx for do trecho c4
				if (i < 120)
					InsertPoints inf, 1, bpmsx
					bpmsx[inf] = bpmsxm[j] //insere item do trecho m (m1)
					j+=1
					InsertPoints inf, 1, bpmsx
					bpmsx[inf] = bpmsxm[j] //insere item do trecho m (m2)
					j+=1
				endif
			endif
			if (stringmatch(bpmy, match) == 1) //o mesmo para bpmy
				if (i < 120)
					InsertPoints inf, 1, bpmsy
					bpmsy[inf] = bpmsym[k]
					k+=1
					InsertPoints inf, 1, bpmsy
					bpmsy[inf] = bpmsym[k]
					k+=1
				endif
			endif
			i+=1
		while(i <= 120)
		
		InsertPoints inf, 1, bpmsx //insere ultimo item na lista
		bpmsx[inf] = "SI-01M1:DI-BPM:PosX-Mon" //para esse bpm
		InsertPoints inf, 1, bpmsy //insere ultimo item na lista
		bpmsy[inf] = "SI-01M1:DI-BPM:PosY-Mon" //para esse bpm

		i = 0
		do 
			BPMnamex = ReplaceString(":", bpmsx[i], "_") //renomeia nome do bpmsx
			if (WaveExists($BPMnamex)) //se a wave do bpmx existe
				wave/Z refBPMnamex = $BPMnamex //gero a referencia
			else	
				make $BPMnamex //senão, crio a wave
				wave/Z refBPMnamex = $BPMnamex //gero a referencia
			endif
			PointA = refBPMnamex[cursorA] //seleciono valor do ponto A
			PointB = refBPMnamex[cursorB] //seleciono valor do ponto A
			InsertPoints i, 1, diffBPMsX //insero ponto na wave diffBPMsX
			diffBPMsX[i] = PointB - PointA //preencho com valor
			i += 1
		while(i < numpnts(bpmsx))
		
		i = 0
		do
			BPMnamey = ReplaceString(":", bpmsy[i], "_") //renomeia nome do bpmsy
			if (WaveExists($BPMnamey))
				wave/Z refBPMnamey = $BPMnamey
			else	
				make $BPMnamey
				wave/Z refBPMnamey = $BPMnamey
			endif
			PointA = refBPMnamey[cursorA]
			PointB = refBPMnamey[cursorB]
			InsertPoints i, 1, diffBPMsY
			diffBPMsY[i] = PointB - PointA
			i += 1
		while(i < numpnts(bpmsy))
		
		SWaveX = ReplaceString(":",CHnames[0], "_")
		SWaveY = ReplaceString(":",CVnames[0], "_")
		
		for(i=0;i<numpnts(bpmsx);i+=1)
			InsertPoints/V=(i) inf, 1, bpmslabelx
		endfor
		for(i=0;i<numpnts(bpmsy);i+=1)
			InsertPoints/V=(i) inf, 1, bpmslabely
		endfor
		
		if (numpnts(bpmsx) == numpnts(diffBPMsX)) //Cria gráfico para X
			Display/N=OrbProfile /W=(19.5,38.75,1322.25,266) diffBPMsX
			ModifyGraph mode=4,marker=19
			ModifyGraph tkLblRot(bottom)=90,userticks(bottom)={root:VarList:bpmslabelx,root:VarList:bpmsx}
			ModifyGraph fSize(bottom)=7
			ModifyGraph grid(bottom)=1,gridRGB(bottom)=(65535,49151,49151)
			AppendToGraph/R root:VarList:OrbProfiles:CHs:'SI-01M2_PS-CH'
			ModifyGraph mode=4,marker=19,rgb('SI-01M2_PS-CH')=(65535,49151,49151)
			ControlBar 40
			PopupMenu puOrbList,pos={9.00,10.00},size={279.00,17.00},bodyWidth=200,title="Orbit Profile:  "
			PopupMenu puOrbList,mode=1,popvalue=SWaveX,value=Wave2TraceList_orbX() //WaveList("!*_TS", ";", "")
			PopupMenu puOrbList proc=PopMenuProc_SwitchOrbProfileX
			SetVariable svOrbList title="Filter:  ",size={224.00,17.00},bodyWidth=180,pos={320.00,10.00}
			SetVariable svOrbList help={"Hints:\r(.) = one character;\r(.+) = one or more characters;\r(.*) = zero or more characters;\r(^) = 'start with' character;\r($) = 'end with' character;\rEx: ^SI-02.+CCG-...:Pressure-Mon$\rEx: ^SI-....:DI-BPM.*:PosX-Mon$"}
			SetVariable svOrbList,value= root:GlobalVariables:gFilterOrbX
			Legend/C/N=text1/J/A=MC/X=-3.26/Y=-68.42 "\\s(diffBPMsX) diffBPMsX - Orbit Profile\r\\s('SI-01M2_PS-CH') 'SI-01M2_PS-CH' - Horizontal Profile"
		endif
		
		if (numpnts(bpmsy) == numpnts(diffBPMsY)) //Cria gráfico para Y
			Display /W=(19.5,287,1322.25,514.25) diffBPMsY
			ModifyGraph mode=4,marker=19
			ModifyGraph rgb=(0,0,65535)
			ModifyGraph tkLblRot(bottom)=90,userticks(bottom)={root:VarList:bpmslabely,root:VarList:bpmsy}
			ModifyGraph fSize(bottom)=7
			ModifyGraph grid(bottom)=1,gridRGB(bottom)=(65535,49151,49151)
			AppendToGraph/R root:VarList:OrbProfiles:CVs:'SI-01C1_PS-CV'
			ModifyGraph mode=4,marker=19,rgb('SI-01C1_PS-CV')=(32768,40777,65535)
			ControlBar 40
			PopupMenu puOrbListY,pos={9.00,10.00},size={279.00,17.00},bodyWidth=200,title="Orbit Profile:  "
			firstitem = stringfromlist(0, Wave2TraceList_orbY())
			PopupMenu puOrbListY,mode=1,value=Wave2TraceList_orbY() //WaveList("!*_TS", ";", "")
			PopupMenu puOrbListY proc=PopMenuProc_SwitchOrbProfileY
			SetVariable svOrbListY title="Filter:  ",size={224.00,17.00},bodyWidth=180,pos={320.00,10.00}
			SetVariable svOrbListY help={"Hints:\r(.) = one character;\r(.+) = one or more characters;\r(.*) = zero or more characters;\r(^) = 'start with' character;\r($) = 'end with' character;\rEx: ^SI-02.+CCG-...:Pressure-Mon$\rEx: ^SI-....:DI-BPM.*:PosX-Mon$"}
			SetVariable svOrbListY,value= root:GlobalVariables:gFilterOrbY
			Legend/C/N=text1/J/A=MC/X=-3.26/Y=-68.42 "\\s(diffBPMsY) diffBPMsY - Orbit Profile\r\\s('SI-01C1_PS-CV') 'SI-01C1_PS-CV' - Horizontal Profile"
		endif
	else
		print "Select interest points using the marker A before B. Shortcut Ctrl + I on the graph."
	endif
End