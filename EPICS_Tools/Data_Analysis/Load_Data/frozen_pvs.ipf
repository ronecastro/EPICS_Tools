#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

//recebe lista de nomes Mnemonicos e retorna quais estão congeladas
Function/S ListFrozenPVs(pvswave)
	wave/T pvswave
	string namewave = ""
	string namewave_TS = ""
	string wave_list = ""
	int i = 0
	int j = 0
	variable y, m, d, hh, mm, ss
	int macdt
	variable frst_pnt, lst_pnt, max_pnts, sum_pnts, med, res
	for(i=0; i < numpnts(pvswave); i+=1) // para cada item na lista recebida
		namewave = pvswave[i]
		namewave = ReplaceString(":", namewave, "_")
		if (StringMatch(namewave, "*-SP"))
			continue
		endif
		if (StringMatch(namewave, "*_SP"))
			continue
		endif
		wave aux = $namewave
		if (WaveExists(aux))
			if (numpnts(pvswave) == 2)
				if (aux[0] == aux[1])
					wave_list = AddListItem(namewave, wave_list, ";", inf)
					continue
				endif
			else
				wave aux_TS = $(namewave + "_TS")
				variable diff = aux_TS[inf] - aux_TS[0]
				string datehours = SetUpStringFromMacDate(aux_TS[0])
				string datehoure = SetUpStringFromMacDate(aux_TS[inf])
				int skip = 1
				if (numpnts(aux) < (diff / 60) / 10) //se PV não variar mais que 10x/minuto
					for (j = 0; j<ItemsInList(wave_list); j+=1) 
						string w = stringfromlist(i, wave_list)
						if (stringmatch(w, namewave))
							skip = 0 //marcar para adicionar à lista
							break
						else
							skip = 1 //marcar para não adicionar
						endif
					endfor
					if (skip == 0) // se for adicionar à lista
						wave_list = AddListItem(namewave, wave_list, ";", inf)
					endif
				endif
			endif
			namewave_TS = pvswave[i] + "_TS"
			namewave_TS = ReplaceString(":", namewave_TS, "_")
			wave aux_TS = $namewave_TS
			wave nw = $namewave
			frst_pnt = nw[0]
			lst_pnt = nw[inf]
			max_pnts = numpnts(nw)
			sum_pnts = sum(nw)
			med = sum_pnts/max_pnts
			if (med == frst_pnt && med == lst_pnt)
				wave_list = AddListItem(namewave, wave_list, ";", inf)
			endif
		else
			wave_list = AddListItem(namewave + " don't exist!", wave_list, ";", inf)
		endif
	endfor
	if (CmpStr(wave_list,"") == 0)
		wave_list = "No empty wave found"
	endif
	return wave_list
End



Function getVariance(pattern)
	string pattern
	string ans
	string pv
	variable accumvar = 0
	variable i, v
	Make/T /O /N=0 foundwaves
	wave/T/Z wPVs = root:VarList:wPVs
	
	Grep /E=pattern /A wPVs as foundwaves
	
//	return numpnts(foundwaves)
	if (numpnts(foundwaves) == 0)
		return 0
	endif
	
	for(i=0;i<numpnts(foundwaves);i+=1)
		pv = ReplaceString(":", foundwaves[i], "_")
		wave temp = $pv
		v = variance(temp)
		accumvar = accumvar + v
	endfor
	
	KillWaves foundwaves
	
	return accumvar / (i+1)
End


Function isPVFrozen(pvname)
	string pvname
	variable frst_pnt, lst_pnt, max_pnts, sum_pnts, avg, res
	string aux = ReplaceString(":", pvname, "_")
	wave wname = $aux
	if (WaveExists(wname))
		if (numpnts(wname) == 1)
			return 1
		endif
		//Se wave tiver apenas dois pontos:
		if (numpnts(wname) == 2)
			if (wname[0] == wname[1])
				return 1
			else
				return 0
			endif
		else
			//Se wave tiver mais de dois pontos:
			wave wname_TS = $(pvname + "_TS")
			variable diff = wname_TS[inf] - wname_TS[0]
			string datehours = SetUpStringFromMacDate(wname_TS[0])
			string datehoure = SetUpStringFromMacDate(wname_TS[inf])
			variable pnts_wnameTS = numpnts(wname_TS)
			variable winterval = diff / 60 //intervalo em minutos
			variable variation = pnts_wnameTS / winterval //media minutos por ponto
			//Se wave variar menos que 1x/minuto:
			if (variation <= 1)
				return 1
			else
				//Testa se todos os pontos não são iguais:
				frst_pnt = wname[0]
				lst_pnt = wname[inf]
				max_pnts = numpnts(wname)
				sum_pnts = sum(wname)
				avg = sum_pnts/max_pnts
				if (avg == frst_pnt && avg == lst_pnt)
					return 1
				else
					return 0
				endif
			endif
		endif
	endif
	return 0
End



Function ButtonProc_ListFrozenPVs(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	variable i
	string aux
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			wave/Z wPVs = root:VarList:wPVs
			string frozenPVs = ListFrozenPVs(wPVs)
			print "===================================="
			print "Frozen PVS:"
			for(i=0; i < itemsinlist(frozenPVs); i+=1)
				aux = stringFromList(i, frozenPVs)
				Print aux
			endfor
			break
		case -1: // control being killed
			break
	endswitch
	return 0
End
