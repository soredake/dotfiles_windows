$downloadsPath = "$env:USERPROFILE\Downloads"

# Define folders to exclude from deletion
$excludeFolders = @("64Gram Desktop", "TabSessionManager - Backup", "archive")

# Get all files and directories in the Downloads folder
Get-ChildItem -Path $downloadsPath -Recurse -Force |
Where-Object {
  # Exclude specified folders
  ($_.PSIsContainer -and ($excludeFolders -contains $_.Name)) -or
  # Delete if older than 31 days
  ($_.LastWriteTime -lt (Get-Date).AddDays(-31))
} |
ForEach-Object {
  if ($_.PSIsContainer) {
    # Clear contents of excluded folders if older than 31 days
    Get-ChildItem $_.FullName -Recurse -Force |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-31) } |
    Remove-Item -Force -Recurse
  }
  else {
    # Delete files and non-excluded folders
    Remove-Item $_.FullName -Force -Recurse
  }
}
