; first, check internet connectivity

    Website := "http://www.google.com"
    HttpRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    
    ; Use try-catch to handle HTTP request errors without aborting the script
    try {
        HttpRequest.Open("GET", Website)
        HttpRequest.SetTimeouts(5000, 5000, 5000, 5000)
        HttpRequest.Send()
        StatusCode := HttpRequest.Status
    } catch {
        ; An error occurred during the HTTP request
        return false }
    ; Return true if the status code is 200 (OK), indicating internet connectivity
    return StatusCode = 200
	
; Read the CSV file into an array
FileRead, Programs, programs.csv

; Split the CSV data into lines using both newline and carriage return characters
Loop, Parse, Programs, `n`r
{
    ; Split each line into programPath and Status
    ProgramLine := StrSplit(A_LoopField, ";")

    ; Check if the program is active = true
    If ProgramLine[2] = "true"
    {
        ; Extract the program path
        ProgramPath := ProgramLine[1]

        ; Close all instances of the program
        Process, Close, %ProgramPath%
		Sleep, 1000

        ; Extract the program name (filename)
        ProgramName := SubStr(ProgramPath, InStr(ProgramPath, "\")+1)

        ; Kill all processes with the same name
        Process, Exist, %ProgramName%
		Sleep, 1000
        If ErrorLevel
        {
            Process, Close, %ProgramName%
        }
		
        ; Check internet connectivity
        If StatusCode = 200
        {
            ; Start the program
            Run, %ProgramPath%
        }
    }
}
ExitApp
