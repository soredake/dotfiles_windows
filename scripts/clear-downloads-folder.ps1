$downloadsPath = "$env:USERPROFILE\Downloads"

# Define folders that should not be deleted entirely but should have their contents cleaned
$excludeFolders = @("64Gram Desktop", "TabSessionManager - Backup", "archive")

# Filter to delete files and folders older than 31 days, ignoring hidden items
Get-ChildItem -Path $downloadsPath -Recurse -Force |
Where-Object {
  -not $_.Attributes.HasFlag([System.IO.FileAttributes]::Hidden) -and # Exclude hidden files and folders
  -not ($_.PSIsContainer -and ($excludeFolders -contains $_.Name)) -and # Exclude specified folders
  ($_.LastWriteTime -lt (Get-Date).AddDays(-31)) # Filter by date
} |
ForEach-Object {
  Remove-Item $_.FullName -Force -Recurse
}

# Clean up the contents of the excluded folders, ignoring hidden files
foreach ($folder in $excludeFolders) {
  $folderPath = Join-Path -Path $downloadsPath -ChildPath $folder
  if (Test-Path $folderPath) {
    Get-ChildItem -Path $folderPath -Recurse -Force |
    Where-Object {
      -not $_.Attributes.HasFlag([System.IO.FileAttributes]::Hidden) -and
      $_.LastWriteTime -lt (Get-Date).AddDays(-31)
    } |
    Remove-Item -Force -Recurse
  }
}
