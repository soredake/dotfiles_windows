$env:r = "$HOME\git\dotfiles_windows"
$env:z = "$env:TEMP/dotfiles.zip"
$env:t = "$HOME\git\dotfiles_windows-master"

Remove-Item -Recurse -Path $env:r,$env:t

Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
New-Item -Path $env:r -ItemType Directory
Invoke-WebRequest -Uri "https://github.com/soredake/dotfiles_windows/archive/refs/heads/master.zip" -OutFile $env:z
Expand-Archive $env:z -DestinationPath ~/git
Move-Item –Path $env:t\* -Destination $env:r
. $env:r\function.ps1

# winget install -h --accept-package-agreements --accept-source-agreements Microsoft.PowerShell
# replace pwsh with store versions once WUA is not needed anymore
# -NoNewWindow
Start-Process -Wait powershell -ArgumentList "-c . $env:r\function.ps1; Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); reloadenv; choco install -y gsudo; choco install -y --pin powershell-core" -Verb runAs
reloadenv
sudo config CacheMode Auto

pwsh $env:r\setup.ps1

Remove-Item -Path $env:z
Remove-Item -Recurse -Path $env:t -Force
