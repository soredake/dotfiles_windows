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
# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/automatically-updating-modules
# https://www.activestate.com/resources/quick-reads/how-to-update-all-python-packages/
# TODO: wsl --update will not be needed in future https://devblogs.microsoft.com/commandline/a-preview-of-wsl-in-the-microsoft-store-is-now-available/
# TODO: topgrade
# https://github.com/PowerShell/PowerShellGet/issues/521
# winget upgrade --all, sudo wsl --update
function upgradeall { Get-InstalledModule | Update-Module; pip freeze | %{$_.split('==')[0]} | %{pip install --upgrade $_}; C:\tools\msys64\mingw64.exe pacman.exe -Syu --noconfirm}
function iaupload { ia upload --checksum --verify --retries 10 --no-backup $args }
function iauploadf { ia upload --verify --retries 10 --no-backup $args }
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/pure.omp.json" | Invoke-Expression

function backup {
  #rclone move -n -P gphotos:/media/album/ C:\Users\User\Мой` диск
  C:\Program` Files\7-Zip-Zstandard\7z.exe -mx=9 a "C:\Users\User\Мой диск\документы\backups\rpcs3_saves.zip" "C:\tools\RPCS3\dev_hdd0\home\00000001\savedata\*"
  Start-Sleep -Seconds 20
  rclone sync -P C:\Users\User\Мой` диск F:\backups\main
  rclone dedupe -P --dedupe-mode newest mega:/backups
  rclone sync -P F:\backups mega:backups
  rclone sync -P C:\Users\User\dwhelper mega:dwhelper
}
