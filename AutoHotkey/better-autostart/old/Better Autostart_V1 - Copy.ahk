; Read the CSV file into an array
FileRead, Programs, programs.csv

; Split the CSV data into lines using both newline and carriage return characters
Loop, Parse, Programs, `n`r
{
    ; Split each line into programPath and Status
    ProgramLine := StrSplit(A_LoopField, ";")

    ; Check if the program is active
    If ProgramLine[2] = "active"
    {
        ; Extract the program path
        ProgramPath := ProgramLine[1]

        ; Close all instances of the program
        Process, Close, %ProgramPath%

        ; Extract the program name (filename)
        ProgramName := SubStr(ProgramPath, InStr(ProgramPath, "\")+1)

        ; Kill all processes with the same name
        Process, Exist, %ProgramName%
        If ErrorLevel
        {
            Process, Close, %ProgramName%
        }

        ; Check internet connectivity
        Website := "http://www.google.com"
        HttpRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        HttpRequest.Open("GET", Website)
        HttpRequest.SetTimeouts(5000, 5000, 5000, 5000)
        HttpRequest.Send()
        StatusCode := HttpRequest.Status

        ; If Internet available
        If StatusCode = 200
        {
            ; Start the program
            Run, %ProgramPath%
        }
        Else
        {
            MsgBox, No internet connection.
            ExitApp ; Exit the script after processing the list
        }
    }
}

ExitApp ; Ensure the script exits after processing the list
