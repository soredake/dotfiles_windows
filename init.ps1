. $env:r\function.ps1
$env:a = "$env:TEMP\dotfiles.zip"
$env:r = "$HOME\git\dotfiles_windows"
$env:t = "$HOME\git\dotfiles_windows-master"

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
# TODO: Install git early and just clone the repo with it?
New-Item -Path $env:r -ItemType Directory
Invoke-WebRequest -Uri "https://github.com/soredake/dotfiles_windows/archive/refs/heads/master.zip" -OutFile $env:a
# TODO: why deleting $env:t is needed here?
Remove-Item -Recurse -Path $env:r,$env:t
Expand-Archive $env:a -DestinationPath ~/git
Move-Item –Path $env:t\* -Destination $env:r
# TODO: delete them in one command
Remove-Item -Path $env:a
# TODO: this folder should be empty so there is should be no need to delete it
Remove-Item -Path $env:t -Force

# TODO: install gsudo from scoop
# winget install -h --accept-package-agreements --accept-source-agreements Microsoft.PowerShell
# replace pwsh with store versions once WUA is not needed anymore
# or replace it with https://github.com/PowerShell/PowerShell-RFC/pull/324 https://devblogs.microsoft.com/powershell/powershell-openssh-team-investments-for-2023/
# -NoNewWindow
sudo config CacheMode Auto
# TODO: once gsudo is installed from scoop replace this with sudo command
Start-Process -Wait powershell -ArgumentList "-c . $env:r\function.ps1; Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); reloadenv; choco install -y gsudo; choco install -y --pin powershell-core" -Verb runAs
reloadenv

pwsh $env:r\setup.ps1
