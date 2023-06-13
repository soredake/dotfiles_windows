$env:r = "$HOME\git\dotfiles_windows"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
irm get.scoop.sh | iex
scoop install gsudo
# replace pwsh with store versions once WUA is not needed anymore or replace it with https://github.com/PowerShell/PowerShell-RFC/pull/324 https://devblogs.microsoft.com/powershell/powershell-openssh-team-investments-for-2023/
sudo config CacheMode Auto
sudo { iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) }
Get-ChildItem -Path "C:\ProgramData\chocolatey\helpers\functions" -Filter *.ps1 | ForEach-Object { . $_.FullName }
refreshenv
sudo winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements Git.Git --custom '"/COMPONENTS=`"icons,assoc,assoc_sh,,,,gitlfs,icons\quicklaunch`" /o:SSHOption=ExternalOpenSSH"'
sudo choco install -y --pin powershell-core
refreshenv # https://github.com/chocolatey/choco/issues/2458
git clone "https://github.com/soredake/dotfiles_windows" $env:r
pwsh $env:r\setup.ps1
