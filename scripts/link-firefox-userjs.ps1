# Get the default Firefox profile folder name from profiles.ini
$profileIniPath = Join-Path $env:APPDATA 'Mozilla\Firefox\profiles.ini'

# Find the profile marked as Default=1, then retrieve the preceding line which contains the profile folder name
$defaultProfileLine = Get-Content $profileIniPath |
    Select-String -Pattern 'Default=1' -Context 1 |
    ForEach-Object { $_.Context.PreContext[0] } |
    Select-String '(Profiles).*'

# Extract the profile folder name (e.g., "Profiles/xxxxx.default-release")
$env:FirefoxDefaultProfile = $defaultProfileLine.Matches.Value

# Construct the full path to the Firefox default profile directory
$env:FirefoxDefaultProfilePath = Join-Path $env:APPDATA "Mozilla\Firefox\$env:FirefoxDefaultProfile"

# Remove the existing user.js file from the Firefox profile, if it exists
Remove-Item -Path "$env:FirefoxDefaultProfilePath\user.js" -ErrorAction SilentlyContinue

# Create a symbolic link to your custom user.js file stored in your dotfiles repo
# `gsudo` is used to elevate privileges if necessary
gsudo {
    New-Item -ItemType SymbolicLink `
             -Path "$env:FirefoxDefaultProfilePath\user.js" `
             -Target "$HOME\git\dotfiles_windows\user.js"
}
