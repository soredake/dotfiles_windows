$env:r = "$HOME\git\dotfiles_windows"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# https://github.com/ScoopInstaller/Extras/issues/13073
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/badrelmers/RefrEnv/main/refrenv.ps1" -OutFile "$HOME/refrenv.ps1"

# Link winget settings early
# Fix for winget downloading speed https://github.com/microsoft/winget-cli/issues/2124
# sideBySide feature currently is bugged: https://github.com/microsoft/winget-cli/issues/4354 https://github.com/microsoft/winget-cli/issues/4357 https://github.com/microsoft/winget-cli/issues/4425
New-Item -ItemType HardLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Target "$HOME\git\dotfiles_windows\winget-settings.json"

# https://github.com/ScoopInstaller/Install/issues/70
# scoop installation and configuration
where.exe scoop
if (-not $?) {
  Invoke-RestMethod get.scoop.sh | Invoke-Expression
}
scoop config use_external_7zip true

# Gsudo installation and configuration
scoop install gsudo
sudo config CacheMode Auto

sudo {
  # Enabling proxy support
  winget settings --enable ProxyCommandLineOptions

  # https://remontka.pro/enable-developer-mode-windows/
  # Developer Mode is needed to create symlinks in winget without admin rights, adding to PATH approach have problems https://github.com/microsoft/winget-cli/issues/4044 https://github.com/microsoft/winget-cli/issues/3601 https://github.com/microsoft/winget-cli/issues/361
  reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"

  # https://github.com/microsoft/winget-cli/issues/3077 https://github.com/microsoft/winget-cli/issues/549#issuecomment-1675410316 https://github.com/microsoft/winget-cli/issues/222#issuecomment-1675434402
  winget install --no-upgrade -h --accept-source-agreements WingetPathUpdater

  # Install git with machine scope until their installer will have support for user scope https://github.com/git-for-windows/git/discussions/4399#discussioncomment-5877325 https://github.com/microsoft/winget-cli/issues/3240
  # https://github.com/git-for-windows/build-extra/blob/fb58c8e26c584fd88369b886e8c9a6454ace61e2/installer/install.iss#L103-L115
  winget install --no-upgrade --scope machine -h --accept-package-agreements --accept-source-agreements Git.Git --custom '"/COMPONENTS=`"icons,assoc,assoc_sh,,,,gitlfs,icons\quicklaunch`" /o:SSHOption=ExternalOpenSSH"'

  # Repository needs to be cloned in this scope in order for git to be in PATH until git installer gains support for per-user non-uac install
  git clone "https://github.com/soredake/dotfiles_windows" $env:r
}

winget install -h --accept-package-agreements 9MZ1SNWT0N5D
pwsh $env:r\setup.ps1
