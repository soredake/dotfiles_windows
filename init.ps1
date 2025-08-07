$env:repository = "$HOME\git\dotfiles_windows"

# If repo is already there just update it and run script again
if (Test-Path $env:repository\setup.ps1) {
  Set-Location $env:repository
  git pull
  pwsh -NoProfile .\setup.ps1
}

# https://github.com/ScoopInstaller/Extras/issues/13073
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/badrelmers/RefrEnv/main/refrenv.ps1" -OutFile "$HOME/refrenv.ps1"

# Git, PowerShellCore and SophiaScript installation
winget install -h --accept-package-agreements --accept-source-agreements 9mz1snwt0n5d TeamSophia.SophiaScript Git.Git

# Refresh env so git will be present in PATH
. "$HOME/refrenv.ps1"

git clone "https://github.com/soredake/dotfiles_windows" $env:repository
pwsh -NoProfile $env:repository\setup.ps1
