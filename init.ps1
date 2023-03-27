$env:r = "$HOME\git\dotfiles_windows"
$env:z = "$env:TEMP/dotfiles.zip"
$env:t = ~\git\dotfiles_windows-master

New-Item -Path $env:r -ItemType Directory
Invoke-WebRequest -Uri "https://github.com/soredake/dotfiles_windows/archive/refs/heads/master.zip" -OutFile $env:z
Expand-Archive $env:z -DestinationPath ~/git
Move-Item –Path $env:t\* -Destination $env:r
. $env:r\function.ps1
reloadenv

# replace it with store versions once WUA is not needed anymore
winget install -h --accept-package-agreements --accept-source-agreements Microsoft.PowerShell

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
pwsh $env:r\setup.ps1

Remove-Item -Path $env:z
Remove-Item -Path $env:t -Force
