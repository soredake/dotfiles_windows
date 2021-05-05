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

mklink /j C:\tools\msys64\home\user\.ssh %USERPROFILE%\.ssh

SET var=%cd%
ECHO %var%
