# Documents folder are moved to OneDrive
$documentsPath = [Environment]::GetFolderPath('MyDocuments')

Import-Module -Name (Get-ChildItem $documentsPath\PowerShell\Modules)
Import-Module -Name gsudoModule
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\pure.omp.json" | Invoke-Expression

# No more cursor blinking https://github.com/microsoft/terminal/issues/1379#issuecomment-821825557 https://github.com/fish-shell/fish-shell/issues/3741#issuecomment-273209823 https://github.com/microsoft/terminal/issues/1379
Write-Output "`e[6 q"

function checklinks {
  # https://github.com/lycheeverse/lychee/issues/972
  Push-Location "$HOME\Мій диск"
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
