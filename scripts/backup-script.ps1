$host.ui.RawUI.WindowTitle = "Backup task"

$env:ESSD = (Get-Volume -FileSystemLabel "ExternalSSDVentoy 256gb").DriveLetter

# Moving unsorted files back to main folder
Get-ChildItem "$HOME\Мой диск\unsorted" -Recurse -File | ForEach-Object {
  $destFile = "$HOME\Мой диск\$($_.Name)"

  while (Test-Path $destFile) {
    $destFile = "$HOME\Мой диск\$([System.IO.Path]::GetFileNameWithoutExtension($_.Name))_$((Get-Random -Maximum 9999))$([System.IO.Path]::GetExtension($_.Name))"
  }

  Move-Item $_.FullName $destFile
}

# https://superuser.com/questions/544336/incremental-backup-with-7zip
# Software
Write-Output "`n`e[33mStarting software backup...`n`e[0m"
rclone sync -P "${env:ProgramFiles(x86)}\FanControl\Configurations" "$HOME\Мой диск\документы\backups\fancontrol"
rclone sync -P $env:APPDATA\syncplay.ini "$HOME\Мой диск\документы\backups\syncplay"
rclone sync -P "$HOME\.ssh" "$HOME\Мой диск\документы\backups\ssh"

if (Test-Path -Path "${env:ESSD}:\") {
  # Backing up my google drive folder to external SSD
  Write-Output "`n`e[33mStarting mirroring google drive folder to external disk...`n`e[0m"
  rclone sync -P --progress-terminal-title "$HOME\Мой диск" ${env:ESSD}:\main --delete-before --delete-excluded --exclude ".tmp.drive*/" --exclude-from "$HOME\Мой диск\документы\configs\rclone-gdrive-exclude-list.txt"
}

# Backing up my google drive folder to mega cloud
Write-Output "`n`e[33mStarting mirroring google drive folder to mega cloud...`n`e[0m"
rclone sync -P --progress-terminal-title "$HOME\Мой диск" mega:main --delete-before --delete-excluded --exclude ".tmp.drive*/" --exclude-from "$HOME\Мой диск\документы\configs\rclone-gdrive-exclude-list.txt"

# Backing up my Documents folder to onedrive and dropbox cloud
Write-Output "`n`e[33mStarting mirroring Documents folder to onedrive and dropbox clouds...`n`e[0m"
rclone sync -P --progress-terminal-title "$HOME\Мой диск\документы" onedrive:main --delete-before --delete-excluded --exclude-from "$HOME\Мой диск\документы\configs\rclone-onedrive-dropbox-exclude-list.txt"
rclone sync -P --progress-terminal-title "$HOME\Мой диск\документы" dropbox:main --delete-before --delete-excluded --exclude-from "$HOME\Мой диск\документы\configs\rclone-onedrive-dropbox-exclude-list.txt"

# Deduping clouds
Write-Output "`n`e[33mStarting dedupe process for all clouds...`n`e[0m"
rclone dedupe -P --dedupe-mode newest mega:/
rclone dedupe -P --dedupe-mode newest googledrive:/
