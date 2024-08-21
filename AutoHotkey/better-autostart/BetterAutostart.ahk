#SingleInstance, Force

RunWait, AppKiller.ahk

; Check for internet connectivity
html := UrlDownloadToVar("http://www.google.com")
if html {
    ; Internet is working
    SplashTextOn, 300, 50, Internet connection OK!, Internet connection OK.
    Sleep, 200
    SplashTextOff
    ; Run your application (MyApp.ahk) here
    Run, AppLauncher.ahk
} else {
    ; Internet is not working
    MsgBox, Internet connection not found!
}
; Exit the script
ExitApp

UrlDownloadToVar(URL) {
    ComObjError(false)
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WebRequest.Open("GET", URL)
    WebRequest.Send()
    Return WebRequest.ResponseText
}
