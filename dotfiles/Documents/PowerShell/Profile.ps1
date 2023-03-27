Import-Module -Name (dir $HOME\Documents\PowerShell\Modules)
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key Ctrl+a -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key Ctrl+e -Function EndOfLine
# https://dev.to/ofhouse/add-a-bash-like-autocomplete-to-your-powershell-4257
Set-PSReadLineKeyHandler -Key UpArrow -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchBackward()
  [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
Set-PSReadLineKeyHandler -Key DownArrow -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchForward()
  [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/automatically-updating-modules https://github.com/PowerShell/PowerShellGet/issues/521
# https://www.activestate.com/resources/quick-reads/how-to-update-all-python-packages/ https://github.com/pypa/pip/issues/4551
function upgradeall { Get-InstalledModule | Update-Module; pip freeze | % { $_.split('==')[0] } | % { pip install --upgrade $_ }; npm update -g; scoop update -qa }
function amdcleanup { Remove-Item C:\AMD\* -Recurse -Force }
Set-Alias -Name lychee -Value $env:LOCALAPPDATA\Microsoft\WinGet\Packages\lycheeverse.lychee_Microsoft.Winget.Source_8wekyb3d8bbwe\lychee*.exe # https://github.com/microsoft/winget-cli/issues/361 https://github.com/microsoft/winget-cli/issues/2802
function checkarchive { cd ~\Мой` диск\документы; sudo net stop Hamachi2Svc; lychee --max-concurrency 10 archive-org.txt; sudo net start Hamachi2Svc } # https://github.com/lycheeverse/lychee/issues/902
function checklinux { cd ~\Мой` диск\документы; sudo net stop Hamachi2Svc; lychee --max-concurrency 10 linux.txt; sudo net start Hamachi2Svc } # https://github.com/lycheeverse/lychee/issues/902
function iaupload { ia upload --checksum --verify --retries 50 --no-backup $args }
function iauploadf { ia upload --verify --retries 50 --no-backup $args }
function iauploadnd { ia upload --checksum --verify --retries 50 --no-backup --no-derive $args }
function iauploadfnd { ia upload --verify --retries 50 --no-backup --no-derive $args }
function mpvnetdvd { mpvnet dvd:// --dvd-device=VIDEO_TS }
function markwatchedyoutube { yt-dlp --skip-download --mark-watched --cookies-from-browser=firefox $args }
function backup {
  Get-ChildItem -Path "$HOME\Мой диск\unsorted" -Recurse -File | Move-Item -Destination "$HOME\Мой диск"
  # TODO: add taiga
  rclone sync -P $env:APPDATA\qBittorrent "$HOME\Мой диск\документы\backups\qbittorrent_roaming"
  rclone sync -P $env:LOCALAPPDATA\qBittorrent "$HOME\Мой диск\документы\backups\qbittorrent_local"
  rclone sync -P $env:APPDATA\rclone "$HOME\Мой диск\документы\backups\rclone"
  rclone sync -P $env:APPDATA\DS4Windows "$HOME\Мой диск\документы\backups\ds4windows"
  rclone sync -P $env:APPDATA\VolumeLock "$HOME\Мой диск\документы\backups\volumelock"
  rclone sync -P "C:\Program Files (x86)\MSI Afterburner\Profiles" "$HOME\Мой диск\документы\backups\msi_afterburner"
  rclone sync -P "C:\Program Files (x86)\RivaTuner Statistics Server\Profiles" "$HOME\Мой диск\документы\backups\rtss"
  rclone sync -P C:\tools\RPCS3\dev_hdd0\home\00000001\savedata "$HOME\Мой диск\документы\backups\rpcs3"
  rclone sync -P "$HOME\.ssh" "$HOME\Мой диск\документы\backups\ssh"
  # syncthing(-tray)
  rclone copy -P $env:APPDATA\syncthingtray.ini "$HOME\Мой диск\документы\backups\syncthing"
  rclone copy -P $env:LOCALAPPDATA\Syncthing --exclude "LOCK" --exclude "LOG" --exclude "*.log" "$HOME\Мой диск\документы\backups\syncthing\syncthing"
  # vscode # https://stackoverflow.com/a/49398449/4207635
  code --list-extensions > "$HOME\Мой диск\документы\backups\vscode\extensions.txt"
  rclone copy -P $env:APPDATA\Code\User\settings.json "$HOME\Мой диск\документы\backups\vscode"
  rclone copy -P $env:APPDATA\Code\User\keybindings.json "$HOME\Мой диск\документы\backups\vscode"
  # Yuzu https://github.com/Abd-007/Switch-Emulators-Guide/blob/main/Yuzu.md
  rclone sync -P $env:APPDATA\yuzu\nand\system\save\8000000000000010\su\avators\profiles.dat "$HOME\Мой диск\документы\backups\yuzu"
  # Ryujinx https://github.com/Abd-007/Switch-Emulators-Guide/blob/main/Ryujinx.md
  rclone sync -P $env:APPDATA\Ryujinx\system\Profiles.json "$HOME\Мой диск\документы\backups\ryujinx"
  # https://www.thewindowsclub.com/backup-restore-pinned-taskbar-items-windows-10
  rclone sync -P "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu" "$HOME\Мой диск\документы\backups\pinned_items\StartMenu"
  rclone sync -P "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" "$HOME\Мой диск\документы\backups\pinned_items\TaskBar"
  reg export 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband' $HOME\Мой` диск\документы\backups\pinned_items\Taskband.reg /y
  # https://winaero.com/how-to-backup-quick-access-folders-in-windows-10
  rclone sync -P "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations" "$HOME\Мой диск\документы\backups\explorer_quick_acess"
  if (Test-Path -Path "E:\") {
    rclone sync -P --progress-terminal-title --exclude ".tmp.drive*/" $HOME\Мой` диск E:\backups\main
    rclone sync -P --progress-terminal-title --exclude "main/" E:\backups mega:backups
  }
  rclone sync -P --progress-terminal-title $HOME\Мой` диск mega:backups\main
  rclone dedupe -P --dedupe-mode newest mega:/
}
function hyperv-toggle {
  if (((sudo bcdedit /enum) -match 'hypervisorlaunchtype' -replace 'hypervisorlaunchtype    ') -eq 'Off') {
    write-host("Enabling Hyper-V..."); sudo bcdedit /set hypervisorlaunchtype auto
  }
  else {
    write-host("Disabling Hyper-V..."); sudo bcdedit /set hypervisorlaunchtype off
  }
}
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\pure.omp.json" | Invoke-Expression
Write-Host -NoNewLine "`e[6 q" # no cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823
