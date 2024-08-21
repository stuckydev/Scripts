; Initialize the ListView outside the functions
Gui, Add, ListView, r20 w580 gListViewEvents, ProgramPath|Status
LV_ModifyCol(1, 480) ; Set ProgramPath width
LV_ModifyCol(2, 70)  ; Set Status width
Gui, Add, Button, w80 gSaveButton, Speichern
Gui, Add, Button, w80 gAddButton, Hinzufügen ; Add the "Add" button
Gui, Add, Button, w80 gExitButton, Beenden
Gui, Show, w600 h500, Programmstatus

LoadValidPrograms()

return

ListViewEvents:
If (A_GuiEvent = "DoubleClick") {
    selectedRow := LV_GetNext()
    If (selectedRow > 0) {
        LV_GetText(status, selectedRow, 2) ; Get the Status
        
        ; Toggle the status
        If (status = "active")
            newStatus := "inactive"
        else
            newStatus := "active"

        ; Update the "Status" column for the selected row using LV_Modify
        LV_Modify(selectedRow, "Set", , newStatus)
    }
}
return

SaveButton:
Save()
return

AddButton: ; Handle adding a new entry
InputBox, newProgramPath, Neuer Eintrag, Bitte geben Sie den Programmpfad ein:
if (newProgramPath != "") {
    newProgramStatus := "active" ; You can set the default status here
    LV_Add("", newProgramPath, newProgramStatus)
}
return

ExitButton:
Save()
ExitApp

LoadValidPrograms() {
    ; Clear the ListView to remove any previous data
    LV_Delete()

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
                        InputBox, FullPathInput, application %AppName% not found in LocalAppData - insert full path, Enter full path:

                        ; Check if the user provided a valid path
                        if (FullPathInput != "") {
                            ; Add the row with the provided full path and programStatus
                            LV_Add("", FullPathInput, programStatus)
                        } else {
                            ; Handle the case where the user cancels the input
                            ; You can add error handling or other actions as needed.
                        }
                    }
                }
            }
        }
    } else {
        MsgBox, programs.csv does not exist.
    }
}

Save() {
    FileDelete, programs.csv
    Loop, % LV_GetCount()
    {
        LV_GetText(programPath, A_Index, 1)
        LV_GetText(programStatus, A_Index, 2)
        FileAppend, % programPath ";" programStatus "`n", programs.csv
    }
    
    ; Close the GUI
    GuiClose:
    Gui, Destroy
    
    ; Exit the script
    ExitApp
}
