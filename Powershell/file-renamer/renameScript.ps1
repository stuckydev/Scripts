# Setzen Sie den Pfad zum Ordner, in dem das Skript selbst liegt
$SkriptVerzeichnis = Split-Path -Parent $MyInvocation.MyCommand.Path

# Setzen Sie den Pfad zum Ordner, der umbenannt werden soll
$OrdnerPfad = $SkriptVerzeichnis

# Setzen Sie den Pfad zur Textdatei, die die Umbenennungsliste enth�lt
$UmbenennungslistePfad = Join-Path -Path $OrdnerPfad -ChildPath "renameList.txt"

# Lesen Sie die Umbenennungsliste in eine Array-Variable ein
$Umbenennungsliste = Get-Content -Path $UmbenennungslistePfad

# Schleife durch die Liste und f�hren Sie die Umbenennungen durch
foreach ($Umbenennung in $Umbenennungsliste) {
    # Trennen Sie den alten Pfad und den neuen Pfad anhand des Kommas auf
    $Umbenennungsteile = $Umbenennung.Split(",")

    # Setzen Sie den alten Pfad und den neuen Pfad
    $AlterPfad = $Umbenennungsteile[0]
    $NeuerPfad = $Umbenennungsteile[1]

    # Ersetzen Sie die Sonderzeichen in den Pfaden
    $AlterPfad = $AlterPfad -replace "�", "ae" -replace "�", "oe" -replace "�", "ue"
    $NeuerPfad = $NeuerPfad -replace "�", "ae" -replace "�", "oe" -replace "�", "ue"

    # F�hren Sie die Umbenennung durch
    Rename-Item -Path $AlterPfad -NewName $NeuerPfad -ErrorAction SilentlyContinue

    # �berpr�fen Sie, ob die Umbenennung erfolgreich war
    if (Test-Path $NeuerPfad) {
        Write-Output "Umbenennung von '$AlterPfad' zu '$NeuerPfad' erfolgreich."
    } else {
        Write-Output "Umbenennung von '$AlterPfad' zu '$NeuerPfad' fehlgeschlagen."
    }
}
# Halten Sie das PowerShell-Fenster offen, um zu verhindern, dass es sich sofort schlie�t
Read-Host -Prompt "Dr�cken Sie die Eingabetaste, um das Fenster zu schlie�en."