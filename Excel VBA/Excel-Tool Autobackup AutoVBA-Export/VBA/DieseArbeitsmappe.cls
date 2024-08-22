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
    ' Überprüfen, ob in der Zelle B5 des Blatts "Settings" der Wert "On" ist.
    If ThisWorkbook.Sheets("Settings").Range("B5").Value = "On" Then
    
        On Error Resume Next  ' Verhindert, dass Fehlermeldungen angezeigt werden
        
        Dim oneDriveFolder As String
        Dim backupFolder As String
        Dim backupFileName As String
        Dim currentFileName As String
        Dim currentDateTime As String
        Dim customBackupPath As String
    
        ' Name des aktuellen Workbooks
        currentFileName = ThisWorkbook.Name
    
        ' Holen des OneDrive for Business Pfades
        oneDriveFolder = Environ("OneDriveCommercial") & "\"
    
        ' Prüfen, ob in B6 ein Pfad angegeben ist
        customBackupPath = ThisWorkbook.Sheets("Settings").Range("B6").Value
        
        ' Wenn B6 nicht leer ist, nutze den Pfad aus B6 als Backup-Pfad
        If Len(customBackupPath) > 0 Then
            backupFolder = customBackupPath
        Else
            ' Wenn OneDrive for Business gefunden wurde
            If Len(oneDriveFolder) > 0 Then
                ' Setze den Pfad für den Backup-Ordner
                backupFolder = oneDriveFolder & "Backups_" & currentFileName & "\"
            End If
        End If
    
        ' Erstelle den Backup-Ordner, falls er nicht existiert
        If Len(backupFolder) > 0 And Dir(backupFolder, vbDirectory) = "" Then
            MkDir backupFolder
        End If
    
        ' Erstelle den aktuellen Datum und Zeit String
        currentDateTime = Format(Now, "yyyymmdd_HHMMSS")
    
        ' Erstelle den Namen der Backup-Datei
        backupFileName = backupFolder & Left(currentFileName, Len(currentFileName) - 5) & "_" & currentDateTime & ".xlsm"
    
        ' Speichere eine Kopie des Workbooks im festgelegten Backup-Ordner
        ThisWorkbook.SaveCopyAs backupFileName
            
        ' Schreibe das Datum und die Zeit des letzten Backups in die Zelle A2 auf dem Blatt "Home"
        Worksheets("Home").Range("A2").Value = "Letztes Backup: " & Format(Now, "dd.mm.yyyy, HH:MM")
    
        On Error GoTo 0  ' Deaktiviert den Fehlerbehandlungsmodus
    
    End If
    ' *** Backup Feature: End ***

    ' Hier können weitere Makros eingefügt werden, die beim Öffnen der Datei ausgeführt werden sollen

End Sub

Private Sub Workbook_BeforeSave(ByVal SaveAsUI As Boolean, Cancel As Boolean)
    ' Überprüfen, ob in der Zelle B7 des Blatts "Settings" der Wert "On" ist.
    If ThisWorkbook.Sheets("Settings").Range("B7").Value = "On" Then
    
        ' Überprüft, ob in B8 ein Pfad angegeben ist
        Dim backupPath As String
        backupPath = ThisWorkbook.Sheets("Settings").Range("B8").Value
        
        ' Wenn B8 nicht leer ist, den Pfad verwenden
        If Len(backupPath) > 0 Then
            Call ExportVisualBasicCode(backupPath)
        End If
        
        ' Wenn B8 leer ist, wird nichts unternommen und keine Fehlermeldung ausgegeben.
    End If
End Sub

Public Sub ExportVisualBasicCode(ByVal backupPath As String)
    ' Definiert Konstanten für die verschiedenen Typen von VBA-Komponenten
    Const Module = 1          ' Standardmodul (.bas)
    Const ClassModule = 2     ' Klassenmodul (.cls)
    Const Form = 3            ' UserForm (.frm)
    Const Document = 100      ' Dokumentmodul (z.B. DieseArbeitsmappe, Sheet1)

    ' Deklariert Variablen
    Dim VBComponent As Object  ' Objektvariable für jede VBA-Komponente
    Dim path As String         ' Pfad für jede exportierte Datei
    Dim directory As String    ' Verzeichnis, in das die Dateien exportiert werden
    Dim extension As String    ' Dateierweiterung basierend auf dem Typ der Komponente
    Dim fso As New FileSystemObject ' Objekt zum Arbeiten mit dem Dateisystem
    
    ' Definiert das Exportverzeichnis im Backup-Pfad
    directory = backupPath

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

        ' Setzt den vollständigen Pfad für die zu exportierende Datei
        path = directory & "\" & VBComponent.Name & extension
        
        ' Exportiert die Komponente in eine Datei
        Call VBComponent.Export(path)

    Next
End Sub
