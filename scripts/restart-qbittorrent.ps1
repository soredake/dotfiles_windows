$host.ui.RawUI.WindowTitle = "Restarting qBittorrent"
taskkill /im qbittorrent.exe
Start-Sleep -Seconds 90
Start-Process "C:\Program Files\qBittorrent\qbittorrent.exe"
