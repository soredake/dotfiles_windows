@echo off

rem mpv
del %APPDATA%\mpv\mpv.conf
del %APPDATA%\mpv\input.conf
mkdir %APPDATA%\mpv
mklink /h %APPDATA%\mpv\mpv.conf .\mpv.conf
mklink /h %APPDATA%\mpv\input.conf .\input.conf

rem zsh
del C:\tools\msys64\home\user\.zshrc
mkdir C:\tools\msys64\home\user
mklink /h C:\tools\msys64\home\user\.zshrc .\.zshrc

rem git
del %USERPROFILE%\.gitconfig
mklink /h %USERPROFILE%\.gitconfig .\.gitconfig
mklink /h C:\tools\msys64\home\user\.gitconfig .\.gitconfig

rem microsoft windows terminal
del %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
mkdir %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
mklink /h %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json .\mswinterminal.json

rem powershell 'Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service'
rem runas /user:Administator "powershell Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service"


mklink /j C:\tools\msys64\home\user\.ssh %USERPROFILE%\.ssh


rem git for windows uses wrong ssh binary which leads to errors like `Permission Denied (publickey)`
rem https://github.com/PowerShell/Win32-OpenSSH/wiki/Setting-up-a-Git-server-on-Windows-using-Git-for-Windows-and-Win32_OpenSSH#on-client
rem https://github.com/PowerShell/Win32-OpenSSH/issues/1136#issuecomment-382074202
setx GIT_SSH_COMMAND "C:\\Windows\\System32\\OpenSSH\\ssh.exe -T"
