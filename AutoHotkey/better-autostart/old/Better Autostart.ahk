; Use the EnvGet command to retrieve the values of environment variables
EnvGet, LocalAppData, LocalAppData

; Define the names of the processes to kill
App1Process := "Morgen.exe"
App2Process := "Todoist.exe"
App3Process := "Notion.exe"

; Define the paths to the applications
App1Path := LocalAppData "\Programs\morgen\Morgen.exe"
App2Path := LocalAppData "\Programs\todoist\Todoist.exe"
App3Path := LocalAppData "\Programs\Notion\Notion.exe"

; Close the specified apps
WinClose, ahk_exe %App1Path%
WinClose, ahk_exe %App2Path%
WinClose, ahk_exe %App3Path%

; Loop through all processes and terminate matching ones
Process, Close, %App1Process%
Process, Close, %App2Process%
Process, Close, %App3Process%

; Function to check internet connectivity
CheckInternet() {
    ; Define the website to ping
    Website := "http://www.google.com"
    
    ; Use ComObjCreate to create a WinHttp.WinHttpRequest.5.1 object
    HttpRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    
    ; Open a GET request to the website
    HttpRequest.Open("GET", Website)
    
    ; Set a timeout in milliseconds (adjust as needed)
    HttpRequest.SetTimeouts(5000, 5000, 5000, 5000)
    
    ; Send the GET request
    HttpRequest.Send()
    
    ; Check the status code of the response
    StatusCode := HttpRequest.Status
    
    ; Return true if the status code indicates success (e.g., 200 OK)
    return StatusCode = 200
}

; Check internet connectivity
Connected := CheckInternet()

; If internet is not connected, display a message and exit the script
if (!Connected) {
    MsgBox, No internet connection.
    ExitApp
}

Sleep, 2000

; If internet is connected, start the specified apps
Run, %App1Path%
Run, %App2Path%
Run, %App3Path%