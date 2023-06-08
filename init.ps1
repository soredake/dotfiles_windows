$env:r = "$HOME\git\dotfiles_windows"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
irm get.scoop.sh | iex
scoop install gsudo
# replace pwsh with store versions once WUA is not needed anymore or replace it with https://github.com/PowerShell/PowerShell-RFC/pull/324 https://devblogs.microsoft.com/powershell/powershell-openssh-team-investments-for-2023/
sudo config CacheMode Auto
sudo "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
Get-ChildItem -Path "C:\ProgramData\chocolatey\helpers\functions" -Filter *.ps1 | ForEach-Object { . $_.FullName }
refreshenv
sudo "choco install -y --pin powershell-core; choco install -y git.install --params '/NoShellHereIntegration /NoOpenSSH'"
refreshenv # https://github.com/chocolatey/choco/issues/2458
git clone "https://github.com/soredake/dotfiles_windows" $env:r
pwsh $env:r\setup.ps1

protonvpn installer on windows: add option to skip launch after fresh installation

https://github.com/microsoft/winget-pkgs/blob/b47e9d69ec954ee5d5e759708b67e6df976b1f42/manifests/g/Google/Drive/75.0.3.0/Google.Drive.installer.yaml#L17

Google Drive have `--skip_launch_new` option to stop launch after installation.

Worth noting that option should prevent launch only after fresh install,  protonvpn still needs to be launched after upgrade if it was running before.
