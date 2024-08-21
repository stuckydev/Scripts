import pandas as pd
import os

# Pfad zur .txt-Datei, die den Ordnerpfad enthält
txt_file_path = 'Pfad.txt'

# Lese den Ordnerpfad aus der .txt-Datei
with open(txt_file_path, 'r') as file:
    folder_path = file.readline().strip()

# Sammle alle Dateipfade
file_paths = []
for root, dirs, files in os.walk(folder_path):
    for file in files:
        file_paths.append(os.path.join(root, file))

# Erstelle einen DataFrame aus den gesammelten Pfaden
df = pd.DataFrame(file_paths, columns=['Dateipfad'])

# Speichere den DataFrame in einer neuen Excel-Datei
output_excel_path = 'file_paths.xlsx'
df.to_excel(output_excel_path, index=False)

print(f'Alle Dateipfade wurden erfolgreich in {output_excel_path} gespeichert.')
