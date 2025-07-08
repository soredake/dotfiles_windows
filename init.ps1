$env:repository = "$HOME\git\dotfiles_windows"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# If repo is already there just update it and run script again
if (Test-Path $env:repository\setup.ps1) {
  Set-Location $env:repository
  git pull
  pwsh -NoProfile .\setup.ps1
}

# https://github.com/ScoopInstaller/Extras/issues/13073
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/badrelmers/RefrEnv/main/refrenv.ps1" -OutFile "$HOME/refrenv.ps1"

# scoop installation, https://github.com/ScoopInstaller/Install/issues/70
if (-not (gcm scoop -ea 0)) { iex (iwr get.scoop.sh -UseBasicParsing).Content }

# gsudo installation
scoop install gsudo

gsudo {
  # Enable gsudo cache
  gsudo config CacheMode Auto

  # Git, PowerShellCore and SophiaScript installation
  winget install -h --accept-package-agreements --accept-source-agreements Microsoft.PowerShell TeamSophia.SophiaScript Git.Git
}

# Refresh env so git will be present in PATH
. "$HOME/refrenv.ps1"

git clone "https://github.com/soredake/dotfiles_windows" $env:repository
pwsh -NoProfile $env:repository\setup.ps1
# TODO: switch to plain powershell? https://docs.syncthing.net/users/contrib.html#id1
