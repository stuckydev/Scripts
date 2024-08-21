VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "DieseArbeitsmappe"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub Workbook_Open()

    ' *** Backup Feature: Begin ***
    On Error Resume Next  ' Verhindert, dass Fehlermeldungen angezeigt werden
    
    Dim oneDriveFolder As String
    Dim backupFolder As String
    Dim backupFileName As String
    Dim currentFileName As String
    Dim currentDateTime As String

    ' Name des aktuellen Workbooks
    currentFileName = ThisWorkbook.Name

    ' Holen des OneDrive for Business Pfades
    oneDriveFolder = Environ("OneDriveCommercial") & "\"

    ' Wenn OneDrive for Business gefunden wurde
    If Len(oneDriveFolder) > 0 Then
        ' °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° HIER CODE ANPASSEN PFAD °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
        ' Setze den Pfad für den Backup-Ordner
        backupFolder = oneDriveFolder & "Backups_" & currentFileName & "\"
        ' °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

        ' Erstelle den Backup-Ordner, falls er nicht existiert
        If Dir(backupFolder, vbDirectory) = "" Then
            MkDir backupFolder
        End If

        ' Erstelle den aktuellen Datum und Zeit String
        currentDateTime = Format(Now, "yyyymmdd_HHMMSS")

        ' Erstelle den Namen der Backup-Datei
        backupFileName = backupFolder & Left(currentFileName, Len(currentFileName) - 5) & "_" & currentDateTime & ".xlsm"

        ' Speichere eine Kopie des Workbooks im OneDrive-Ordner
        ThisWorkbook.SaveCopyAs backupFileName
        
        ' Schreibe das Datum und die Zeit des letzten Backups in die Zelle A2 auf dem Blatt "Home"
        Worksheets("Home").Range("A2").Value = "Letztes Backup: " & Format(Now, "dd.mm.yyyy, HH:MM")
    End If

    On Error GoTo 0  ' Deaktiviert den Fehlerbehandlungsmodus
    ' *** Backup Feature: End ***

    ' Hier können weitere Makros eingefügt werden, die beim Öffnen der Datei ausgeführt werden sollen

End Sub

Private Sub Workbook_BeforeSave(ByVal SaveAsUI As Boolean, Cancel As Boolean)
    ' Überprüft die Umgebungsvariable "OneDriveCommercial"
    Dim onedrivePath As String
    onedrivePath = Environ("OneDriveCommercial")
    
    ' °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° HIER CODE ANPASSEN PFAD °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
    ' Nur fortfahren, wenn die Umgebungsvariable mit "OneDrive - StuCon GmbH" endet
    If Right(onedrivePath, Len("OneDrive - StuCon GmbH")) = "OneDrive - StuCon GmbH" Then
        ' Ruft die Export-Funktion auf und übergibt den OneDrive-Pfad
        Call ExportVisualBasicCode(onedrivePath)
    ' °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
    End If
End Sub

Public Sub ExportVisualBasicCode(ByVal onedrivePath As String)
    ' Definiert Konstanten für die verschiedenen Typen von VBA-Komponenten
    Const Module = 1          ' Standardmodul (.bas)
    Const ClassModule = 2     ' Klassenmodul (.cls)
    Const Form = 3            ' UserForm (.frm)
    Const Document = 100      ' Dokumentmodul (z.B. DieseArbeitsmappe, Sheet1)
    Const Padding = 24        ' Abstand für die Debug-Ausgabe (Kosmetik)

    ' Deklariert Variablen
    Dim VBComponent As Object  ' Objektvariable für jede VBA-Komponente
    Dim count As Integer       ' Zähler für exportierte Dateien
    Dim path As String         ' Pfad für jede exportierte Datei
    Dim directory As String    ' Verzeichnis, in das die Dateien exportiert werden
    Dim extension As String    ' Dateierweiterung basierend auf dem Typ der Komponente
    Dim fso As New FileSystemObject ' Objekt zum Arbeiten mit dem Dateisystem
    
    ' °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°° HIER CODE ANPASSEN PFAD °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
    ' Definiert das Exportverzeichnis im OneDrive-Pfad
    directory = onedrivePath ' & "\Tool xyz\VBA"
    count = 0  ' Initialisiert den Zähler
    ' °°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°

    ' Überprüft, ob das Verzeichnis existiert, und erstellt es bei Bedarf
    If Not fso.FolderExists(directory) Then
        Call fso.CreateFolder(directory)
    End If
    Set fso = Nothing  ' Setzt das FileSystemObject auf "Nothing" zur Bereinigung

    ' Durchläuft alle VBA-Komponenten im aktuellen Workbook
    For Each VBComponent In ActiveWorkbook.VBProject.VBComponents
        ' Bestimmt die Dateierweiterung basierend auf dem Typ der Komponente
        Select Case VBComponent.Type
            Case ClassModule, Document
                extension = ".cls"  ' Klassenmodul oder Dokumentmodul
            Case Form
                extension = ".frm"  ' UserForm
            Case Module
                extension = ".bas"  ' Standardmodul
            Case Else
                extension = ".txt"  ' Fallback für unbekannte Typen (sehr selten)
        End Select
            
        On Error Resume Next  ' Ignoriert Fehler, um die Schleife fortzusetzen
        Err.Clear  ' Löscht vorherige Fehler

        ' Setzt den vollständigen Pfad für die zu exportierende Datei
        path = directory & "\" & VBComponent.Name & extension
        
        ' Exportiert die Komponente in eine Datei
        Call VBComponent.Export(path)
        
        ' Überprüft, ob beim Exportieren ein Fehler aufgetreten ist
        If Err.Number <> 0 Then
            Call MsgBox("Fehler beim Export von " & VBComponent.Name & " nach " & path, vbCritical)
        Else
            count = count + 1  ' Erhöht den Zähler für erfolgreiche Exporte
            Debug.Print "Exportiert " & Left$(VBComponent.Name & ":" & Space(Padding), Padding) & path
        End If

        On Error GoTo 0  ' Fehlerbehandlung ein
    Next
End Sub
