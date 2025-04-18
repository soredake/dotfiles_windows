$downloadsPath = "$env:USERPROFILE\Downloads"

# Define folders that should not be deleted entirely but should have their contents cleaned
$excludeFolders = @("64Gram Desktop", "TabSessionManager - Backup", "archive")

# Define a helper function to check for unwanted attributes or filenames
function Should-SkipItem($item) {
  return $item.Name -ieq "desktop.ini" -or
  $item.Attributes.HasFlag([System.IO.FileAttributes]::Hidden) -or
  $item.Attributes.HasFlag([System.IO.FileAttributes]::System) -or
  $item.Attributes.HasFlag([System.IO.FileAttributes]::Archive)
}

# Filter to delete files and folders older than 31 days, excluding protected items
Get-ChildItem -Path $downloadsPath -Recurse -Force |
Where-Object {
  -not (Should-SkipItem $_) -and
  -not ($_.PSIsContainer -and ($excludeFolders -contains $_.Name)) -and
    ($_.LastWriteTime -lt (Get-Date).AddDays(-31))
} |
ForEach-Object {
  Remove-Item $_.FullName -Force -Recurse -ErrorAction SilentlyContinue
}

# Clean up the contents of the excluded folders
foreach ($folder in $excludeFolders) {
  $folderPath = Join-Path -Path $downloadsPath -ChildPath $folder
  if (Test-Path $folderPath) {
    Get-ChildItem -Path $folderPath -Recurse -Force |
    Where-Object {
      -not (Should-SkipItem $_) -and
      $_.LastWriteTime -lt (Get-Date).AddDays(-31)
    } |
    Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
  }
}
