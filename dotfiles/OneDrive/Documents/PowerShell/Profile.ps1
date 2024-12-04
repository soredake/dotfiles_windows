# Documents folder are moved to OneDrive
$documentsPath = [Environment]::GetFolderPath('MyDocuments')

Import-Module -Name (Get-ChildItem $documentsPath\PowerShell\Modules)
# Import-Module -Name Microsoft.WinGet.CommandNotFound
Import-Module -Name gsudoModule
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\pure.omp.json" | Invoke-Expression

# No more cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823 https://github.com/microsoft/terminal/issues/1379
Write-Output "`e[6 q"

function checklinks {
  # https://github.com/lycheeverse/lychee/issues/972
  Push-Location "$HOME\Мой диск\документы"
  lychee --max-concurrency 5 archive-org.txt
  Pop-Location
}

# Rebase revanced-patched-apks repo
function RebaseRevancedPatchedApks {
  # Change dir to repository
  Push-Location "$HOME\git\revanced-patched-apks"

  # 1. Copy `config.toml` to $TEMP
  $sourceFiles = @("config.toml")
  $tempDir = [System.IO.Path]::GetTempPath()

  foreach ($file in $sourceFiles) {
    Copy-Item -Path $file -Destination $tempDir -Force
  }

  # 2. Hard reset the current repository to the remote `upstream` branch `main`
  git fetch upstream
  git reset --hard upstream/main

  # 3. Copy `config.toml` back from $TEMP to the current directory
  foreach ($file in $sourceFiles) {
    Copy-Item -Path (Join-Path -Path $tempDir -ChildPath $file) -Destination . -Force
  }

  # 4. Create a commit with the name "Adding my config"
  git add config.toml
  git commit -m "Adding my config"

  # 5. Push with --force
  git push --force

  # 6. Prevent `error: src refspec main matches more than one` error when pushing from vscode
  git tag -d main

  Pop-Location
}

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

# Example for another directory: `Invoke-GitGCRecursively -BaseDir "C:\Projects"`
function Invoke-GitGCRecursively {
  [CmdletBinding()]
  param (
    [string]$BaseDir = "$HOME\git"
  )

  # Check if the directory exists
  if (-Not (Test-Path -Path $BaseDir)) {
    Write-Error "Directory '$BaseDir' does not exist."
    return
  }

  # Get all directories containing a '.git' folder
  $gitRepos = Get-ChildItem -Path $BaseDir -Recurse -Directory | Where-Object {
    Test-Path -Path (Join-Path $_.FullName ".git")
  }

  # Perform 'git gc --aggressive' on each repository
  foreach ($repo in $gitRepos) {
    Write-Information "Running 'git gc --aggressive' in repository: $($repo.FullName)" -InformationAction Continue
    Push-Location $repo.FullName
    try {
      git gc --aggressive
    }
    catch {
      Write-Warning "Failed to run 'git gc --aggressive' in $($repo.FullName): $_"
    }
    finally {
      Pop-Location
    }
  }
}

