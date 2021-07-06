# https://stackoverflow.com/a/31602095
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# https://docs.chocolatey.org/en-us/choco/setup#install-with-powershell.exe
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#choco feature enable -n=useRememberedArgumentsForUpgrades
# install my packages
choco install -y steam-cleaner steam-client 7zip chocolateygui keepassxc powertoys telegram ds4windows qbittorrent discord goggalaxy autoruns choco-cleaner epicgameslauncher viber edgedeflector jdownloader vscode python nodejs yarn git hackfont microsoft-windows-terminal msys2 visualstudio2019buildtools google-backup-and-sync nomacs mpv tor-browser wiztree ubisoft-connect zeal caffeine rclone parsec protonvpn youtube-dl ppsspp steelseries-engine firefox crystaldiskinfo.install spotify mpvnet.install borderlessgaming
choco install -y retroarch --params '/DesktopShortcut'
#choco install -y pcsx2.install --params '/Desktop'
choco install -y origin --params '/DesktopIcon' # ea desktop?
choco install -y rpcs3 --pre
choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:15:00'"
ForEach ($app in 'viber','steam-client','firefox','origin','telegram','discord','rpcs3','ds4windows','ubisoft-connect','tor-browser','vscode') { choco pin add -n="$app"} # https://github.com/chocolatey/choco/issues/1607
winget install LogMeIn.Hamachi
winget install HandyOrg.HandyWinget-GUI
winget install BlueStack.BlueStacks
pip install --user -U internetarchive

# https://docs.microsoft.com/en-us/windows/wsl/install-win10
# wsl --install -d Ubuntu

# https://richardballard.co.uk/ssh-keys-on-windows-10/
Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service

# https://haali.su/winutils/
Invoke-WebRequest -Uri "https://haali.su/winutils/lswitch.exe" -OutFile "$env:USERPROFILE/lswitch.exe"
schtasks /create /tn "switch language with right ctrl" /sc onlogon /rl highest /tr "$env:USERPROFILE\lswitch.exe 163"

# git for windows uses wrong ssh binary which leads to errors like `Permission Denied (publickey)` because it don't use windows ssh-agent
# https://github.com/PowerShell/Win32-OpenSSH/wiki/Setting-up-a-Git-server-on-Windows-using-Git-for-Windows-and-Win32_OpenSSH#on-client
# https://github.com/PowerShell/Win32-OpenSSH/issues/1136#issuecomment-382074202
setx GIT_SSH_COMMAND "C:\\Windows\\System32\\OpenSSH\\ssh.exe -T"

# setup msys2
C:\tools\msys64\mingw64.exe pacman.exe -S --noconfirm zsh fish python diffutils stow

# config files, git
Remove-Item -Path "$env:USERPROFILE\.gitconfig"
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.gitconfig" -Target ".\.gitconfig"
New-Item -ItemType SymbolicLink -Path "C:\tools\msys64\home\user\.gitconfig" -Target ".\.itconfig"
# ssh
New-Item -ItemType Junction -Path "C:\tools\msys64\home\user\.ssh" -Target "$env:USERPROFILE\.ssh"
# mpv
Remove-Item -Path "$env:APPDATA\mpv\*.conf"
mkdir "$env:APPDATA\mpv\scripts"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/lua/pause-when-minimize.lua" -OutFile "$env:APPDATA\mpv\scripts\pause-when-minimize.lua"
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
cd ~
yarn set version berry

# add python to path
# better to install python with winget once https://github.com/microsoft/winget-cli/issues/219 and https://github.com/microsoft/winget-cli/issues/212 is resolved
setx PATH "$env:PATH;$env:APPDATA\Python\Python39\Scripts"

# fix https://github.com/microsoft/WSL/issues/4103
compact /U "$env:USERPROFILE\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu20.04onWindows_79rhkp1fndgsc\LocalState"

# fix https://github.com/microsoft/WSL/issues/5336#issuecomment-770494713
Set-Content -Path "$env:USERPROFILE\.wslconfig" -Value "[wsl2]`nswap=0"

# https://stackoverflow.com/questions/30496116/how-to-disable-hyper-v-in-command-line
bcdedit /set hypervisorlaunchtype off

# mpv.net config # keepaspect-window
Add-Content -Path "$env:APPDATA\mpv.net\mpv.conf" -Value "`nno-keepaspect-window`nslang = 'eng,en'"
