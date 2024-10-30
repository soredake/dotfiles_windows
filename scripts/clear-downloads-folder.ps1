$downloadsPath = "$env:USERPROFILE\Downloads"

# Define folders to exclude from deletion
$excludeFolders = @("64Gram Desktop", "TabSessionManager - Backup", "archive")

# Get all files and directories in the Downloads folder
Get-ChildItem -Path $downloadsPath -Recurse -Force |
Where-Object {
  # Exclude specified folders from deletion
  -not ($_.PSIsContainer -and ($excludeFolders -contains $_.Name)) -and
  # Delete if older than 31 days
  ($_.LastWriteTime -lt (Get-Date).AddDays(-31))
} |
ForEach-Object {
  if ($_.PSIsContainer) {
    # Delete the entire folder if it's older than 31 days and not in the exclusion list
    Remove-Item $_.FullName -Force -Recurse
  }
  else {
    # Delete individual files
    Remove-Item $_.FullName -Force
  }
}

# For excluded folders, clean up old contents only
foreach ($folder in $excludeFolders) {
  $folderPath = Join-Path -Path $downloadsPath -ChildPath $folder
  if (Test-Path $folderPath) {
    Get-ChildItem -Path $folderPath -Recurse -Force |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-31) } |
    Remove-Item -Force -Recurse
  }
}
