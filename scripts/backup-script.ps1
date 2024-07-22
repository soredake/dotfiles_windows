$host.ui.RawUI.WindowTitle = "Backup task"

$env:EHDD = (Get-Volume -FileSystemLabel "ExternalHDD").DriveLetter

# Moving unsorted files back to main folder
Get-ChildItem "$HOME\Мой диск\unsorted" -Recurse -File | ForEach-Object {
  $destFile = "$HOME\Мой диск\$($_.Name)"

  while (Test-Path $destFile) {
    $destFile = "$HOME\Мой диск\$([System.IO.Path]::GetFileNameWithoutExtension($_.Name))_$((Get-Random -Maximum 9999))$([System.IO.Path]::GetExtension($_.Name))"
  }

  Move-Item $_.FullName $destFile
}

# Software needs to be stopped to correctly backup it's data
taskkill /T /f /im run.exe
taskkill /T /f /im plex.exe
taskkill /T /f /im "Plex Media Server.exe"
taskkill /T /im Playnite.DesktopApp.exe

# https://superuser.com/questions/544336/incremental-backup-with-7zip
# Software
pwsh "$HOME\git\dotfiles_windows\scripts\backup-firefox-bookmarks.ps1"
rclone sync -P $env:LOCALAPPDATA\Plex "$HOME\Мой диск\документы\backups\plex" --delete-excluded --exclude "cache/updates/"
rclone sync -P $env:APPDATA\AIMP "$HOME\Мой диск\документы\backups\AIMP"
rclone sync -P $env:APPDATA\Taiga\data "$HOME\Мой диск\документы\backups\Taiga" --delete-excluded --exclude "db/image/" --exclude "theme/"
rclone sync -P $env:APPDATA\qBittorrent "$HOME\Мой диск\документы\backups\qbittorrent_roaming" --delete-excluded --exclude "lockfile"
rclone sync -P $env:LOCALAPPDATA\qBittorrent "$HOME\Мой диск\документы\backups\qbittorrent_local" --delete-excluded --exclude "logs/" --exclude "rss/articles/*.ico"
rclone sync -P "${env:ProgramFiles(x86)}\FanControl\Configurations" "$HOME\Мой диск\документы\backups\fancontrol"
rclone sync -P $HOME\scoop\persist\rclone "$HOME\Мой диск\документы\backups\rclone"
rclone sync -P $env:APPDATA\syncplay.ini "$HOME\Мой диск\документы\backups\syncplay"
rclone sync -P $env:APPDATA\DS4Windows "$HOME\Мой диск\документы\backups\ds4windows" --delete-excluded --exclude "Logs/"
rclone sync -P "${env:ProgramFiles(x86)}\MSI Afterburner\Profiles" "$HOME\Мой диск\документы\backups\msi_afterburner"
rclone sync -P "${env:ProgramFiles(x86)}\RivaTuner Statistics Server\Profiles" "$HOME\Мой диск\документы\backups\rtss"
rclone sync -P "$HOME\.ssh" "$HOME\Мой диск\документы\backups\ssh"

# Games and emulators
7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\backups\Playnite.7z" "$env:APPDATA\Playnite" -xr!'Playnite\library\files\*'
7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\RPCS3.7z" $env:ChocolateyToolsLocation\RPCS3\dev_hdd0\home\00000001\savedata
7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\EMPRESS.7z" "$env:PUBLIC\Documents\EMPRESS"
7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\OnlineFix.7z" "$env:PUBLIC\Documents\OnlineFix"
7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\CODEX.7z" "$env:PUBLIC\Documents\Steam\CODEX"
# 7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\PPSSPP.7z" "$documentsPath\PPSSPP"
7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\GoldbergSteamEmuSaves.7z" "$env:APPDATA\Goldberg SteamEmu Saves"
7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\ryujinx.7z" "$HOME\scoop\persist\ryujinx\portable\bis\user\save"
7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\sudachi.7z" "$HOME\scoop\apps\sudachi\current\user\nand\user\save"
# https://github.com/Abd-007/Switch-Emulators-Guide/blob/main/Yuzu.md https://github.com/Abd-007/Switch-Emulators-Guide/blob/main/Ryujinx.md
rclone sync -P $HOME\scoop\apps\sudachi\current\user\nand\system\save\8000000000000010\su\avators\profiles.dat "$HOME\Мой диск\документы\backups\sudachi"
rclone sync -P $HOME\scoop\persist\ryujinx\portable\system\Profiles.json "$HOME\Мой диск\документы\backups\ryujinx"

