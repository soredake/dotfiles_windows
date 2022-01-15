# https://stackoverflow.com/a/31602095
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# https://docs.chocolatey.org/en-us/choco/setup#install-with-powershell.exe
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# install my packages
# TODO: do i need dxwnd?
choco install -y steam-client chocolateygui keepassxc powertoys ds4windows qbittorrent discord goggalaxy autoruns choco-cleaner viber jdownloader nodejs.install msys2 visualstudio2019buildtools nomacs mpv.install tor-browser wiztree zeal.install rclone.portable parsec protonvpn ppsspp steelseries-engine firefox borderlessgaming doublecmd google-drive-file-stream coretemp obs-studio itch victoria msiafterburner dxwnd ffmpeg winaero-tweaker.install adb yt-dlp gsudo nerdfont-hack hashcheck
# TODO: reverse logic of retroarch or wait for retroarch to appear in winget
# TODO: replace origin with eadesktop
# TODO: make /noopenssh default on windows >=10?
choco install -y git.install --params "/NoShellHereIntegration /NoOpenSSH"; choco install -y retroarch --params '/DesktopShortcut'; choco install -y --ignore-checksums origin --params '/DesktopIcon'; choco install -y rpcs3 syncplay --pre
#choco install -y pcsx2.install --params '/Desktop'
choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:15:00'"
ForEach ($app in 'viber','steam-client','firefox','origin','discord.install','rpcs3','ds4windows','tor-browser','goggalaxy','steelseries-engine') { choco pin add -n="$app"} # https://github.com/chocolatey/choco/issues/1607
winget install -h microsoft.powershell; winget install -h KDE.Dolphin; winget install -h LogMeIn.Hamachi; winget install -h BlueStack.BlueStacks; winget install -h BiSS.WSLDiskShrinker; winget install -h Microsoft.VisualStudioCode; winget install -h kapitainsky.RcloneBrowser; winget install -h TomWatson.BreakTimer; winget install -h 9nghp3dx8hdx; winget install -h Python.Python.3; winget install -h 9n64sqztb3lm; winget install -h Spotify.Spotify; winget install -h rammichael.7+TaskbarTweaker.Beta; winget install -h 64Gram.64Gram; winget install -h mcmilk.7zip-zstd
pip install internetarchive "git+https://github.com/arecarn/dploy.git"
# msys2, python is neeed for npm/yarn completion in fish
C:\tools\msys64\mingw64.exe pacman.exe -S --noconfirm zsh fish python diffutils winpty
# powershell
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force
#Install-Module PowerShellGet
#Update-Module PowerShellGet -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name posh-git,npm-completion,yarn-completion,oh-my-posh,Terminal-Icons -Scope CurrentUser

# https://docs.microsoft.com/en-us/windows/wsl/install
wsl --install -–no-launch -d Ubuntu

# https://haali.su/winutils/
Invoke-WebRequest -Uri "https://haali.su/winutils/lswitch.exe" -OutFile "$env:USERPROFILE/lswitch.exe"
schtasks /create /tn "switch language with right ctrl" /sc onlogon /rl highest /tr "$env:USERPROFILE\lswitch.exe 163"
schtasks /run /tn "switch language with right ctrl"

# setup dotfiles
Remove-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
mkdir "C:\tools\msys64\home\user"
New-Item -ItemType SymbolicLink -Path "C:\tools\msys64\home\user\.zshrc" -Target ".\.zshrc"
New-Item -ItemType SymbolicLink -Path "C:\tools\msys64\home\user\.gitconfig" -Target ".\dotfiles\.gitconfig"
New-Item -ItemType Junction -Path "C:\tools\msys64\home\user\.ssh" -Target "$env:USERPROFILE\.ssh"
dploy stow dotfiles "$env:USERPROFILE"

# https://yarnpkg.com/getting-started/install
cd ~; corepack enable; yarn set version stable

# trakt tv sync
python -m pip install pipx
pipx ensurepath
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") # https://stackoverflow.com/questions/17794507/powershell-reload-the-path-in-powershell
pipx install trakt-scrobbler
trakts auth
trakts config set players.monitored mpv
trakts config set fileinfo.whitelist F:\ # TODO: add dynamic disk letter detection
trakts config set general.enable_notifs False
"input-ipc-server=\\.\pipe\mpvsocket`n" + (Get-Content "$env:APPDATA\mpv.net\mpv.conf" -Raw) | Set-Content "$env:APPDATA\mpv.net\mpv.conf"
trakts config set players.mpv.ipc_path \\.\pipe\mpvsocket

# setup WSL2
bash wsl.sh

# https://habr.com/ru/news/t/586786/comments/#comment_23656428
schtasks /change /disable /tn "\Microsoft\Windows\Management\Provisioning\Logon"

# https://www.reddit.com/r/Windows11/comments/qs96dp/comment/hkbp794/ or https://www.ghacks.net/2021/10/08/how-to-uninstall-widgets-in-windows-11/
Get-AppxPackage MicrosoftWindows.Client.WebExperience* | Remove-AppxPackage

# unneeded
Set-Service -Name "ClickToRunSvc" -Status stopped -StartupType disabled

# cleanup
winget uninstall Microsoft.WindowsMaps_8wekyb3d8bbwe
winget uninstall Microsoft.Windows.Photos_8wekyb3d8bbwe
winget uninstall Microsoft.549981C3F5F10_8wekyb3d8bbwe
winget uninstall Microsoft.GetHelp_8wekyb3d8bbwe
winget uninstall Microsoft.WindowsCamera_8wekyb3d8bbwe

# gsudo
sudo config CacheMode Auto

# https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428
net localgroup "Пользователи журналов производительности" User /add

# enable cloudflare dns with DOH
# https://superuser.com/questions/1626047/powershell-how-to-figure-out-adapterindex-for-interface-to-public/1626051#1626051
# https://winitpro.ru/index.php/2020/07/10/nastroyka-dns-over-https-doh-v-windows/
Set-DnsClientServerAddress -InterfaceIndex (Get-NetRoute | % { Process { If (!$_.RouteMetric) { $_.ifIndex } } }) -ServerAddresses "1.1.1.1","1.0.0.1"
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name 'EnableAutoDoh' -Value 2 -PropertyType DWord -Force

# disable hibernation
powercfg /hibernate off

# receive microsoft product updates, https://github.com/Disassembler0/Win10-Initial-Setup-Script/issues/250#issuecomment-503887779
(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")


# shortcuts, https://stackoverflow.com/a/31815367
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\BreakTimer - disable.lnk")
$Shortcut.TargetPath = "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe"
$Shortcut.Arguments = "disable"
$Shortcut.Save()
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\BreakTimer - enable.lnk")
$Shortcut.TargetPath = "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe"
$Shortcut.Arguments = "enable"
$Shortcut.Save()
