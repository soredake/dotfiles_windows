$documentsPath = [Environment]::GetFolderPath('MyDocuments')
Import-Module -Name (dir $documentsPath\PowerShell\Modules)
Import-Module gsudoModule
Import-Module $env:ProgramFiles\PowerToys\WinGetCommandNotFound.psd1
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\pure.omp.json" | Invoke-Expression
. "$HOME\Мой диск\документы\private_powershell_profile.ps1"
# no cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823 https://github.com/microsoft/terminal/issues/1379
Write-Output "`e[6 q"
# mirroring linux shells bindings
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
  topgrade --cleanup --only 'powershell' 'pipx' 'node' 'scoop'
  psc update *
}
function oraclessh {
  ssh -L 34567:localhost:34568 oracle
  # C:\Program` Files\SSHFS-Win\bin\sshfs.exe localhost:/home/ubuntu/oracle "C:\Users\user\Мой диск\документы\oracle" -o directport=34568
  # sshfs localhost -o directport=34568
}
function reboottobios { shutdown /r /fw /f /t 0 }
function checkarchive { multipass exec primary -- /home/linuxbrew/.linuxbrew/bin/lychee --exclude='vk.com' --exclude='yandex.ru' --exclude='megaten.ru' --max-concurrency 5 /mnt/c_host/Users/$env:USERNAME/Мой` диск/документы/archive-org.txt; mps }
function checklinux { multipass exec primary -- /home/linuxbrew/.linuxbrew/bin/lychee --exclude='vk.com' --exclude='yandex.ru' --exclude='megaten.ru' --max-concurrency 5 /mnt/c_host/Users/$env:USERNAME/Мой` диск/документы/linux.txt; mps }
function checkarchivewindows { cd "$HOME\Мой диск\документы"; lychee --exclude='vk.com' --exclude='yandex.ru' --exclude='megaten.ru' --max-concurrency 5 archive-org.txt }
function checklinuxwindows { cd "$HOME\Мой диск\документы"; lychee --max-concurrency 5 linux.txt }
function iauploadcheckderive { ia upload --checksum --verify --retries 50 --no-backup $args }
function iauploadfastderive { ia upload --verify --retries 50 --no-backup $args }
function iauploadcheck { ia upload --checksum --verify --retries 50 --no-backup --no-derive $args }
function iauploadfast { ia upload --verify --retries 50 --no-backup --no-derive $args }
function iauploadveryfast { ia upload --retries 50 --no-backup --no-derive $args }
function backup-spotify { python "$HOME\Мой диск\документы\backups\spotify-backup\spotify-backup.py" "$HOME\Мой диск\документы\backups\spotify-backup\playlists.txt" --dump='liked,playlists' }
function markyoutubewatched { yt-dlp --skip-download --mark-watched --cookies-from-browser=firefox $args }
function download-subtitles { subliminal download -l en -hi $args[0] }
function mkd { mkdir $args[0] 2>$null; cd $args[0] }
function mps { multipass stop }
function proxinjector-cli { & "$env:APPDATA\proxinject\proxinjector-cli.exe" $args }
function backup {
  $env:EHDD = (Get-Volume -FileSystemLabel "ExternalHDD").DriveLetter

  # oracle server backup
  backup-oracle

  # moving unsorted files back to main folder
  Get-ChildItem "$HOME\Мой диск\unsorted" -Recurse -File | ForEach-Object {
    $destFile = "$HOME\Мой диск\$($_.Name)"
    while (Test-Path $destFile) {
      $destFile = "$HOME\Мой диск\$([System.IO.Path]::GetFileNameWithoutExtension($_.Name))_$((Get-Random -Maximum 9999))$([System.IO.Path]::GetExtension($_.Name))"
    }
    Move-Item $_.FullName $destFile
  }

  # software
  rclone sync -P $env:APPDATA\Taiga\data "$HOME\Мой диск\документы\backups\Taiga" --exclude "db/image/" --exclude "theme/"
  rclone sync -P $env:APPDATA\qBittorrent "$HOME\Мой диск\документы\backups\qbittorrent_roaming" --exclude "lockfile"
  rclone sync -P $env:LOCALAPPDATA\qBittorrent "$HOME\Мой диск\документы\backups\qbittorrent_local" --exclude "logs/" --exclude "rss/articles/*.ico"
  rclone sync -P $HOME\scoop\persist\rclone "$HOME\Мой диск\документы\backups\rclone"
  rclone sync -P $env:APPDATA\syncplay.ini "$HOME\Мой диск\документы\backups\syncplay"
  rclone sync -P $env:APPDATA\DS4Windows "$HOME\Мой диск\документы\backups\ds4windows" --exclude "Logs/"
  rclone sync -P "${env:ProgramFiles(x86)}\MSI Afterburner\Profiles" "$HOME\Мой диск\документы\backups\msi_afterburner"
  rclone sync -P "${env:ProgramFiles(x86)}\RivaTuner Statistics Server\Profiles" "$HOME\Мой диск\документы\backups\rtss"
  rclone sync -P $env:ChocolateyToolsLocation\RPCS3\dev_hdd0\home\00000001\savedata "$HOME\Мой диск\документы\backups\rpcs3"
  rclone sync -P "$HOME\.ssh" "$HOME\Мой диск\документы\backups\ssh"

  # games and emulators
  7z a -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\EMPRESS.7z" "$env:PUBLIC\Documents\EMPRESS"
  7z a -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\OnlineFix.7z" "$env:PUBLIC\Documents\OnlineFix"
  7z a -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\CODEX.7z" "$env:PUBLIC\Documents\Steam\CODEX"
  7z a -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\PPSSPP.7z" "$documentsPath\PPSSPP"
  7z a -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\GoldbergSteamEmuSaves.7z" "$env:APPDATA\Goldberg SteamEmu Saves"
  7z a -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\ryujinx.7z" "$HOME\scoop\persist\ryujinx-ava\portable\bis\user\save"
  7z a -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\yuzu.7z" "$HOME\scoop\apps\yuzu-pineapple\current\user\nand\user\save"
  7z a -t7z -m0=lzma2 -mmt=on -mx=5 "$HOME\Мой диск\документы\saves\rpcs3.7z" "$env:ChocolateyToolsLocation\RPCS3\dev_hdd0\home\00000001\savedata"

  # tab session manager backups
  rclone sync -P "$HOME\Downloads\TabSessionManager - Backup" "$HOME\Мой диск\документы\backups\TabSessionManager - Backup"

  # syncthing(-tray)
  rclone sync -P $env:APPDATA\syncthingtray.ini "$HOME\Мой диск\документы\backups\syncthing"
  rclone sync -P $env:LOCALAPPDATA\Syncthing "$HOME\Мой диск\документы\backups\syncthing\syncthing" --exclude "LOCK" --exclude "index*/LOG" --exclude "index*/*.log" --exclude "*.tmp.*"

  # vscode https://stackoverflow.com/a/49398449/4207635
  code --list-extensions > "$HOME\Мой диск\документы\backups\vscode\extensions.txt"
  rclone sync -P $env:APPDATA\Code\User\settings.json "$HOME\Мой диск\документы\backups\vscode"
  rclone sync -P $env:APPDATA\Code\User\keybindings.json "$HOME\Мой диск\документы\backups\vscode"

  # https://github.com/Abd-007/Switch-Emulators-Guide/blob/main/Yuzu.md https://github.com/Abd-007/Switch-Emulators-Guide/blob/main/Ryujinx.md
  rclone sync -P "$HOME\scoop\apps\yuzu-pineapple\current\user\nand\system\save\8000000000000010\su\avators\profiles.dat" "$HOME\Мой диск\документы\backups\yuzu"
  rclone sync -P $env:APPDATA\Ryujinx\system\Profiles.json "$HOME\Мой диск\документы\backups\ryujinx"

  # https://winaero.com/how-to-backup-quick-access-folders-in-windows-10
  rclone sync -P $env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations "$HOME\Мой диск\документы\backups\explorer_quick_access"

  # https://www.elevenforum.com/t/backup-and-restore-pinned-items-on-taskbar-in-windows-11.3630/ https://www.elevenforum.com/t/backup-and-restore-pinned-items-on-start-menu-in-windows-11.3629/
  # https://aka.ms/AAnrixg
  rclone sync -P "$env:LOCALAPPDATA\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" "$HOME\Мой диск\документы\backups\taskbar_pinned_items\StartMenu"
  rclone sync -P "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" "$HOME\Мой диск\документы\backups\taskbar_pinned_items\TaskBar"
  reg export "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" "$HOME\Мой диск\документы\backups\taskbar_pinned_items\Taskband.reg" /y

  # backing up my google drive folder to external HDD
  # backing up my backups on external HDD to mega cloud
  if (Test-Path -Path "${env:EHDD}:\") {
    rclone sync -P --progress-terminal-title "$HOME\Мой диск" ${env:EHDD}:\backups\main --exclude ".tmp.drive*/"
    rclone sync -P --progress-terminal-title ${env:EHDD}:\backups mega:backups --exclude "main/"
  }
  rclone sync -P --progress-terminal-title "$HOME\Мой диск" mega:backups\main
  rclone dedupe -P --dedupe-mode newest mega:/
}
# https://github.com/microsoft/winget-cli/issues/1653
# https://github.com/microsoft/winget-cli/issues/1155
function listallsoftware { winget list --source winget | Sort-Object Name }

function setdiscardmultipass { sudo { psexec.exe -s VBoxManage storageattach primary --storagectl "SATA_0" --port 0 --device 0 --nonrotational on --discard on } }

function showmultipassvminfo { sudo { psexec.exe -s VBoxManage showvminfo primary --machinereadable } }
function multipassdeleteportforward {
  param (
    [string]$name
  )
  sudo { psexec.exe -s VBoxManage modifyvm primary --natpf1 delete $name }
}

function forwardMultipassPort {
  # sudo {
  param (
    [string]$name,
    [string]$protocol,
    [int]$port1,
    [int]$port2
  )

  Write-Output "$name,$protocol,,$port1,,$port2"

  sudo { PsExec.exe -s ${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe controlvm "primary" natpf1 "$name,$protocol,,$port1,,$port2" }
  # }
}

# forwardMultipassPort -name "vpn" -protocol "tcp" -port1 51820 -port2 51820

# forwardMultipassPort vpn tcp 51820 51820
# forwardMultipassPort qbittorrent_webui tcp 22222 22222
# forwardMultipassPort qbittorrent_p2p tcp 9999 9999
# forwardMultipassPort qbittorrent_p2p udp 9999 9999
