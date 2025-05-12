# Documents folder are moved to OneDrive
$documentsPath = [Environment]::GetFolderPath('MyDocuments')

Import-Module -Name (Get-ChildItem $documentsPath\PowerShell\Modules)
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

# Clean all my clouds
function CleanAllClouds {
  Write-Output "Starting cloud cleanup..."

  try {
    Write-Output "Cleaning up Mega cloud..."
    rclone cleanup -v mega:

    Write-Output "Cleaning up Google Drive..."
    rclone cleanup -v googledrive:

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

# Clean all git branches except main|master
function Remove-GitBranch {
  [CmdletBinding(SupportsShouldProcess)] # Enables ShouldProcess and WhatIf/Confirm
  param (
    [string[]]$KeepBranches = @("main", "master") # List of branches to preserve
  )

  # Check if the current directory is a Git repository
  if (-not (Test-Path ".git")) {
    Write-Error "Not a Git repository."
    return
  }

  # Fetch the latest changes and clean up remote tracking references
  git fetch --all --prune

  # Find the target branch to switch to (prefer "main" over "master")
  $targetBranch = ($KeepBranches | Where-Object { git branch --list $_ })[0]
  if (-not $targetBranch) {
    Write-Error "No 'main' or 'master' branch found."
    return
  }

  # Switch to the target branch if not already on it
  if ((git rev-parse --abbrev-ref HEAD) -ne $targetBranch) {
    if ($PSCmdlet.ShouldProcess("Switch to branch '$targetBranch'")) {
      git checkout $targetBranch
      Write-Verbose "Checked out to branch '$targetBranch'."
    }
  }

  # Get the list of all local branches
  $localBranches = git branch --format "%(refname:short)"

  # Iterate over all local branches and delete those not in the keep list
  foreach ($branch in $localBranches) {
    if ($KeepBranches -notcontains $branch) {
      if ($PSCmdlet.ShouldProcess("Delete branch '$branch'")) {
        Write-Verbose "Deleting branch: $branch"
        git branch -D $branch
      }
    }
  }

  # Clean up remote-tracking branches that are fully merged
  git branch -r --merged origin/$targetBranch | ForEach-Object {
    $remoteBranch = ($_ -replace "origin/", "").Trim()
    if ($KeepBranches -notcontains $remoteBranch) {
      if ($PSCmdlet.ShouldProcess("Delete remote-tracking branch '$remoteBranch'")) {
        Write-Verbose "Deleting remote-tracking branch: $remoteBranch"
        git push origin --delete $remoteBranch
      }
    }
  }
}

function iauploadcheckderive { ia upload --checksum --verify --retries 50 --no-backup $args }
function iauploadfastderive { ia upload --verify --retries 50 --no-backup $args }
function iauploadcheck { ia upload --checksum --verify --retries 50 --no-backup --no-derive $args }
function iauploadfast { ia upload --verify --retries 50 --no-backup --no-derive $args }
function iauploadveryfast { ia upload --retries 50 --no-backup --no-derive $args }

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
function mps { multipass stop }

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

# git status in winget-pkgs repo is slow
# https://github.com/dahlbyk/posh-git?tab=readme-ov-file#customization-variables
$GitPromptSettings.RepositoriesInWhichToDisableFileStatus += "$HOME\git\winget-pkgs"

# https://github.com/microsoft/inshellisense?tab=readme-ov-file#shell-plugin
# NOTE: sourcing inshellisense somehow breaks pwsh running as admin
# NOTE: https://github.com/microsoft/inshellisense/issues/9
# if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -and (Test-Path '~/.inshellisense/pwsh/init.ps1' -PathType Leaf)) {
#   . ~/.inshellisense/pwsh/init.ps1
# }
