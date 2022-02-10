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
function upgradeall { Get-InstalledModule | Update-Module; pip freeze | %{$_.split('==')[0]} | %{pip install --upgrade $_}; C:\tools\msys64\mingw64.exe pacman.exe -Syu --noconfirm; sudo wsl --update }
function iaupload { ia upload --checksum --verify --retries 10 --no-backup $args }
function iauploadf { ia upload --verify --retries 10 --no-backup $args }
oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/pure.omp.json | Invoke-Expression
#function setupcookies { yt-dlp --cookies-from-browser firefox }

function backup {
  rclone sync -P C:\Users\User\Мой` диск F:\backups\main
  rclone dedupe -P --dedupe-mode newest mega:/backups
  rclone sync -P F:\backups mega:backups
}
