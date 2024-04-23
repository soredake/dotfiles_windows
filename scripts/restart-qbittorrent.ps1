$host.ui.RawUI.WindowTitle = "Restarting qBittorrent"
taskkill /im qbittorrent.exe
Start-Sleep -Seconds 120
Start-Process "C:\Program Files\qBittorrent\qbittorrent.exe"
