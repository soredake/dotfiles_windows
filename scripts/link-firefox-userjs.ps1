# Path to profiles.ini
$profileIniPath = Join-Path $env:APPDATA 'Mozilla\Firefox\profiles.ini'

# Extract the Default= path from the [Install*] section
$defaultProfileRelativePath = Get-Content $profileIniPath |
    Where-Object { $_ -match '^Default=Profiles/' } |
    ForEach-Object { ($_ -split '=', 2)[1] } |
    Select-Object -First 1

if (-not $defaultProfileRelativePath) {
    throw "Could not find Default=Profiles/... entry in profiles.ini"
}

# Store relative path in env var (optional)
$env:FirefoxDefaultProfile = $defaultProfileRelativePath

# Construct full path to the Firefox default profile directory
$env:FirefoxDefaultProfilePath = Join-Path $env:APPDATA "Mozilla\Firefox\$defaultProfileRelativePath"

# Remove existing user.js if it exists
Remove-Item -Path "$env:FirefoxDefaultProfilePath\user.js" -ErrorAction SilentlyContinue

# Create symbolic link to custom user.js
gsudo {
    New-Item -ItemType SymbolicLink `
             -Path "$env:FirefoxDefaultProfilePath\user.js" `
             -Target "$HOME\git\dotfiles_windows\user.js"
}
