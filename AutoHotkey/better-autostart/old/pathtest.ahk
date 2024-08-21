; Replace 'YourAppName' with the actual name of the application you're looking for
AppName := "YourAppName"

; Function to check if a string contains special characters
ContainsSpecialChars(str) {
    ; Define a list of allowed characters (letters, numbers, and underscores)
    AllowedChars := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_.-"
    
    ; Loop through each character in the string
    Loop, Parse, str
    {
        ; If the character is not in the list of allowed characters, return true
        if !InStr(AllowedChars, A_LoopField)
            return true
    }
    
    ; If no special characters were found, return false
    return false
}

; Check if AppName contains special characters
if ContainsSpecialChars(AppName) {
    ; If special characters are found, you can add any code here to handle the situation.
} else {
    ; Build the full path
    FullPath := A_AppData "\Local\Programs\" AppName "\" AppName ".exe"
}
