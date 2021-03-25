@echo off

# mpv
del %APPDATA%\mpv\mpv.conf
del %APPDATA%\mpv\input.conf
mkdir %APPDATA%\mpv
mklink /h %APPDATA%\mpv\mpv.conf .\mpv.conf
mklink /h %APPDATA%\mpv\input.conf .\input.conf

# zsh
del C:\tools\msys64\home\user\.zshrc
mkdir C:\tools\msys64\home\user
mklink /h C:\tools\msys64\home\user\.zshrc .\.zshrc

# git
del %USERPROFILE%\.gitconfig
mklink /h %USERPROFILE%\.gitconfig .\.gitconfig
mklink /h C:\tools\msys64\home\user\.gitconfig .\.gitconfig

# microsoft windows terminal
del %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
mkdir %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
mklink /h %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json .\mswinterminal.json

powershell 'Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service'
runas /user:Administator "powershell Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service"
