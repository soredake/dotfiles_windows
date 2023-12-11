$env:r = "$HOME\git\dotfiles_windows"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
irm get.scoop.sh | iex
scoop install gsudo
sudo config CacheMode Auto
sudo { irm https://community.chocolatey.org/install.ps1 -useb | iex }
Get-ChildItem -Path "C:\ProgramData\chocolatey\helpers\functions" -Filter *.ps1 | ForEach-Object { . $_.FullName }
refreshenv
sudo { winget install --no-upgrade -h WingetPathUpdater # https://github.com/microsoft/winget-cli/issues/3077 https://github.com/microsoft/winget-cli/issues/549#issuecomment-1675410316 https://github.com/microsoft/winget-cli/issues/222#issuecomment-1675434402
  # Install git with machine scope until their installer will have support for user scope https://github.com/git-for-windows/git/discussions/4399#discussioncomment-5877325
  winget install --no-upgrade --scope machine -h --accept-package-agreements --accept-source-agreements Git.Git --custom '"/COMPONENTS=`"icons,assoc,assoc_sh,,,,gitlfs,icons\quicklaunch`" /o:SSHOption=ExternalOpenSSH"' # TODO: enable externalopenssh by default on >=win10?
  # replace it with https://github.com/PowerShell/PowerShell-RFC/pull/324 https://devblogs.microsoft.com/powershell/powershell-openssh-team-investments-for-2023/
  winget install --no-upgrade -h Microsoft.PowerShell }
# refreshenv # https://github.com/chocolatey/choco/issues/2458
git clone "https://github.com/soredake/dotfiles_windows" $env:r
pwsh $env:r\setup.ps1
