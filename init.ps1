. $env:r\function.ps1
$env:r = "$HOME\git\dotfiles_windows"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
Invoke-RestMethod get.scoop.sh | Invoke-Expression
scoop install gsudo
# winget install -h --accept-package-agreements --accept-source-agreements Microsoft.PowerShell
# replace pwsh with store versions once WUA is not needed anymore
# or replace it with https://github.com/PowerShell/PowerShell-RFC/pull/324 https://devblogs.microsoft.com/powershell/powershell-openssh-team-investments-for-2023/
sudo config CacheMode Auto # вызов этой команды не закеширует доступ
sudo "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
. "C:\ProgramData\chocolatey\helpers\functions\Update-SessionEnvironment.ps1" "C:\ProgramData\chocolatey\helpers\functions\Write-FunctionCallLogMessage.ps1"
Get-ChildItem -Path "C:\ProgramData\chocolatey\helpers\functions" -Filter *.ps1 | Foreach { . $_.FullName }
refreshenv 
sudo "choco install -y --pin powershell-core; choco install -y git.install --params '/NoShellHereIntegration /NoOpenSSH'"
refreshenv # https://github.com/chocolatey/choco/issues/2458
git clone "https://github.com/soredake/dotfiles_windows" $env:r
pwsh $env:r\setup.ps1

# $env:a = "$env:TEMP\dotfiles.zip"
# $env:t = "$HOME\git\dotfiles_windows-master"
# # TODO: Install git early and just clone the repo with it?
# New-Item -Path $env:r -ItemType Directory
# Invoke-WebRequest -Uri "https://github.com/soredake/dotfiles_windows/archive/refs/heads/master.zip" -OutFile $env:a
# # TODO: why deleting $env:t is needed here?
# Remove-Item -Recurse -Path $env:r,$env:t
# Expand-Archive $env:a -DestinationPath ~/git
# Move-Item –Path $env:t\* -Destination $env:r
# # TODO: delete them in one command
# Remove-Item -Path $env:a
# # TODO: this folder should be empty so there is should be no need to delete it
# Remove-Item -Path $env:t -Force
