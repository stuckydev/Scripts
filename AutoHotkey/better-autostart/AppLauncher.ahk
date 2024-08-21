#SingleInstance, Force ; Ensures only one instance of the script is running

SplashTextOn, 300, 50, BetterAutostart loading...
Sleep, 100  ; Display the splash text for 1 seconds
SplashTextOff  ; Remove the splash text

; Read the CSV file into an array
FileRead, Programs, programs.csv

; Split the CSV data into lines using both newline and carriage return characters
Loop, Parse, Programs, `n`r
{
    ; Split each line into programPath and Status
    ProgramLine := StrSplit(A_LoopField, ";")

    ; Check if the program status is = 1
    If ProgramLine[1] = "1"
    {
        ; Extract the program path
        ProgramPath := ProgramLine[2]
				
            ; Start the program
            Run, %ProgramPath%
    }
}
SplashTextOn, 400, 80, Done, BetterAutostart completed!
Sleep, 100
SplashTextOff

ExitApp
