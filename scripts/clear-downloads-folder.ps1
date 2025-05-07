# === CONFIGURATION ===
$ExcludedFolders = @("archive", "64Gram Desktop", "TabSessionManager - Backup", "Telegram Desktop")
$DownloadsPath = "$env:USERPROFILE\Downloads"
$MaxAgeDays = 31
$CutoffDate = (Get-Date).AddDays(-$MaxAgeDays)

# === FUNCTIONS ===
function Log {
  param([string]$Message)
  Write-Host $Message
}

function Try-DeleteFolder {
  param([string]$FolderPath)

  $Retry = $false
  try {
    Remove-Item -LiteralPath $FolderPath -Recurse -Force -ErrorAction Stop
    Start-Sleep -Milliseconds 300
    if (Test-Path $FolderPath) {
      $Retry = $true
    }
  }
  catch {
    $Retry = $true
    Log "⚠️ Ошибка при удалении '$FolderPath': $_"
  }

  if ($Retry) {
    try {
      Remove-Item -LiteralPath $FolderPath -Recurse -Force -ErrorAction Stop
      Start-Sleep -Milliseconds 300
      if (Test-Path $FolderPath) {
        Log "❌ Не удалось удалить папку даже после повторной попытки: $FolderPath"
      }
      else {
        Log "🗂️ Повторно удалена папка: $FolderPath"
      }
    }
    catch {
      Log "❌ Ошибка при повторной попытке удаления '$FolderPath': $_"
    }
  }
  else {
    Log "🗂️ Удалена папка: $FolderPath"
  }
}

function Remove-Folders {
  param([string]$Path)

  Get-ChildItem -Path $Path -Directory -Force | ForEach-Object {
    $Folder = $_
    $FolderName = $Folder.Name

    if ($ExcludedFolders -contains $FolderName) {
      Log "⏭️ Пропущена папка: $FolderName"
      Get-ChildItem -Path $Folder.FullName -Force | ForEach-Object {
        if ($_.Name -ieq "desktop.ini" -or $_.Attributes -match "Hidden|System") {
          Log "   🔒 Пропущен файл: $($_.Name)"
        }
        elseif ($_.LastWriteTime -gt $CutoffDate) {
          Log "   ⌛ Пропущен по дате: $($_.Name)"
        }
        else {
          try {
            if ($_.PSIsContainer) {
              Try-DeleteFolder -FolderPath $_.FullName
            }
            else {
              Remove-Item -LiteralPath $_.FullName -Force -ErrorAction Stop
              Log "   🗑️ Удален файл: $($_.Name)"
            }
          }
          catch {
            Log "   ⚠️ Ошибка при удалении '$($_.FullName)': $_"
          }
        }
      }
    }
    else {
      if ($Folder.LastWriteTime -gt $CutoffDate) {
        Log "⌛ Пропущена по дате: $FolderName"
      }
      else {
        $FileCount = (Get-ChildItem -Path $Folder.FullName -Recurse -Force -File | Where-Object {
            $_.Name -ne "desktop.ini" -and $_.Attributes -notmatch "Hidden|System" -and $_.LastWriteTime -le $CutoffDate
          }).Count
        Log "📁 Подготовка к удалению '$FolderName' — файлов старше $MaxAgeDays дней: $FileCount"
        Try-DeleteFolder -FolderPath $Folder.FullName
      }
    }
  }
}

function Remove-FilesInRoot {
  param([string]$Path)

  Get-ChildItem -Path $Path -File -Force | ForEach-Object {
    if ($_.Name -ieq "desktop.ini" -or $_.Attributes -match "Hidden|System") {
      Log "🔒 Пропущен файл в корне: $($_.Name)"
    }
    elseif ($_.LastWriteTime -gt $CutoffDate) {
      Log "⌛ Пропущен по дате файл: $($_.Name)"
    }
    else {
      try {
        Remove-Item -LiteralPath $_.FullName -Force -ErrorAction Stop
        Log "🗑️ Удалён файл в корне: $($_.Name)"
      }
      catch {
        Log "⚠️ Ошибка при удалении файла '$($_.FullName)': $_"
      }
    }
  }
}

# === START ===
Log "🚀 Очистка содержимого '$DownloadsPath', не изменявшегося последние $MaxAgeDays дней"
Remove-FilesInRoot -Path $DownloadsPath
Remove-Folders -Path $DownloadsPath
Log "✅ Завершено"
