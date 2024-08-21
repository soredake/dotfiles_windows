$host.ui.RawUI.WindowTitle = "Restarting Taiga"
taskkill /f /im taiga.exe
Start-Process -FilePath "$env:APPDATA\Taiga\Taiga.exe" -WorkingDirectory "$env:APPDATA\Taiga\data\db" -WindowStyle Minimized
