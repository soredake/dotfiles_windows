Import-Module -Name (dir $HOME\Documents\PowerShell\Modules)
Import-Module gsudoModule
Import-Module $env:ProgramFiles\PowerToys\WinGetCommandNotFound.psd1
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\pure.omp.json" | Invoke-Expression
Write-Output "`e[6 q" # no cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823 https://github.com/microsoft/terminal/issues/1379
. "$HOME\Мой диск\документы\private_powershell_profile.ps1"
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
# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/automatically-updating-modules https://github.com/PowerShell/PSResourceGet/issues/521 https://github.com/PowerShell/PSResourceGet/issues/495
# https://www.activestate.com/resources/quick-reads/how-to-update-all-python-packages/ https://github.com/pypa/pip/issues/4551
# function upgradeall { topgrade --only 'powershell' 'pip3' 'pipx' 'node' 'scoop' }
function upgradeall { Get-InstalledModule | Update-Module; pip freeze | % { $_.split('==')[0] } | % { pip install --upgrade $_ }; pipx upgrade-all; npm update -g; scoop update -a; scoop cleanup -ka; psc update * }
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
function mkd { mkdir $args[0] 2>$null; cd $args[0] }
function mps { multipass stop }
function proxinjector-cli { & "$env:APPDATA\proxinject\proxinjector-cli.exe" $args }
function backup {
  $env:EHDD = (Get-Volume -FileSystemLabel "ExternalHDD").DriveLetter

  backup-oracle

  # Get-ChildItem -Path "$HOME\Мой диск\unsorted" -Recurse -File | Move-Item -Destination "$HOME\Мой диск"
  gci "$HOME\Мой диск\unsorted" -Recurse -File | % { $destFile = "$HOME\Мой диск\$($_.Name)"; while (Test-Path $destFile) { $destFile = "$HOME\Мой диск\$([System.IO.Path]::GetFileNameWithoutExtension($_.Name))_$((Get-Random -Maximum 9999))$([System.IO.Path]::GetExtension($_.Name))" }; mv $_.FullName $destFile }
  rclone sync -P $env:APPDATA\Taiga\data "$HOME\Мой диск\документы\backups\Taiga" --exclude "db/image/" --exclude "theme/"
  rclone sync -P $env:APPDATA\qBittorrent "$HOME\Мой диск\документы\backups\qbittorrent_roaming" --exclude "lockfile"
  rclone sync -P $env:LOCALAPPDATA\qBittorrent "$HOME\Мой диск\документы\backups\qbittorrent_local" --exclude "logs/" --exclude "rss/articles/*.ico"
  rclone sync -P $HOME\scoop\persist\rclone "$HOME\Мой диск\документы\backups\rclone"
  rclone sync -P $env:APPDATA\syncplay.ini "$HOME\Мой диск\документы\backups\syncplay"
  rclone sync -P $env:APPDATA\DS4Windows "$HOME\Мой диск\документы\backups\ds4windows" --exclude "Logs/"
  # rclone sync -P $env:APPDATA\VolumeLock "$HOME\Мой диск\документы\backups\volumelock"
  rclone sync -P "${env:ProgramFiles(x86)}\MSI Afterburner\Profiles" "$HOME\Мой диск\документы\backups\msi_afterburner"
  rclone sync -P "${env:ProgramFiles(x86)}\RivaTuner Statistics Server\Profiles" "$HOME\Мой диск\документы\backups\rtss"
  rclone sync -P $env:ChocolateyToolsLocation\RPCS3\dev_hdd0\home\00000001\savedata "$HOME\Мой диск\документы\backups\rpcs3"
  rclone sync -P "$HOME\.ssh" "$HOME\Мой диск\документы\backups\ssh"
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
  if (Test-Path -Path "${env:EHDD}:\") {
    rclone sync -P --progress-terminal-title "$HOME\Мой диск" ${env:EHDD}:\backups\main --exclude ".tmp.drive*/"
    rclone sync -P --progress-terminal-title ${env:EHDD}:\backups mega:backups --exclude "main/"
  }
  rclone sync -P --progress-terminal-title "$HOME\Мой диск" mega:backups\main
  rclone dedupe -P --dedupe-mode newest mega:/
}
