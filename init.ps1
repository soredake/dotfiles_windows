$env:repository = "$HOME\git\dotfiles_windows"

# If repo and pwsh/git is already there just update it and run script again
if (Test-Path $env:repository\setup.ps1 -PathType Leaf -and (Get-Command git -ErrorAction SilentlyContinue) -and (Get-Command pwsh -ErrorAction SilentlyContinue)) {
  Set-Location $env:repository
  git pull
  pwsh -NoProfile .\setup.ps1
}

# Git and PowerShellCore installation
# https://github.com/microsoft/terminal/pull/18639
# NOTE: git - https://github.com/git-for-windows/build-extra/pull/665
# pwsh will be included in future windows releases https://github.com/PowerShell/PowerShell/issues/27565
winget install -h --accept-package-agreements --accept-source-agreements 9mz1snwt0n5d Git.Git

# Refresh env so git will be present in PATH
# NOTE: no longer needed when using pwsh https://github.com/microsoft/winget-cli/issues/549#issuecomment-4138950687
# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/badrelmers/RefrEnv/main/refrenv.ps1" -OutFile "$HOME/refrenv.ps1"
# . "$HOME/refrenv.ps1"
iwr "https://raw.githubusercontent.com/badrelmers/RefrEnv/main/refrenv.ps1" | iex

git clone "https://github.com/soredake/dotfiles_windows" $env:repository
pwsh -NoProfile $env:repository\setup.ps1
