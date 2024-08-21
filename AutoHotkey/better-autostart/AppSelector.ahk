#SingleInstance, Force ; Ensures only one instance of the script is running

; Set GUI settings
Gui, Add, ListView, r20 w680 vMyListView Checked gListViewEvent, Status|ProgramPath
Gui, Add, Button, w80 gSaveButton, Save
Gui, Add, Button, w80 gAddButton, Add
Gui, Add, Button, w80 gDeleteButton, Delete
Gui, Add, Button, w80 gExitButton, Cancel

; Set column widths (ProgramPath wider, Status narrower)
LV_ModifyCol(1, 45) ; Set Status width
LV_ModifyCol(2, 600) ; Set ProgramPath width

; Load programs from the "programs.csv" file
LoadPrograms()

Gui, Show, w700 h500, Programmstatus
return

SaveButton:
    Save()
return

AddButton: ; Handle adding a new entry
    InputBox, newProgramPath, Bitte Pfad eingeben:
    if (newProgramPath != "") {
        newProgramStatus := "true" ; default status
        LV_Add("", newProgramStatus, newProgramPath)
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
    if FileExist("programs.csv") {
        FileRead, programs, programs.csv
        Loop, Parse, programs, `n
        {
            ; Extract the programStatus from the current line (before the semicolon)
            programStatus := SubStr(A_LoopField, 1, InStr(A_LoopField, ";") - 1)

            ; Extract the programPath from the current line (after the semicolon)
            programPath := SubStr(A_LoopField, InStr(A_LoopField, ";") + 1)

            ; Add the item to the ListView without specifying the checkbox state
            LV_Add("", programStatus, programPath)

            ; Determine whether to set the checkbox based on the status
            if (programStatus = "1")
                LV_Modify(A_Index, "+Check") ; Check the checkbox
            else
                LV_Modify(A_Index, "-Check") ; Uncheck the checkbox
        }
    }
}

ListViewEvent: ; Handle ListView events, including DoubleClick
    If (A_GuiEvent = "DoubleClick") {
        ; Get the Status Nr.
        LV_GetText(statusNr, A_EventInfo, 1)

        ; Toggle the status
        If (statusNr = "1")
            newStatus := "0"
        else
            newStatus := "1"

        ; Update the "Status" column for the selected row using LV_Modify
        LV_Modify(A_EventInfo, "Col1", newStatus)

        ; Toggle the checkbox
        LV_Modify(A_EventInfo, (newStatus = "1") ? "+Check" : "-Check")
    }
return


Save() {
    FileDelete, programs.csv
    Loop, % LV_GetCount()
    {
        LV_GetText(programStatus, A_Index, 1)
        LV_GetText(programPath, A_Index, 2)
        FileAppend, % programStatus ";" programPath "`n", programs.csv
    }
    ; Exit the script
    ExitApp
}

GuiClose:  ; Indicate that the script should exit automatically when the window is closed.
ExitApp
