#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance Force
SetWorkingDir, %A_ScriptDir% ; Ensures a consistent starting directory.

; Read the list of programs from the text file
FileOpen, txtFile, programs.txt, r
Loop, Parse, txtFile, `n
{
    ; Get the program path
    ProcessPath := %A_LoopField%

    ; Check if the program is active
    Active := ConfigRead("Active", ProcessPath)

    ; Close the program if it is active
    If Active
    {
        ProcessClose, %ProcessPath%
    }
}
FileClose, txtFile

; Start the programs
Loop, Parse, txtFile, `n
{
    ; Get the program path
    ProcessPath := %A_LoopField%

    ; Check if the program is active
    Active := ConfigRead("Active", ProcessPath)

    ; Start the program if it is active
    If Active
    {
        Run, %ProcessPath%
    }
}