; Focus the Brave window
IfWinExist, ahk_class Chrome_WidgetWin_1
{
    WinActivate ; Activate the Brave window
    WinWaitActive, ahk_class Chrome_WidgetWin_1
}

; Now send the commands to toggle the bookmarks bar
Send, !e    ; Opens the "Settings and more" menu (Alt+E)
Sleep, 50  ; Waits for the menu to open
Send, l     ; Selects the "Bookmarks" menu
Send, {Enter}
Sleep, 50  ; Waits for the submenu to open
Send, l     ; Show menu
Send, {Enter}
Send, i     ; Send "always"
Send, {Enter}
return