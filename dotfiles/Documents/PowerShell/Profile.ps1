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
# TODO: topgrade
function upgradeall { Get-InstalledModule | Update-Module; pip freeze | %{$_.split('==')[0]} | %{pip install --upgrade $_}; npm update -g }
function amdcleanup { sudo Remove-Item C:\AMD\* -Recurse -Force }
function iaupload { ia upload --checksum --verify --retries 50 --no-backup $args }
function iauploadf { ia upload --verify --retries 50 --no-backup $args }
function iauploadnd { ia upload --checksum --verify --retries 50 --no-backup --no-derive $args }
function iauploadfnd { ia upload --verify --retries 50 --no-backup --no-derive $args }
function backup {
  Get-ChildItem -Path "C:\Users\user\Мой диск\tttttttttt" -Recurse -File | Move-Item -Destination "C:\Users\user\Мой диск"
  rclone copy -P $env:APPDATA\Code\User\settings.json "C:\Users\User\Мой диск\документы\backups\vscode"
  rclone copy -P $env:APPDATA\Code\User\keybindings.json "C:\Users\User\Мой диск\документы\backups\vscode"
  rclone sync -P $env:APPDATA\qBittorrent "C:\Users\User\Мой диск\документы\backups\qbittorrent_roaming"
  rclone sync -P $env:LOCALAPPDATA\qBittorrent "C:\Users\User\Мой диск\документы\backups\qbittorrent_local"
  rclone sync -P $env:APPDATA\rclone "C:\Users\User\Мой диск\документы\backups\rclone"
  rclone sync -P $env:APPDATA\DS4Windows "C:\Users\User\Мой диск\документы\backups\ds4windows"
  rclone sync -P $env:APPDATA\VolumeLock "C:\Users\User\Мой диск\документы\backups\volumelock"
  rclone sync -P "C:\Program Files (x86)\MSI Afterburner\Profiles" "C:\Users\User\Мой диск\документы\backups\msi_afterburner"
  rclone sync -P "C:\Program Files (x86)\RivaTuner Statistics Server\Profiles" "C:\Users\User\Мой диск\документы\backups\rtss"
  # https://www.thewindowsclub.com/backup-restore-pinned-taskbar-items-windows-10
  rclone sync -P "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu" "C:\Users\user\Мой диск\документы\backups\pinned_items\StartMenu"
  rclone sync -P "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" "C:\Users\user\Мой диск\документы\backups\pinned_items\TaskBar"
  reg export 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband' C:\Users\user\Мой` диск\документы\backups\pinned_items\Taskband.reg /y
  # https://winaero.com/how-to-backup-quick-access-folders-in-windows-10
  rclone sync -P "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations" "C:\Users\user\Мой диск\документы\backups\explorer_quick_acess"
  code --list-extensions > "C:\Users\User\Мой диск\документы\backups\vscode\extensions.txt" # https://stackoverflow.com/a/49398449/4207635
  #C:\Program` Files\7-Zip\7z.exe -mx=9 a "C:\Users\User\Мой диск\документы\backups\rpcs3_saves.zip" "C:\tools\RPCS3\dev_hdd0\home\00000001\savedata\*"
  #Start-Sleep -Seconds 20
  rclone sync -P --progress-terminal-title --exclude ".tmp.drive*" C:\Users\User\Мой` диск E:\backups\main
  rclone dedupe -P --dedupe-mode newest mega:/backups
  rclone sync -P --progress-terminal-title E:\backups mega:backups
  #rclone sync -P --progress-terminal-title E:\dwhelper mega:dwhelper
}
function hyperv-toggle {
  if(((sudo bcdedit /enum) -match 'hypervisorlaunchtype' -replace 'hypervisorlaunchtype    ') -eq 'Off'){
    write-host("Enabling Hyper-V..."); sudo bcdedit /set hypervisorlaunchtype auto
  } else {
    write-host("Disabling Hyper-V..."); sudo bcdedit /set hypervisorlaunchtype off
  }
}
oh-my-posh init pwsh --config "C:\Program Files (x86)\oh-my-posh\themes\pure.omp.json" | Invoke-Expression
