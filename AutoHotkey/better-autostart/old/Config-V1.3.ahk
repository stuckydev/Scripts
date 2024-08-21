; Use the EnvGet command to retrieve the values of environment variables
EnvGet, LocalAppData, LocalAppData

; Set GUI settings
Gui, Add, ListView, r30 w580 gListViewEvents, ProgramPath|Status
Gui, Add, Button, w80 gSaveButton, Save
Gui, Add, Button, w80 gAddButton, Add
Gui, Add, Button, w80 gExitButton, Cancel
Gui, Show, w600 h500, BetterAutostart by stucky.dev (2023)

; Set ListView column widths
LV_ModifyCol(1, 480) ; Set ProgramPath width
LV_ModifyCol(2, 70)  ; Set Status width

; Load data from CSV and validate paths
LoadData()

return

AddButton: ; Handle adding a new entry
    InputBox, newProgramPath, Neuer Eintrag, bitte Pfad eingeben:
    if (newProgramPath != "") {
        newProgramStatus := "active" ; default status
        LV_Add("", newProgramPath, newProgramStatus)
    }
return

SaveButton:
Save()
return

Save() {
    FileDelete, programs.csv
    Loop, % LV_GetCount()
    {
        LV_GetText(programPath, A_Index, 1)
        LV_GetText(programStatus, A_Index, 2)
        FileAppend, programPath ";" programStatus "`n", programs.csv
    }
    
    ; Exit the script
    ExitApp
}

ExitButton:
ExitApp
return

LoadData() {
    ; Check if the CSV file exists
    if !FileExist("programs.csv")
        return
    
    ; Read and parse the CSV file
    FileRead, csvData, programs.csv
    Loop, Parse, csvData, `n
    {
        ; Split each line by semicolon
        programInfo := StrSplit(A_LoopField, ";")
        
        ; Check if there are at least two elements in the array
        if programInfo.Length() >= 2 {
            programPath := programInfo[1]
            programStatus := programInfo[2]
            
            ; Check if the path is valid
            if !FileExist(programPath) {
                ; Call the "AppByName" function here to find the correct path
                programPath := AppByName(programPath, programStatus)
            }
            
            ; Add the program to the ListView
            LV_Add("", programPath, programStatus)
        }
    }
}

; Define your AppByName function here
AppByName(programPath, programStatus) {
    ; Replace this with your logic to find the correct path by program name
    ; You can use the programPath parameter to search for the program
    ; and return its path.
    
    ; For example, here we're just appending ".exe" to the program name:
    FullPath := LocalAppData "\Programs\" programPath ".exe"
    
    ; Check if the file exists at the generated path
    if FileExist(FullPath) {
        ; Return the generated path
        return FullPath
    } else {
        ; Handle the case where the file doesn't exist at the generated path
        ; Display an input box to request the full path from the user
        InputBox, FullPathInput, Application %programPath% not found in LocalAppData - Enter full path:

        ; Check if the user provided a valid path
        if (FullPathInput != "") {
            ; Return the provided full path
            return FullPathInput
        } else {
            ; If no path is provided, return an empty string
            return ""
        }
    }
}
