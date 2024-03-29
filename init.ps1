$env:r = "$HOME\git\dotfiles_windows"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
setx PIPX_BIN_DIR $env:LOCALAPPDATA\Programs\Python\Python312\Scripts

# Fix for winget downloading speed https://github.com/microsoft/winget-cli/issues/2124
($settings = Get-Content -Path "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Raw | ConvertFrom-Json) | ForEach-Object { if ($_.network -eq $null) { $_ | Add-Member -MemberType NoteProperty -Name 'network' -Value (New-Object PSObject) -Force }; $_.network | Add-Member -MemberType NoteProperty -Name 'downloader' -Value 'wininet' -Force }; $settings | ConvertTo-Json | Set-Content -Path "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"

# https://github.com/ScoopInstaller/Install/issues/70
where.exe scoop
if (-not $?) {
  Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

scoop config use_external_7zip true
scoop install gsudo
sudo config CacheMode Auto

sudo {
  # https://github.com/microsoft/winget-cli/issues/3077 https://github.com/microsoft/winget-cli/issues/549#issuecomment-1675410316 https://github.com/microsoft/winget-cli/issues/222#issuecomment-1675434402
  winget install --no-upgrade -h --accept-source-agreements WingetPathUpdater

  # Install git with machine scope until their installer will have support for user scope https://github.com/git-for-windows/git/discussions/4399#discussioncomment-5877325 https://github.com/microsoft/winget-cli/issues/3240
  winget install --no-upgrade --scope machine -h --accept-package-agreements --accept-source-agreements Git.Git --custom '"/COMPONENTS=`"icons,assoc,assoc_sh,,,,gitlfs,icons\quicklaunch`" /o:SSHOption=ExternalOpenSSH"'

  # Repository needs to be cloned in this scope in order for git to be in PATH until git installer gains support for per-user non-uac install
  git clone "https://github.com/soredake/dotfiles_windows" $env:r
}

winget install -h --accept-package-agreements 9MZ1SNWT0N5D
pwsh $env:r\setup.ps1
