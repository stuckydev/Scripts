#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force ; ensures no multiple runs at the same time
SetTitleMatchMode, 3  ; ensures that Title matches exactly WinTitle

; Display SplashScreen (Image)
	SplashImage, splash-mtg.jpg, B1

; Starting Up the Apps
	; Run, C:\Program Files (x86)\Overwolf\OverwolfLauncher.exe, , Min
	Run, C:\Users\STC\AppData\Local\Programs\untapped-companion\Untapped.gg Companion.exe, , Min
	Run, C:\Users\STC\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\17Lands.com\17Lands MTGA Client.appref-ms
	Run, steam://rungameid/2141910
Sleep,8000
WinClose, Untapped.gg
; WinClose, Overwolf Appstore
; WinClose, MTGA Assistant
Sleep, 600
SplashImage, Off
WinActivate, MTGA
Sleep, 5000
; WinClose, MTGA Assistant
Sleep, 6000
; By exiting MTGA → closing all the Apps
	WinWaitClose, MTGA
	Sleep, 800
	; ask, if Addons should be killed
	MsgBox, 1, , Press OK to close MTGA Addons
IfMsgBox, OK
	{
	Sleep, 30000
	; Process, Close, Overwolf.exe
	Process, Close, Untapped.gg Companion.exe
	Process, Close, 17Lands MTGA Client.exe
	}
IfMsgBox, Cancel
    {
	; WinActivate, MTGA Assistant
	ExitApp
	}

Return