$host.ui.RawUI.WindowTitle = "Backup task"

$env:ESSD = (Get-Volume -FileSystemLabel "ExternalSSDVentoy 256gb").DriveLetter

# Moving unsorted files back to main folder
# TODO: try foldersync v2 rename option
Get-ChildItem "$HOME\Мой диск\unsorted" -Recurse -File | ForEach-Object {
  $destFile = "$HOME\Мой диск\$($_.Name)"

  while (Test-Path $destFile) {
    $destFile = "$HOME\Мой диск\$([System.IO.Path]::GetFileNameWithoutExtension($_.Name))_$((Get-Random -Maximum 9999))$([System.IO.Path]::GetExtension($_.Name))"
  }

  Move-Item $_.FullName $destFile
}

# https://github.com/rclone/rclone/issues/3395
function check_and_clean_mega_remote {
  # Execute the rclone command and store the output
  $output = rclone about mega:

  # Check if the output contains "Free:    off"
  if ($output -match "Free:\s{4}off") {
    # Perform some actions if "Free:    off" is found
    Write-Output "Warning: No free space available on `MEGA` remote!"
    rclone cleanup --verbose --mega-hard-delete mega:
  }
  else {
    Write-Output "There is free space available on `MEGA` remote."
  }
}

# Backup spotify
Write-Output "`n`e[33mStarting spotify backup...`n`e[0m"
Push-Location "$HOME\Мой диск\документы\backups\spotify-backup"
backup-spotify
backup-spotify-json
Pop-Location

# https://superuser.com/questions/544336/incremental-backup-with-7zip
# Software
Write-Output "`n`e[33mStarting firefox bookmarks backup...`n`e[0m"
pwsh "$HOME\git\dotfiles_windows\scripts\backup-firefox-bookmarks.ps1"
Write-Output "`n`e[33mStarting software backup...`n`e[0m"
rclone sync -P $env:APPDATA\qBittorrent "$HOME\Мой диск\документы\backups\qbittorrent_roaming" --delete-excluded --exclude "lockfile"
rclone sync -P $env:LOCALAPPDATA\qBittorrent "$HOME\Мой диск\документы\backups\qbittorrent_local" --delete-excluded --exclude "logs/" --exclude "rss/articles/*.ico"
rclone sync -P "${env:ProgramFiles(x86)}\FanControl\Configurations" "$HOME\Мой диск\документы\backups\fancontrol"
rclone sync -P "$env:APPDATA\rclone\rclone.conf" "$HOME\Мой диск\документы\backups\rclone"
rclone sync -P $env:APPDATA\syncplay.ini "$HOME\Мой диск\документы\backups\syncplay"
rclone sync -P "$HOME\.ssh" "$HOME\Мой диск\документы\backups\ssh"

# Tab Session Manager backups
Write-Output "`n`e[33mStarting tab session managers sessions backup...`n`e[0m"
7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=16 -mx=5 "$HOME\Мой диск\документы\backups\TabSessionManager.7z" "$HOME\Downloads\TabSessionManager - Backup"

# Syncthing(-tray)
Write-Output "`n`e[33mStarting syncthing and syncthingtray backup...`n`e[0m"
rclone sync -P $env:APPDATA\syncthingtray.ini "$HOME\Мой диск\документы\backups\syncthing\pc"
rclone sync -P $env:LOCALAPPDATA\Syncthing "$HOME\Мой диск\документы\backups\syncthing\pc\syncthing" --delete-excluded --exclude "LOCK" --exclude "index*/LOG" --exclude "index*/*.log" --exclude "*.tmp.*"

# Visual Studio Code https://stackoverflow.com/a/49398449/4207635
Write-Output "`n`e[33mStarting visual studio code backup...`n`e[0m"
code --list-extensions > "$HOME\Мой диск\документы\backups\vscode\extensions.txt"
rclone sync -P $env:APPDATA\Code\User\settings.json "$HOME\Мой диск\документы\backups\vscode"
rclone sync -P $env:APPDATA\Code\User\keybindings.json "$HOME\Мой диск\документы\backups\vscode"

# https://winaero.com/how-to-backup-quick-access-folders-in-windows-10
# https://aka.ms/AAr5gni
Write-Output "`e[33mStarting explorer quick access links backup...`n`e[0m"
rclone sync -P $env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations "$HOME\Мой диск\документы\backups\explorer_quick_access"

# https://www.elevenforum.com/t/backup-and-restore-pinned-items-on-taskbar-in-windows-11.3630/ https://www.elevenforum.com/t/backup-and-restore-pinned-items-on-start-menu-in-windows-11.3629/
# https://aka.ms/AAnrixg
Write-Output "`n`e[33mStarting start menu and tasbar pinned programs backup...`n`e[0m"
rclone sync -P $env:LOCALAPPDATA\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState "$HOME\Мой диск\документы\backups\taskbar_pinned_items\StartMenu"
rclone sync -P "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" "$HOME\Мой диск\документы\backups\taskbar_pinned_items\TaskBar"
reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" "$HOME\Мой диск\документы\backups\taskbar_pinned_items\Taskband.reg" /y

if (Test-Path -Path "${env:ESSD}:\") {
  # Backing up my google drive folder to external SSD
  Write-Output "`n`e[33mStarting mirroring google drive folder to external disk...`n`e[0m"
  rclone sync -P --progress-terminal-title "$HOME\Мой диск" ${env:ESSD}:\main --delete-before --delete-excluded --exclude ".tmp.drive*/" --exclude-from "$HOME\Мой диск\документы\configs\rclone-gdrive-exclude-list.txt"

  # Clean mega remote if it's full
  check_and_clean_mega_remote

  # Backing up my backups on external SSD to mega cloud
  Write-Output "`n`e[33mStarting mirroring my local backups to mega cloud...`n`e[0m"
  rclone sync -P --progress-terminal-title ${env:ESSD}:\backups mega:backups --delete-before

  # Clean mega remote if it's full
  check_and_clean_mega_remote
}

# Backing up my google drive folder to mega cloud
Write-Output "`n`e[33mStarting mirroring google drive folder to mega cloud...`n`e[0m"
rclone sync -P --progress-terminal-title "$HOME\Мой диск" mega:main --delete-before --delete-excluded --exclude ".tmp.drive*/" --exclude-from "$HOME\Мой диск\документы\configs\rclone-gdrive-exclude-list.txt"
# Backing up my Documents folder to onedrive and dropbox cloud
Write-Output "`n`e[33mStarting mirroring Documents folder to onedrive and dropbox clouds...`n`e[0m"
rclone sync -P --progress-terminal-title "$HOME\Мой диск\документы" onedrive:main --delete-before --delete-excluded --exclude-from "$HOME\Мой диск\документы\configs\rclone-onedrive-dropbox-exclude-list.txt"
rclone sync -P --progress-terminal-title "$HOME\Мой диск\документы" dropbox:main --delete-before --delete-excluded --exclude-from "$HOME\Мой диск\документы\configs\rclone-onedrive-dropbox-exclude-list.txt"

# Clean mega remote if it's full
check_and_clean_mega_remote

# Deduping clouds
Write-Output "`n`e[33mStarting dedupe process for all clouds...`n`e[0m"
rclone dedupe -P --dedupe-mode newest mega:/
rclone dedupe -P --dedupe-mode newest gdrive:/
rclone dedupe -P --dedupe-mode newest --by-hash onedrive:/main
rclone dedupe -P --dedupe-mode newest --by-hash dropbox:/main
