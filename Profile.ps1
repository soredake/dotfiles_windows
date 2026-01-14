# Documents folder are moved to OneDrive
$documentsPath = [Environment]::GetFolderPath('MyDocuments')

# https://github.com/PowerShell/PowerShell/issues/15552
Import-Module -Name (Get-ChildItem $documentsPath\PowerShell\Modules)
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\pure.omp.json" | Invoke-Expression

# No more cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823 https://github.com/microsoft/terminal/issues/1379
Write-Output "`e[6 q"

# Toogle for hypervisor boot
function hypervisorboot_toggle {
  $currentState = (gsudo bcdedit /enum) -match 'hypervisorlaunchtype' -replace 'hypervisorlaunchtype\s+'
  if ($currentState -eq 'Off') {
    Write-Output "Enabling Hyper-V..."
    gsudo bcdedit /set hypervisorlaunchtype auto
  }
  else {
    Write-Output "Disabling Hyper-V..."
    gsudo bcdedit /set hypervisorlaunchtype off
  }
}

function YoutubeMarkWatched { yt-dlp --skip-download --mark-watched --cookies-from-browser=firefox $args }
# https://superuser.com/a/1830291/1506333
function YoutubeExtractAllUrlsFromPlaylist { yt-dlp $args --skip-download --no-warning --print webpage_url 2>$null }

function mkd {
  $newDir = $args[0]
  if (-not (Test-Path $newDir)) {
    mkdir $newDir | Out-Null
  }
  Set-Location (Join-Path $PWD $newDir)
}

# Mirroring linux shells bindings and completion menu
# TODO: set this as default? https://github.com/PowerShell/PowerShell
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
