New-Item -Path $HOME\git\dotfiles_windows -ItemType Directory
Invoke-WebRequest -Uri "https://github.com/soredake/dotfiles_windows/archive/refs/heads/master.zip" -OutFile "$env:TEMP/dotfiles.zip"
Expand-Archive "$env:TEMP/dotfiles" -DestinationPath $HOME\git\dotfiles_windows

winget install -h --accept-package-agreements --accept-source-agreements Microsoft.PowerShell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
pwsh .\setup.ps1

Remove-Item -Path "$env:TEMP/dotfiles.zip"