# Tab Session Manager backups
7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\backups\TabSessionManager.7z" "$HOME\Downloads\TabSessionManager - Backup"

# Syncthing(-tray)
rclone sync -P $env:APPDATA\syncthingtray.ini "$HOME\Мой диск\документы\backups\syncthing\pc"
rclone sync -P $env:LOCALAPPDATA\Syncthing "$HOME\Мой диск\документы\backups\syncthing\pc\syncthing" --delete-excluded --exclude "LOCK" --exclude "index*/LOG" --exclude "index*/*.log" --exclude "*.tmp.*"

# Visual Studio Code https://stackoverflow.com/a/49398449/4207635
code --list-extensions > "$HOME\Мой диск\документы\backups\vscode\extensions.txt"
rclone sync -P $env:APPDATA\Code\User\settings.json "$HOME\Мой диск\документы\backups\vscode"
rclone sync -P $env:APPDATA\Code\User\keybindings.json "$HOME\Мой диск\документы\backups\vscode"

# https://winaero.com/how-to-backup-quick-access-folders-in-windows-10
# https://aka.ms/AAr5gni
rclone sync -P $env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations "$HOME\Мой диск\документы\backups\explorer_quick_access"

# https://www.elevenforum.com/t/backup-and-restore-pinned-items-on-taskbar-in-windows-11.3630/ https://www.elevenforum.com/t/backup-and-restore-pinned-items-on-start-menu-in-windows-11.3629/
# https://aka.ms/AAnrixg
rclone sync -P $env:LOCALAPPDATA\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState "$HOME\Мой диск\документы\backups\taskbar_pinned_items\StartMenu"
rclone sync -P "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" "$HOME\Мой диск\документы\backups\taskbar_pinned_items\TaskBar"
reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" "$HOME\Мой диск\документы\backups\taskbar_pinned_items\Taskband.reg" /y

if (Test-Path -Path "${env:EHDD}:\") {
  # Backing up my google drive folder to external HDD
  # TODO: exclude курсы
  rclone sync -P --progress-terminal-title "$HOME\Мой диск" ${env:EHDD}:\main --delete-excluded --exclude ".tmp.drive*/"

  # Backing up my backups on external HDD to mega cloud
  # TODO: exclude курсы
  rclone sync -P --progress-terminal-title ${env:EHDD}:\backups mega:backups
}

# Backing up my google drive folder to mega cloud
# TODO: exclude курсы
rclone sync -P --progress-terminal-title "$HOME\Мой диск" mega:main --delete-excluded --exclude ".tmp.drive*/"

# Deduping clouds
rclone dedupe -P --dedupe-mode newest mega:/
rclone dedupe -P --dedupe-mode newest gdrive:/

# Starting killed software back
Start-Process -FilePath "$env:ProgramFiles\Plex\Plex Media Server\Plex Media Server.exe" -WindowStyle Hidden
Start-Sleep -Seconds 30
Start-Process -FilePath $HOME\scoop\apps\plex-mpv-shim\current\run.exe -WorkingDirectory $HOME\scoop\apps\plex-mpv-shim\current
Start-Sleep -Seconds 30
# NOTE: Plex For Windows cannot started minimized
# NOTE: Plex For Windows needs to be started as admin to avoid UAC prompt https://www.reddit.com/r/PleX/comments/q8un5s/is_there_any_way_to_stop_plex_from_trying_to/
Start-Process -FilePath "$env:ProgramFiles\Plex\Plex\Plex.exe" -Verb RunAs
Start-Sleep -Seconds 5
nircmd win min process Plex.exe
# Workaround for https://github.com/iamkroot/trakt-scrobbler/issues/305
trakts start --restart
