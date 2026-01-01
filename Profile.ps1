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
# https://github.com/j-hc/revanced-magisk-module
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

function Toggle-TelegramLaunch {
  param(
    [string]$Path = "$env:APPDATA\Telegram Desktop\Telegram.exe"
  )

  if (-not (Test-Path $Path)) {
    Write-Host "Telegram.exe not found at: $Path"
    return
  }

  $acl = Get-Acl $Path
  $user = "$env:USERDOMAIN\$env:USERNAME"

  # detect any Deny containing ExecuteFile or ReadAndExecute
  $denyRule = $acl.Access | Where-Object {
    $_.IdentityReference -eq $user -and
    $_.AccessControlType -eq "Deny" -and
    ($_.FileSystemRights.ToString() -match "Execute" -or $_.FileSystemRights.ToString() -match "ReadAndExecute")
  }

  if ($denyRule) {
    Write-Host "Currently: DISALLOWED. Removing Deny rule(s)..."
    foreach ($rule in $denyRule) {
      $acl.RemoveAccessRule($rule) | Out-Null
    }
    Set-Acl -Path $Path -AclObject $acl
    Write-Host "Telegram LAUNCHING is now ALLOWED."
  }
  else {
    Write-Host "Currently: ALLOWED. Adding Deny for ReadAndExecute..."
    $newRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
      $user,
      "ReadAndExecute",
      "Deny"
    )
    $acl.AddAccessRule($newRule) | Out-Null
    Set-Acl -Path $Path -AclObject $acl
    Write-Host "Telegram LAUNCHING is now BLOCKED."
  }
}

function iauploadcheckderive { ia upload --checksum --verify --retries 50 --no-backup $args }
function iauploadfastderive { ia upload --verify --retries 50 --no-backup $args }
function iauploadcheck { ia upload --checksum --verify --retries 50 --no-backup --no-derive $args }
function iauploadfast { ia upload --verify --retries 50 --no-backup --no-derive $args }

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
