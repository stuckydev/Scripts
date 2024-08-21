; Set GUI settings
Gui, Add, ListView, r20 w580 gListViewEvents, ProgramPath|Status
Gui, Add, Button, w80 gSaveButton, Speichern
Gui, Add, Button, w80 gExitButton, Beenden
Gui, Show, w600 h450, Programmstatus

; Set column widths (ProgramPath wider, Status narrower)
LV_ModifyCol(1, 480) ; Set ProgramPath width
LV_ModifyCol(2, 70)  ; Set Status width

; Load programs from the "programs.csv" file
LoadPrograms()

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
SavePrograms()
return

ExitButton:
ExitApp
return

LoadPrograms() {
    ; Clear the ListView to remove any previous data
    LV_Delete()

    if FileExist("programs.csv") {
        FileRead, programs, programs.csv
        Loop, Parse, programs, `n
        {
            programPath := SubStr(A_LoopField, 1, InStr(A_LoopField, ";") - 1)
            programStatus := SubStr(A_LoopField, InStr(A_LoopField, ";") + 1)

            ; Add the row with both columns
            LV_Add("", programPath, programStatus)
        }
    }
}

SavePrograms() {
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
