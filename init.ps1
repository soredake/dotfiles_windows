$env:r = "$HOME\git\dotfiles_windows"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
where.exe scoop; if (-not $?) { irm get.scoop.sh | iex }
scoop config use_external_7zip true
scoop install gsudo
sudo config CacheMode Auto
sudo { winget install --no-upgrade -h --accept-source-agreements WingetPathUpdater # https://github.com/microsoft/winget-cli/issues/3077 https://github.com/microsoft/winget-cli/issues/549#issuecomment-1675410316 https://github.com/microsoft/winget-cli/issues/222#issuecomment-1675434402
  # Install git with machine scope until their installer will have support for user scope https://github.com/git-for-windows/git/discussions/4399#discussioncomment-5877325 https://github.com/microsoft/winget-cli/issues/3240
  winget install --no-upgrade --scope machine -h --accept-package-agreements --accept-source-agreements Git.Git --custom '"/COMPONENTS=`"icons,assoc,assoc_sh,,,,gitlfs,icons\quicklaunch`" /o:SSHOption=ExternalOpenSSH"'
  # repo needs to be cloned in this scope in order for git to be in PATH until git installer gains support for per-user non-uac install
  git clone "https://github.com/soredake/dotfiles_windows" $env:r }
winget install -h --accept-package-agreements 9MZ1SNWT0N5D
pwsh $env:r\setup.ps1
