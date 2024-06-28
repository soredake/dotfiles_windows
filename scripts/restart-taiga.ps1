$host.ui.RawUI.WindowTitle = "Restarting Taiga"
taskkill /f /T /im taiga.exe
Start-Sleep -Seconds 60
Start-Process -FilePath "$env:APPDATA\Taiga\Taiga.exe" -WorkingDirectory "$env:APPDATA\Taiga\data\db"
