#SingleInstance, Force ; Ensures only one instance of the script is running

; Check internet connectivity
Website := "http://www.google.com"
HttpRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")

try {
    HttpRequest.Open("GET", Website)
    HttpRequest.SetTimeouts(5000, 5000, 5000, 5000)
    HttpRequest.Send()
    
    ; Check if the internet is connected
    if HttpRequest.Status = 200 {
        ; Internet is connected, continue with your script
    } else {
        ; No internet connection
        SplashTextOn, 300, 50, No Internet!, No internet connection.
        Sleep, 4000  ; Display the splash text for 4 seconds
        SplashTextOff  ; Remove the splash text
    }
} catch {
    ; An error occurred during the HTTP request (No internet connection)
    SplashTextOn, 300, 50, No Internet!, No internet connection.
    Sleep, 4000  ; Display the splash text for 4 seconds
    SplashTextOff  ; Remove the splash text
}

SplashTextOn, 300, 50, BetterAutostart loading...
Sleep, 1000  ; Display the splash text for 1 seconds


; Read the CSV file into an array
FileRead, Programs, programs.csv

SplashTextOff  ; Remove the splash text

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
		
		; Close all instances of the program
		SplashTextOn, 800, 100, Closing program..., %ProgramPath%
        WinClose, ahk_exe %ProgramPath%
		Sleep, 1000
		SplashTextOff
		
		; Extract the program name (filename without filetype)
		ProgramName := RegExReplace(ProgramPath, "^.+\\([^\\]+)$", "$1")
		
		; Kill all processes with the same name
		SplashTextOn, 800, 100,  Killing process..., KILL all: %ProgramName%
		Process, Exist, %ProgramName%
		If ErrorLevel
        {
            Process, Close, %ProgramName%
        }
		Sleep, 1000
		SplashTextOff
		
		Sleep, 1000
        ; Check internet connectivity
        If HttpRequest.Status = 200
        {
            ; Start the program
            Run, %ProgramPath%
        }
    }
}
ExitApp
