#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function/T readcfg(section, key)
	string section
	string key
	variable refNum, key_, section_
	string path, filePath, buffer, fileName
	variable True = 1
	variable False = 0
	variable UppSecFound = 0
	variable SecSearchEnd = 0
	string file  = ""
	string aux, aux1, aux2
	string currentSection = ""
	string currentKey = ""

	path = FunctionPath("")
	if (CmpStr(path[0],":") == 0)
		return ""
	endif

	path = ParseFilePath(1, path, ":", 1, 0)
	fileName = path + "config.cfg"
    
	Open/R refNum as fileName
	do
		FReadLine refNum, buffer
		if (strlen(buffer) == 0)
			Close refNum
			break
		endif
		currentSection = "[" + section + "]" + "\r"
		if (cmpstr(buffer, currentSection) == False)
			UppSecFound = True
			aux = currentSection
			if (SecSearchEnd == True)
				SecSearchEnd = True
			endif
		endif
		currentKey = key + "="
		if ((UppSecFound == True) && (SecSearchEnd == False) && (cmpstr(aux, currentSection) == False))
			if (strsearch(buffer, currentKey, 0) != -1)
				file = buffer[strlen(currentKey),inf]
				break
			endif
		endif
	while(True)
	return file
    
End