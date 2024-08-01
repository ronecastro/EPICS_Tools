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

function save_graph_struct()
	string win_list = ""
	string wave_list = ""
	string win = ""
	variable i, j, x, y
	string win_waves = ""
	NewPath/Z/Q/O sw_path, "C:Users:GOP:Documents:WaveMetrics:Igor Pro 8 User Files:User Procedures:saved_waves"
	// load window list for graphs
	win_list = WinList("*",";","WIN:1")
	// for each graph in list
	print(win_list)
	x = ItemsInList(win_list)
	ToCommandLine "    ["
	DoUpdate
	if (x > 0)
		for(i=0;i<x;i+=1)
			//set graph window name in variable 'WIN:'
			win = "WIN:" + stringfromlist(i,win_list)
			//get wave list in the graph window
			wave_list = WaveList("*",";", win)
			//for each wave in wave list
			y = ItemsInList(wave_list)
			ToCommandLine "="
			DoUpdate
			for(j=0;j<y;j+=1)
				win_waves = AddListItem(StringFromList(j, wave_list), win_waves)
				if ((y-j) == 1)
					ToCommandLine "|"
					DoUpdate
				endif
			endfor
		endfor
		Save/C/B/O/P=sw_path win_waves
		ToCommandLine "=]"
		DoUpdate
		Sleep 00:00:02
	endif
	End
	
	
static StrConstant kFileNameExtension = ".ibw"	
Function LoadOneFile(pathName, fileName)
    String pathName     // Name of an Igor symbolic path or "".
    String fileName         // Name of file or full path to file.
 
    // First get a valid reference to a file.
    if ((strlen(pathName)==0) || (strlen(fileName)==0))
        // Display dialog looking for file.
        Variable refNum
        Open/D=2/R/F=kFileNameExtension/P=$pathName refNum as fileName
        fileName = S_fileName           // S_fileName is set by Open/D
        if (strlen(fileName) == 0)      // User cancelled?
            return -1
        endif
    endif
    LoadWave/O /D /K=0 /A /Q /P=$pathName fileName
    Variable numWavesLoaded = V_flag            // V_flag is set by LoadWave
    if (numWavesLoaded != 1)
        Print "Error loading file - wrong number of waves loaded"
        return -1
    endif
 
	 KillVariables/Z V_flag
	 KillStrings/Z S_fileName
    return 0                            // Success
End

Function LoadAllFiles()
	 NewPath/Z/Q/O sw_path, "C:Users:GOP:Documents:WaveMetrics:Igor Pro 8 User Files:User Procedures:saved_waves"
    String pathName = "sw_path"                // Name of symbolic path or "" to get dialog
    String fileName
    Variable index=0

    Variable result
    do          // Loop through each file in folder
        fileName = IndexedFile($pathName, index, kFileNameExtension)
        if (strlen(fileName) == 0)          // No more files?
            break                                   // Break out of loop
        endif

        // Load the new data into a temporary data folder

        result = LoadOneFile(pathName, fileName)
        if (result != 0)
            String message
            sprintf message, "An error occurred while loading the file \"%s\". Aborting the load.\r", fileName
            Print message
            DoAlert 0, message
            break      
        endif
  
       
        Printf "Loaded file %d: \"%s\"\r", index, fileName

        index += 1
    while (1)

    return 0                        // Signifies success.
End

function open_graph_windows(window_list)
	string window_list
	string cmd
	variable i, x
	
	x = ItemsInList(window_list)
	for(i=0;i<x;i+=1)
		cmd = StringFromList(i, window_list) + "()"
		Execute cmd
	endfor
	
End