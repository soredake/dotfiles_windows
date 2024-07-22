$env:repository = "$HOME\git\dotfiles_windows"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# If repo is already there just update it and run script again
if (Test-Path $env:repository\setup.ps1) {
  Set-Location $env:repository
  git pull
  pwsh .\setup.ps1
}

# https://github.com/ScoopInstaller/Extras/issues/13073
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/badrelmers/RefrEnv/main/refrenv.ps1" -OutFile "$HOME/refrenv.ps1"

# PowerShellCore installation
winget install -h --accept-package-agreements 9MZ1SNWT0N5D

# https://github.com/ScoopInstaller/Install/issues/70
# scoop installation and configuration
where.exe scoop
if (-not $?) {
  Invoke-RestMethod get.scoop.sh | Invoke-Expression
}
scoop config use_external_7zip true
scoop config use_sqlite_cache true

# gsudo installation and configuration
scoop install gsudo
sudo config CacheMode Auto

sudo {
  # Enabling proxy support
  # https://github.com/microsoft/winget-cli/blob/master/schemas/JSON/settings/settings.export.schema.0.1.json
  winget settings --enable ProxyCommandLineOptions

  # https://remontka.pro/enable-developer-mode-windows/
  # Developer Mode is needed to create symlinks in winget without admin rights, adding to PATH approach have problems https://github.com/microsoft/winget-cli/issues/4044 https://github.com/microsoft/winget-cli/issues/3601 https://github.com/microsoft/winget-cli/issues/361
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"

  # https://github.com/microsoft/winget-cli/issues/3077 https://github.com/microsoft/winget-cli/issues/549#issuecomment-1675410316 https://github.com/microsoft/winget-cli/issues/222#issuecomment-1675434402
  winget install --no-upgrade -h --accept-source-agreements WingetPathUpdater

  # Install git with machine scope until their installer will have support for user scope https://github.com/git-for-windows/git/discussions/4399#discussioncomment-5877325 https://github.com/microsoft/winget-cli/issues/3240
  # https://github.com/git-for-windows/build-extra/blob/fb58c8e26c584fd88369b886e8c9a6454ace61e2/installer/install.iss#L103-L115
  winget install --no-upgrade --scope machine -h --accept-package-agreements --accept-source-agreements Git.Git --custom '"/COMPONENTS=`"icons,assoc,assoc_sh,,,,gitlfs,icons\quicklaunch`" /o:SSHOption=ExternalOpenSSH"'
}

# Refresh env so git will be present in PATH
. "$HOME/refrenv.ps1"

git clone "https://github.com/soredake/dotfiles_windows" $env:repository
pwsh $env:repository\setup.ps1

