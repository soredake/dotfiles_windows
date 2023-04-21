$env:r = "$HOME\git\dotfiles_windows"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
Invoke-RestMethod get.scoop.sh | Invoke-Expression
scoop install gsudo
# replace pwsh with store versions once WUA is not needed anymore or replace it with https://github.com/PowerShell/PowerShell-RFC/pull/324 https://devblogs.microsoft.com/powershell/powershell-openssh-team-investments-for-2023/
sudo config CacheMode Auto
sudo "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
Get-ChildItem -Path "C:\ProgramData\chocolatey\helpers\functions" -Filter *.ps1 | ForEach-Object { . $_.FullName }
refreshenv # 
sudo "choco install -y --pin powershell-core; choco install -y git.install --params '/NoShellHereIntegration /NoOpenSSH'"
refreshenv # https://github.com/chocolatey/choco/issues/2458
git clone "https://github.com/soredake/dotfiles_windows" $env:r
pwsh $env:r\setup.ps1
