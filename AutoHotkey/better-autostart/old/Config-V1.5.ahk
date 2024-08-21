#SingleInstance, Force ; Ensures only one instance of the script is running

; Set GUI settings
Gui, Add, ListView, r20 w580 gListViewEvents, ProgramPath|Status
Gui, Add, Button, w80 gSaveButton, Save
Gui, Add, Button, w80 gAddButton, Add
Gui, Add, Button, w80 gDeleteButton, Delete
Gui, Add, Button, w80 gExitButton, Cancel
Gui, Show, w600 h500, Programmstatus

; Set column widths (ProgramPath wider, Status narrower)
LV_ModifyCol(1, 480) ; Set ProgramPath width
LV_ModifyCol(2, 70)  ; Set Status width

; Load programs from the "programs.csv" file
LoadPrograms()

return

ListViewEvents(itemID) {
    If (A_EventInfo = "DoubleClick") {
        LV_GetText(status, itemID, 2) ; Get the Status

        ; Toggle the status
        If (status = "active")
            newStatus := "inactive"
        else
            newStatus := "active"

        ; Update the "Status" column for the selected row using LV_Modify
        LV_Modify(itemID, "Set", , newStatus)
    }
}

SaveButton:
    Save()
return

AddButton: ; Handle adding a new entry
    InputBox, newProgramPath, Bitte Pfad eingeben:
    if (newProgramPath != "") {
        newProgramStatus := "active" ; default status
        LV_Add("", newProgramPath, newProgramStatus)
    }
return

DeleteButton: ; Handle deleting the selected row with confirmation
    LV_GetText(selectedRow, "Selected")
    If (selectedRow != "") {
        InputBox, deleteConfirmation, Delete Entry, Are you sure you want to delete this entry? (Yes/No)
        If (deleteConfirmation = "Yes") {
            LV_Delete(selectedRow) ; Delete the selected row
        }
    }
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

            ; Check if both programPath and programStatus are not empty
            if (programPath != "" && programStatus != "") {
                ; Add the row with both columns
                LV_Add("", programPath, programStatus)
            }
        }
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
    ; Exit the script
    ExitApp
}
