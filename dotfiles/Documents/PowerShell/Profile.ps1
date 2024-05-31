# Documents folder are moved to OneDrive
$documentsPath = [Environment]::GetFolderPath('MyDocuments')

Import-Module -Name (Get-ChildItem $documentsPath\PowerShell\Modules)
Import-Module gsudoModule
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\pure.omp.json" | Invoke-Expression

# No more cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823 https://github.com/microsoft/terminal/issues/1379
Write-Output "`e[6 q"

# https://github.com/PowerShell/CompletionPredictor?tab=readme-ov-file#use-the-predictor
#Set-PSReadLineOption -PredictionSource HistoryAndPlugin

function upgradeall {
  # `wsl` step can run topgrade in WSL
  # 'pipx' https://github.com/topgrade-rs/topgrade/issues/725 TODO: fixed in new version
  topgrade --no-retry --cleanup --only 'powershell' 'node' 'scoop' 'wsl_update'
  pipx upgrade-all
  psc update *
}

function lycheefixon {
  Stop-Service -Name Hamachi2Svc
  Get-NetAdapter | Where-Object { $_.Name -ne "Ethernet 3" } | Disable-NetAdapter -Confirm:$false
}
function lycheefixoff {
  Start-Service -Name Hamachi2Svc
  Get-NetAdapter | Enable-NetAdapter
}
function StartLycheeFix {
  Start-ScheduledTask -TaskName "Start lycheefix"
}
function StopLycheeFix {
  Start-ScheduledTask -TaskName "Stop lycheefix"
}

function checklinks {
  #StartLycheeFix
  Set-Location "$HOME\Мой диск\документы\archiveorg"
  lychee --exclude='vk.com' --exclude='yandex.ru' --exclude='megaten.ru' --max-concurrency 5 *.txt
  lychee --max-concurrency 5 ..\old\linux.txt
  #StopLycheeFix
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
function backup { pwsh $HOME\git\dotfiles_windows\scripts\backup-script.ps1 }

# https://github.com/microsoft/winget-cli/issues/1653
# https://github.com/microsoft/winget-cli/issues/1155
# https://github.com/microsoft/winget-cli/issues/3494
function listallsoftware { winget list --source winget | Sort-Object Name }

# https://github.com/canonical/multipass/issues/3112
function MultipassSetDiscard { sudo { psexec.exe -s ${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe storageattach primary --storagectl "SATA_0" --port 0 --device 0 --nonrotational on --discard on } }

function MultipassShowVmInfo { sudo { psexec.exe -s ${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe showvminfo primary --machinereadable } }
function MultipassDeletePortForward {
  param (
    [string]$name
  )
  sudo { psexec.exe -s ${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe modifyvm primary --natpf1 delete $name }
}
function MultipassExportLogsFromLastHour {
  Get-WinEvent -FilterHashtable @{LogName = 'Application'; ProviderName = 'Multipass'; StartTime = (Get-Date).AddHours(-1) } | Out-File -FilePath $HOME\Export.txt
}


# Loading private powershell profile
. "$HOME\Мой диск\документы\private_powershell_profile.ps1"

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
