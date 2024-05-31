param (
  [string]$Action = $args[0]
)

if ($Action -eq "start") {
  # https://github.com/qbittorrent/qBittorrent/issues/8288
  taskkill /im qbittorrent.exe
  # https://github.com/syncthing/syncthing/issues/8394
  # Syncthingtray has option to stop syncthing if current connetion is metered
  #taskkill /im syncthingtray.exe
}
elseif ($Action -eq "stop") {
  Start-Process "$env:ProgramFiles\qBittorrent\qbittorrent.exe"
  #Start-Process "$env:ProgramData\chocolatey\lib\syncthingtray\tools\syncthingtray.exe"
}
else {
  Write-Output "Usage: metered-connection.ps1 start|stop"
}
