# Documents folder are moved to OneDrive
$documentsPath = [Environment]::GetFolderPath('MyDocuments')

Import-Module -Name (Get-ChildItem $documentsPath\PowerShell\Modules)
Import-Module -Name Microsoft.WinGet.CommandNotFound
Import-Module -Name gsudoModule
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\pure.omp.json" | Invoke-Expression

# No more cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823 https://github.com/microsoft/terminal/issues/1379
Write-Output "`e[6 q"

function checklinks {
  Push-Location "$HOME\Мой диск\документы"
  lychee --exclude='vk.com' --exclude='yandex.ru' --exclude='megaten.ru' --max-concurrency 5 archive-org.txt
  lychee --max-concurrency 5 old\linux.txt
  Pop-Location
}

# Clean all my clouds
function CleanAllClouds {
  rclone cleanup -v mega:
  rclone cleanup -v gdrive:
  rclone cleanup -v onedrive:
  rclone cleanup -v dropbox:
}

# To list all inbox packages:
function ListAllAppxPackagesWithFamilyName {
  gsudo {
    # Retrieve all installed Appx packages for all users
    $allPackages = Get-AppxPackage -AllUsers

    # Retrieve the list of start menu applications
    $startApps = Get-StartApps

    # Iterate through each package in allPackages
    $allPackages | ForEach-Object {
      $pkg = $_  # Current package

      # Find matching start menu apps where AppID contains the PackageFamilyName
      $startApps | Where-Object { 
        $_.AppID -like "*$($pkg.PackageFamilyName)*" 
      } | ForEach-Object {
        # Create a new PSObject for each matched app
        New-Object PSObject -Property @{
          PackageFamilyName = $pkg.PackageFamilyName
          AppName           = $_.Name
        }
      }
    } | Format-List  # Display results in a formatted list
  }
}

# https://t.me/sterkin_ru/1684
function ListAllInstalledAppxPackages {
  gsudo {
    # NOTE: sadly, `Get-AppxProvisionedPackage -Online` does not work with pwsh installed from microsoft store
    powershell -c 'Get-AppxProvisionedPackage -Online | Select-Object DisplayName'
  }
}

function iauploadcheckderive { ia upload --checksum --verify --retries 50 --no-backup $args }
function iauploadfastderive { ia upload --verify --retries 50 --no-backup $args }
function iauploadcheck { ia upload --checksum --verify --retries 50 --no-backup --no-derive $args }
function iauploadfast { ia upload --verify --retries 50 --no-backup --no-derive $args }
function iauploadveryfast { ia upload --retries 50 --no-backup --no-derive $args }
function backup-spotify { python "$HOME\Мой диск\документы\backups\spotify-backup\spotify-backup.py" "$HOME\Мой диск\документы\backups\spotify-backup\playlists.txt" --dump='liked,playlists' }
function backup-spotify-json { python "$HOME\Мой диск\документы\backups\spotify-backup\spotify-backup.py" "$HOME\Мой диск\документы\backups\spotify-backup\playlists.json" --format=json --dump='liked,playlists' }

function YoutubeMarkWatched { yt-dlp --skip-download --mark-watched --cookies-from-browser=firefox $args }
# https://superuser.com/a/1830291/1506333
function YoutubeExtractAllUrls { yt-dlp $args --skip-download --no-warning --print webpage_url }

function mkd { mkdir $args[0] 2>$null; Set-Location $args[0] }
function mps { multipass stop }
function proxinjector_cli { & "$env:APPDATA\proxinject\proxinjector-cli.exe" $args }
function what_blocks_sleep { gsudo { powercfg -requests } }
function backup { pwsh $HOME\git\dotfiles_windows\scripts\backup-script.ps1 }


# https://github.com/canonical/multipass/issues/3112
function MultipassSetDiscard { gsudo { psexec -s ${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe storageattach primary --storagectl "SATA_0" --port 0 --device 0 --nonrotational on --discard on } }

function MultipassShowVmInfo { gsudo { psexec -s ${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe showvminfo primary --machinereadable } }
function MultipassDeletePortForward {
  param (
    [string]$name
  )
  gsudo { psexec.exe -s ${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe modifyvm primary --natpf1 delete $name }
}
function MultipassExportLogsFromLastHour {
  Get-WinEvent -FilterHashtable @{LogName = 'Application'; ProviderName = 'Multipass'; StartTime = (Get-Date).AddHours(-1) } | Out-File -FilePath $HOME\Multipass-logs-from-last-hour.log
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

# https://github.com/PowerShell/CompletionPredictor?tab=readme-ov-file#use-the-predictor
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
