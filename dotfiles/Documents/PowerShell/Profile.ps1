# Documents folder are moved to OneDrive
$documentsPath = [Environment]::GetFolderPath('MyDocuments')

Import-Module -Name (Get-ChildItem $documentsPath\PowerShell\Modules)
Import-Module gsudoModule
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\pure.omp.json" | Invoke-Expression

# No more cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823 https://github.com/microsoft/terminal/issues/1379
Write-Output "`e[6 q"

# https://github.com/PowerShell/CompletionPredictor?tab=readme-ov-file#use-the-predictor
Set-PSReadLineOption -PredictionSource HistoryAndPlugin

# Mirroring linux shells bindings and completion menu
Set-PSReadlineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key Ctrl+e -Function EndOfLine
# https://dev.to/ofhouse/add-a-bash-like-autocomplete-to-your-powershell-4257
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchBackward()
  [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
Set-PSReadLineKeyHandler -Key DownArrow -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchForward()
  [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}

function upgradeall {
  # 'pipx' https://github.com/topgrade-rs/topgrade/issues/725 TODO: fixed in new version
  topgrade --cleanup --only 'powershell' 'node' 'scoop'
  pipx upgrade-all
  psc update *
  yt-dlp --update-to master
}

# TODO: move this to Task Scheduler and launch them using Start-ScheduledTask to avoid UAC
function lycheefixon {
  sudo {
    Get-NetAdapter | Where-Object { $_.Name -ne "Ethernet 3" } | Disable-NetAdapter -Confirm:$false
  }
}
function lycheefixoff {
  sudo {
    Get-NetAdapter | Enable-NetAdapter
  }
}


function checkarchivewindows {
  lycheefixon
  Set-Location "$HOME\Мой диск\документы"
  lychee --exclude='vk.com' --exclude='yandex.ru' --exclude='megaten.ru' --max-concurrency 5 archive-org.txt
  lycheefixoff
}
function checklinuxwindows {
  lycheefixon
  Set-Location "$HOME\Мой диск\документы"
  lychee --max-concurrency 5 linux.txt
  lycheefixoff
}

function iauploadcheckderive { ia upload --checksum --verify --retries 50 --no-backup $args }
function iauploadfastderive { ia upload --verify --retries 50 --no-backup $args }
function iauploadcheck { ia upload --checksum --verify --retries 50 --no-backup --no-derive $args }
function iauploadfast { ia upload --verify --retries 50 --no-backup --no-derive $args }
function iauploadveryfast { ia upload --retries 50 --no-backup --no-derive $args }
function backup-spotify { python "$HOME\Мой диск\документы\backups\spotify-backup\spotify-backup.py" "$HOME\Мой диск\документы\backups\spotify-backup\playlists.txt" --dump='liked,playlists' }

function YoutubeMarkWatched { yt-dlp --skip-download --mark-watched --cookies-from-browser=firefox $args }
# https://superuser.com/a/1830291/1506333
function YoutubeExtractAllUrls { yt-dlp $args --skip-download --no-warning --print webpage_url }

function download_subtitles { subliminal download -l en -hi $args[0] }
function mkd { mkdir $args[0] 2>$null; Set-Location $args[0] }
function mps { multipass stop }
function proxinjector_cli { & "$env:APPDATA\proxinject\proxinjector-cli.exe" $args }
function what_blocks_sleep { sudo { powercfg -requests } }

# https://superuser.com/questions/544336/incremental-backup-with-7zip
function backup {
  $host.ui.RawUI.WindowTitle = "Backup task"

  $env:EHDD = (Get-Volume -FileSystemLabel "ExternalHDD").DriveLetter

  # Oracle server backup
  #backup-oracle

  # Moving unsorted files back to main folder
  Get-ChildItem "$HOME\Мой диск\unsorted" -Recurse -File | ForEach-Object {
    $destFile = "$HOME\Мой диск\$($_.Name)"

    while (Test-Path $destFile) {
      $destFile = "$HOME\Мой диск\$([System.IO.Path]::GetFileNameWithoutExtension($_.Name))_$((Get-Random -Maximum 9999))$([System.IO.Path]::GetExtension($_.Name))"
    }

    Move-Item $_.FullName $destFile
  }

  # TODO: what files/folders are used by running processes?
  # TODO: add plex
  # TODO: C:\Users\user\AppData\Roaming\AIMP
  # Software
  rclone sync -P $env:APPDATA\Taiga\data "$HOME\Мой диск\документы\backups\Taiga" --delete-excluded --exclude "db/image/" --exclude "theme/"
  rclone sync -P $env:APPDATA\qBittorrent "$HOME\Мой диск\документы\backups\qbittorrent_roaming" --delete-excluded --exclude "lockfile"
  rclone sync -P $env:LOCALAPPDATA\qBittorrent "$HOME\Мой диск\документы\backups\qbittorrent_local"--delete-excluded --exclude "logs/" --exclude "rss/articles/*.ico"
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
  7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\rpcs3.7z" "$env:ChocolateyToolsLocation\RPCS3\dev_hdd0\home\00000001\savedata"
  # https://github.com/Abd-007/Switch-Emulators-Guide/blob/main/Yuzu.md https://github.com/Abd-007/Switch-Emulators-Guide/blob/main/Ryujinx.md
  rclone sync -P $HOME\scoop\apps\sudachi\current\user\nand\system\save\8000000000000010\su\avators\profiles.dat "$HOME\Мой диск\документы\backups\sudachi"
  rclone sync -P $HOME\scoop\persist\ryujinx\portable\system\Profiles.json "$HOME\Мой диск\документы\backups\ryujinx"

  # Tab Session Manager backups
  7z a -up0q0r2x2y2z1w2 -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\backups\TabSessionManager.7z" "$HOME\Downloads\TabSessionManager - Backup"

  # Syncthing(-tray)
  rclone sync -P $env:APPDATA\syncthingtray.ini "$HOME\Мой диск\документы\backups\syncthing"
  rclone sync -P $env:LOCALAPPDATA\Syncthing "$HOME\Мой диск\документы\backups\syncthing\syncthing" --delete-excluded --exclude "LOCK" --exclude "index*/LOG" --exclude "index*/*.log" --exclude "*.tmp.*"

  # Visual Studio Code https://stackoverflow.com/a/49398449/4207635
  code --list-extensions > "$HOME\Мой диск\документы\backups\vscode\extensions.txt"
  rclone sync -P $env:APPDATA\Code\User\settings.json "$HOME\Мой диск\документы\backups\vscode"
  rclone sync -P $env:APPDATA\Code\User\keybindings.json "$HOME\Мой диск\документы\backups\vscode"

  # https://winaero.com/how-to-backup-quick-access-folders-in-windows-10
  rclone sync -P $env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations "$HOME\Мой диск\документы\backups\explorer_quick_access"

  # https://www.elevenforum.com/t/backup-and-restore-pinned-items-on-taskbar-in-windows-11.3630/ https://www.elevenforum.com/t/backup-and-restore-pinned-items-on-start-menu-in-windows-11.3629/
  # https://aka.ms/AAnrixg
  rclone sync -P $env:LOCALAPPDATA\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState "$HOME\Мой диск\документы\backups\taskbar_pinned_items\StartMenu"
  rclone sync -P "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" "$HOME\Мой диск\документы\backups\taskbar_pinned_items\TaskBar"
  reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" "$HOME\Мой диск\документы\backups\taskbar_pinned_items\Taskband.reg" /y

  if (Test-Path -Path "${env:EHDD}:\") {
    # Backing up my google drive folder to external HDD
    rclone sync -P --progress-terminal-title "$HOME\Мой диск" ${env:EHDD}:\main --delete-excluded --exclude ".tmp.drive*/"

    # Backing up my backups on external HDD to mega cloud
    rclone sync -P --progress-terminal-title ${env:EHDD}:\backups mega:backups
  }

  # Backing up my google drive folder to mega cloud
  rclone sync -P --progress-terminal-title "$HOME\Мой диск" mega:main --delete-excluded --exclude ".tmp.drive*/"

  # Deduping clouds
  rclone dedupe -P --dedupe-mode newest mega:/
  rclone dedupe -P --dedupe-mode newest gdrive:/
}

# https://github.com/microsoft/winget-cli/issues/1653
# https://github.com/microsoft/winget-cli/issues/1155
# https://github.com/microsoft/winget-cli/issues/3494
function listallsoftware { winget list --source winget | Sort-Object Name }

# https://github.com/canonical/multipass/issues/3112
function setdiscardmultipass { sudo { psexec.exe -s ${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe storageattach primary --storagectl "SATA_0" --port 0 --device 0 --nonrotational on --discard on } }

function showmultipassvminfo { sudo { psexec.exe -s ${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe showvminfo primary --machinereadable } }
function multipassdeleteportforward {
  param (
    [string]$name
  )
  sudo { psexec.exe -s ${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe modifyvm primary --natpf1 delete $name }
}

# Loading private powershell profile
. "$HOME\Мой диск\документы\private_powershell_profile.ps1"
