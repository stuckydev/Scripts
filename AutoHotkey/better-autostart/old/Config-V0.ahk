#NoEnv
#SingleInstance Force
SetWorkingDir, %A_ScriptDir%

; Create the GUI
Gui, Add, Checkbox, vCheck%A_LoopField%, %A_LoopField%

Sleep, 2000

; Initialize the checkboxes
Loop, Parse, %A_ScriptDir%\programs.txt, `n
{
    ; Check the checkbox if the program is active
    GuiControl, Check, vCheck%A_LoopField%, 1
}

; Event handler for the checkbox
GuiAdd, Event, OnCheck, CheckHandler, vCheck*

Gui, Show, AutoSize, Programme

; Function to handle the checkbox event
CheckHandler(CheckboxName)
{
    ; Get the value of the checkbox
    Local CheckValue := GuiControlGet, Value, %CheckboxName%

    ; Check if the checkbox is checked
    If CheckValue
    {
        ; Write the value to the config file
        ConfigWrite("Active", %CheckboxName%, 1)
    }
    Else
    {
        ; Write the value to the config file
        ConfigWrite("Active", %CheckboxName%, 0)
    }
}