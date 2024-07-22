$host.ui.RawUI.WindowTitle = "Restarting qBittorrent"
taskkill /T /im qbittorrent.exe
Start-Sleep -Seconds 60
Start-Process "$env:ProgramFiles\qBittorrent\qbittorrent.exe" -WorkingDirectory "$env:ProgramFiles\qBittorrent" -WindowStyle Minimized
