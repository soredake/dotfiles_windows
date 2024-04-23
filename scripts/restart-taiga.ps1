$host.ui.RawUI.WindowTitle = "Restarting Taiga"
taskkill /im taiga.exe
Start-Sleep -Seconds 60
Start-Process $env:APPDATA\Taiga\Taiga.exe
