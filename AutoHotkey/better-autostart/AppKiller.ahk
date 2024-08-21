#SingleInstance, Force ; Ensures only one instance of the script is running

; CSV-Datei in ein Array einlesen
FileRead, Programs, programs.csv

; Die CSV-Daten in Zeilen aufteilen, wobei auch Zeilenumbrüche verwendet werden
Loop, Parse, Programs, `n`r
{
    ; Jede Zeile in programPath und Status aufteilen
    ProgramLine := StrSplit(A_LoopField, ";")

    ; Überprüfen, ob der Programmstatus = 1 ist
    If ProgramLine[1] = "1"
    {
        ; Den Programm-Pfad extrahieren
        ProgramPath := ProgramLine[2]
		
		; Alle Instanzen des Programms schließen
		WinClose, ahk_exe %ProgramPath%
		Sleep, 200
		
		; Den Programmnamen (Dateiname ohne Dateityp) extrahieren
		ProgramName := RegExReplace(ProgramPath, "^.+\\([^\\]+)$", "$1")
		
		; Alle Prozesse mit dem gleichen Namen beenden
		SplashTextOn, 400, 50, Kill..., Kill %ProgramName%
		Process, Exist, %ProgramName%
		If ErrorLevel
        {
            Process, Close, %ProgramName%
        }
		Sleep, 200
		; Erneut alle Prozesse mit dem gleichen Namen beenden (manchmal nötig bspw. Morgen.exe)
		Process, Exist, %ProgramName%
		If ErrorLevel
        {
            Process, Close, %ProgramName%
        }
		SplashTextOff
    }
}
ExitApp