# Clean all my clouds
function CleanAllClouds {
  Write-Output "Starting cloud cleanup..."

  try {
    Write-Output "Cleaning up Mega cloud..."
    rclone cleanup -v mega:

    Write-Output "Cleaning up Google Drive..."
    rclone cleanup -v gdrive:

    Write-Output "Cleaning up OneDrive..."
    rclone cleanup -v onedrive:

    Write-Output "Cleaning up Dropbox..."
    rclone cleanup -v dropbox:

    Write-Output "Cloud cleanup completed successfully!"
  }
  catch {
    Write-Output "Error during cleanup: $_"
  }
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

function FreeLeechTorrents {
  yoink --config "$HOME\Мой` диск\документы\configs\yoink.yaml"
}

function CleanTorrents {
  autoremove-torrents --conf="$HOME\Мой` диск\документы\configs\autoremove-torrents.yaml" --log=$HOME\Downloads
}

function FixSystem {
  gsudo {
    sfc /scannow
    dism /Online /Cleanup-Image /RestoreHealth
  }
}

<#
    This function is designed to receive a backup file from Firefox on Android using port forwarding via adb.
    Repository: https://github.com/Rob--W/firefox-android-backup-restore
    The repository provides tools and scripts for backing up and restoring Firefox data on Android devices.

    EXAMPLES:
    # Default usage (saves to firefox-android-backup.tar.gz and listens on port 12101)
    Receive-FirefoxAndroidBackup

    # Custom usage (specify output file and port)
    Receive-FirefoxAndroidBackup -OutputFile "backup.tar.gz" -Port 12101
#>
# TODO: add this function to https://github.com/Rob--W/firefox-android-backup-restore
function Receive-FirefoxAndroidBackup {
  [CmdletBinding()]
  param (
    [string]$OutputFile = "firefox-android-backup.tar.gz",
    [int]$Port = 12101
  )

  # Step 1: Set up port forwarding with adb
  Write-Output "Setting up port forwarding with adb on port $Port..."
  # TODO: https://github.com/microsoft/winget-cli/issues/2711#issuecomment-1322541409 https://github.com/microsoft/winget-pkgs/issues/195087 https://github.com/microsoft/winget-cli/issues/4053 https://github.com/microsoft/winget-pkgs/pull/190804#issuecomment-2482537219
  #adb reverse tcp:$Port tcp:$Port
  # TODO: test this with adb from choco/scoop
  where.exe adb | ForEach-Object {
    $adbPath = (Get-Item $_).Target ?? $_
    Start-Process $adbPath -ArgumentList "reverse tcp:$Port tcp:$Port" -NoNewWindow -Wait
  }

  # Step 2: Start a listener on localhost and save incoming data to a file
  Write-Output "Starting listener on 127.0.0.1:$Port..."
  $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Parse("127.0.0.1"), $Port)
  $listener.Start()

  try {
    # Wait for the client to connect
    Write-Output "Waiting for incoming connection..."
    $client = $listener.AcceptTcpClient()
    Write-Output "Client connected. Receiving data..."

    # Get the network stream
    $stream = $client.GetStream()

    # Create a file stream to save the incoming data
    $fileStream = [System.IO.File]::Create($OutputFile)

    # Buffer to store the received bytes
    $buffer = New-Object byte[] 1024
    $totalBytesRead = 0

    # Read data from the stream and write it to the file
    while (($bytesRead = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
      $fileStream.Write($buffer, 0, $bytesRead)
      $totalBytesRead += $bytesRead
    }

    Write-Output "Backup received successfully. Total bytes: $totalBytesRead."
    Write-Output "Saved to: $OutputFile"

  }
  catch {
    Write-Error "An error occurred: $_"
  }
  finally {
    # Clean up resources
    if ($fileStream) { $fileStream.Close() }
    if ($stream) { $stream.Close() }
    if ($client) { $client.Close() }
    $listener.Stop()
    Write-Output "Listener stopped. Connection closed."
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
function YoutubeExtractAllUrlsFromPlaylist { yt-dlp $args --skip-download --no-warning --print webpage_url }

function mkd { mkdir $args[0] 2>$null; Set-Location $args[0] }
function mps { multipass stop }
function proxinjector_cli { & "$env:APPDATA\proxinject\proxinjector-cli.exe" $args }
function what_blocks_sleep { gsudo { powercfg -requests } }
function backup { pwsh $HOME\git\dotfiles_windows\scripts\backup-script.ps1 }


# https://github.com/canonical/multipass/issues/3112
# https://gist.github.com/stoneage7/9df39cfac2c28932ed86
function MultipassSetDiscard {
  # Enables the 'discard' option on the primary VM's SATA storage controller
  gsudo {
    psexec -s "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe" `
      storageattach primary `
      --storagectl "SATA_0" `
      --port 0 `
      --device 0 `
      --nonrotational on `
      --discard on
  }
}

function MultipassShowVmInfo {
  # Displays detailed information about the primary VM in machine-readable format
  gsudo {
    psexec -s "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe" `
      showvminfo primary `
      --machinereadable
  }
}

function MultipassDeletePortForward {
  param (
    [string]$name # Name of the port forwarding rule to delete
  )

  # Deletes the specified NAT port forwarding rule from the primary VM
  gsudo {
    psexec -s "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe" `
      modifyvm primary `
      --natpf1 delete $name
  }
}

function MultipassExportLogsFromLastHour {
  # Exports Multipass-related application logs from the last hour to a file
  Get-WinEvent -FilterHashtable @{
    LogName      = 'Application'
    ProviderName = 'Multipass'
    StartTime    = (Get-Date).AddHours(-1)
  } | Out-File -FilePath "$HOME\Multipass-logs-from-last-hour.log"
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
