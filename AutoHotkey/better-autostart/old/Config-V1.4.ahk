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

return

AddButton: ; Handle adding a new entry
    InputBox, newProgramPath, Neuer Eintrag, bitte Pfad eingeben:
    if (newProgramPath != "") {
        newProgramStatus := "active" ; default status
        LV_Add("", newProgramPath, newProgramStatus)
    }
return

LoadValidPrograms() {
    LV_Delete() ; Clear the ListView

    if FileExist("programs.csv") {
        FileRead, programs, programs.csv
        Loop, Parse, programs, `n {
            programPath := SubStr(A_LoopField, 1, InStr(A_LoopField, ";") - 1)
            programStatus := SubStr(A_LoopField, InStr(A_LoopField, ";") + 1)

            ; Check if both programPath and programStatus are not empty
            if (programPath != "" && programStatus != "") {
                ; Check if programPath represents a valid file path
                if FileExist(programPath) {
                    ; Add the row with the full path and programStatus
                    LV_Add("", programPath, programStatus)
                } else {
                    ; Call LoadProgramsWithNamesOnly for entries that are not file paths
                    LoadProgramsWithNamesOnly(programPath, programStatus)
                }
            }
        }
    } else {
        MsgBox, programs.csv does not exist.
    }
}

LoadProgramsWithNamesOnly(programPath, programStatus) {
    ; Build the full path based on the application name
    AppName := StrReplace(programPath, ".exe", "") ; Remove .exe extension
    FullPath := LocalAppData "\Programs\" AppName "\" AppName ".exe"

    ; Check if the file exists at the generated path
    if FileExist(FullPath) {
        ; Add the row with the full path and programStatus
        LV_Add("", FullPath, programStatus)
    } else {
        ; Handle the case where the file doesn't exist at the generated path
        ; Display an input box to request the full path from the user
        InputBox, FullPathInput, Application %AppName% not found in LocalAppData - Enter full path:

        ; Check if the user provided a valid path
        if (FullPathInput != "") {
            ; Add the row with the provided full path and programStatus
            LV_Add("", FullPathInput, programStatus)
        }
    }
}

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