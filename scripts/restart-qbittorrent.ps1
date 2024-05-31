$host.ui.RawUI.WindowTitle = "Restarting qBittorrent"
taskkill /im qbittorrent.exe
Start-Sleep -Seconds 10
Start-Process "$env:ProgramFiles\qBittorrent\qbittorrent.exe"
