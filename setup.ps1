# https://stackoverflow.com/a/31602095
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# https://docs.chocolatey.org/en-us/choco/setup#install-with-powershell.exe
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# install my packages
# wsl-ubuntu-2004 wsl2 microsoft-windows-terminal
choco install -y steam-cleaner steam-client 7zip.install chocolateygui keepassxc powertoys telegram.install ds4windows qbittorrent discord goggalaxy autoruns choco-cleaner epicgameslauncher viber edgedeflector jdownloader python nodejs.install yarn git.install hackfont msys2 visualstudio2019buildtools nomacs mpv.install tor-browser wiztree ubisoft-connect zeal.install rclone.portable parsec protonvpn youtube-dl ppsspp steelseries-engine firefox crystaldiskinfo.install spotify mpvnet.install borderlessgaming doublecmd google-drive-file-stream coretemp megasync obs-studio victoria msiafterburner dxwnd wincdemu minecraft-launcher ffmpeg winaero-tweaker.install adb yt-dlp gsudo vortex
choco install -y retroarch --params '/DesktopShortcut'; choco install -y --ignore-checksums origin --params '/DesktopIcon'; choco install -y rpcs3 syncplay --pre
#choco install -y pcsx2.install --params '/Desktop'
choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:15:00'"
ForEach ($app in 'viber','steam-client','firefox','origin','telegram.install','discord.install','rpcs3','ds4windows','ubisoft-connect','tor-browser','goggalaxy','steelseries-engine') { choco pin add -n="$app"} # https://github.com/chocolatey/choco/issues/1607
winget install KDE.Dolphin; winget install -h LogMeIn.Hamachi; winget install -h HandyOrg.HandyWinget-GUI; winget install -h BlueStack.BlueStacks; winget install -h ElectronicArts.EADesktop; winget install -h BiSS.WSLDiskShrinker; winget install -eh Microsoft.VisualStudioCode; winget install -h kapitainsky.RcloneBrowser; winget install -h TomWatson.BreakTimer
pip install --user -U internetarchive

# https://docs.microsoft.com/en-us/windows/wsl/install-win10
# for now i use `choco install wsl-ubuntu-2004 wsl2` as i don't have new anough windows
wsl --install -d Ubuntu

# https://richardballard.co.uk/ssh-keys-on-windows-10/
#Add-WindowsCapability -Online -Name OpenSSH.Client
#Add-WindowsCapability -Online -Name OpenSSH.Server
#Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service

# https://haali.su/winutils/
Invoke-WebRequest -Uri "https://haali.su/winutils/lswitch.exe" -OutFile "$env:USERPROFILE/lswitch.exe"
schtasks /create /tn "switch language with right ctrl" /sc onlogon /rl highest /tr "$env:USERPROFILE\lswitch.exe 163"
schtasks /run /tn "switch language with right ctrl"

# git for windows uses wrong ssh binary which leads to errors like `Permission Denied (publickey)` because it don't use windows ssh-agent
# https://github.com/PowerShell/Win32-OpenSSH/wiki/Setting-up-a-Git-server-on-Windows-using-Git-for-Windows-and-Win32_OpenSSH#on-client
# https://github.com/PowerShell/Win32-OpenSSH/issues/1136#issuecomment-382074202
setx GIT_SSH_COMMAND "C:\\Windows\\System32\\OpenSSH\\ssh.exe -T"

# setup msys2
C:\tools\msys64\mingw64.exe pacman.exe -S --noconfirm zsh fish python diffutils stow

# config files, git
Remove-Item -Path "$env:USERPROFILE\.gitconfig"
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.gitconfig" -Target ".\.gitconfig"
New-Item -ItemType SymbolicLink -Path "C:\tools\msys64\home\user\.gitconfig" -Target ".\.gitconfig"
# ssh
New-Item -ItemType Junction -Path "C:\tools\msys64\home\user\.ssh" -Target "$env:USERPROFILE\.ssh"
# mpv
Remove-Item -Path "$env:APPDATA\mpv\*.conf"
mkdir "$env:APPDATA\mpv\scripts"
#Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/lua/pause-when-minimize.lua" -OutFile "$env:APPDATA\mpv\scripts\pause-when-minimize.lua"
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\mpv\mpv.conf" -Target ".\mpv.conf"
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\mpv\input.conf" -Target ".\input.conf"
# zsh
Remove-Item -Path "C:\tools\msys64\home\user\.zshrc"
mkdir "C:\tools\msys64\home\user"
New-Item -ItemType SymbolicLink -Path "C:\tools\msys64\home\user\.zshrc" -Target ".\.zshrc"
# microsoft windows terminal
Remove-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
mkdir "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Target ".\mswinterminal.json"

# yarn
cd ~; yarn set version berry

# add python to path, better to install python with winget once https://github.com/microsoft/winget-cli/issues/219 and https://github.com/microsoft/winget-cli/issues/212 is resolved
setx PATH "$env:PATH;$env:APPDATA\Python\Python310\Scripts"

# https://mspscripts.com/disable-windows-10-fast-boot-via-powershell/
# leave disabled if you use dualboot or wifi adapters
#reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d "0" /f

# trakt tv sync
# TODO: use full path
pip install --user -U pipx
python -m pipx ensurepath
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") # https://stackoverflow.com/questions/17794507/powershell-reload-the-path-in-powershell
pipx install trakt-scrobbler
trakts auth
trakts config set players.monitored mpv
trakts config set fileinfo.whitelist F:\
trakts config set general.enable_notifs False
"input-ipc-server=\\.\pipe\mpvsocket`n" + (Get-Content "$env:APPDATA\mpv.net\mpv.conf" -Raw) | Set-Content "$env:APPDATA\mpv.net\mpv.conf"
trakts config set players.mpv.ipc_path \\.\pipe\mpvsocket

# fix https://github.com/msys2/MSYS2-packages/issues/138#issuecomment-775316680
#C:\tools\msys64\mingw64.exe bash.exe -c 'mkpasswd > /etc/passwd; mkgroup > /etc/group; sed -i "s/db//g" /etc/nsswitch.conf'

# configure WSL2
bash.exe -c 'sudo apt update && sudo apt upgrade -y && sudo apt install -y python3-pip && pip install --user -U internetarchive'

# https://remontka.pro/compact-os-windows-10/
#compact /compactos:never

# https://habr.com/ru/news/t/586786/comments/#comment_23656428
schtasks /change /disable /tn "\Microsoft\Windows\Management\Provisioning\Logon"
