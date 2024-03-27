# https://github.com/qbittorrent/qBittorrent/issues/9466
taskkill /im qbittorrent.exe

# Wait for qbittorrent to shutdown
Start-Sleep -Seconds 30
