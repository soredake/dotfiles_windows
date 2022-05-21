# https://stackoverflow.com/a/31602095
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# https://docs.chocolatey.org/en-us/choco/setup#install-with-powershell.exe
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# https://github.com/microsoft/winget-cli/discussions/1738
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.2.10271/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile "$env:TEMP/winget.msixbundle"
Add-AppPackage -Path "$env:TEMP/winget.msixbundle"

# https://www.free-codecs.com/download/hevc_video_extension.htm
Invoke-WebRequest -Uri "https://www.free-codecs.com/download_soft.php?d=0ca6d1645416c69a1655fb4af4e2d6ab&s=1024&r=&f=hevc_video_extension.htm" -OutFile "$env:TEMP/hevc_extension.appx"
Add-AppPackage -Path "$env:TEMP/hevc_extension.appx"

# install my packages
# TODO: do i need ffmpeg/hashcheck?
choco install -y steam-client chocolateygui keepassxc powertoys ds4windows qbittorrent discord goggalaxy autoruns choco-cleaner viber jdownloader nodejs.install visualstudio2019buildtools nomacs mpv.install tor-browser wiztree zeal.install rclone.portable parsec protonvpn ppsspp steelseries-engine firefox borderlessgaming doublecmd google-drive-file-stream coretemp obs-studio itch victoria msiafterburner dxwnd ffmpeg winaero-tweaker.install adb yt-dlp gsudo nerdfont-hack hashcheck tor
# TODO: reverse logic of retroarch or wait for retroarch to appear in winget
# TODO: replace origin with eadesktop
# TODO: make /noopenssh default on windows >=10?
choco install -y git.install --params "/NoShellHereIntegration /NoOpenSSH"; choco install -y retroarch --params '/DesktopShortcut'; choco install -y --ignore-checksums origin --params '/DesktopIcon'; choco install -y rpcs3 syncplay --pre
choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:15:00'"
ForEach ($app in 'viber','steam-client','firefox','origin','discord.install','rpcs3','ds4windows','tor-browser','goggalaxy','steelseries-engine') { choco pin add -n="$app"} # https://github.com/chocolatey/choco/issues/1607
# BlueStack.BlueStacks
winget install -h microsoft.powershell; winget install -h KDE.Dolphin; winget install -h LogMeIn.Hamachi; winget install -h BiSS.WSLDiskShrinker; winget install -h Microsoft.VisualStudioCode; winget install -h TomWatson.BreakTimer; winget install -h 9nghp3dx8hdx; winget install -h Python.Python.3; winget install -h 9n64sqztb3lm; winget install -h Spotify.Spotify; winget install -h rammichael.7+TaskbarTweaker.Beta; winget install -h 64Gram.64Gram; winget install -h mcmilk.7zip-zstd; winget install -h stromcon.emusak; winget install -h AnthonyBeaumont.AchievementWatcher; winget install -h oh-my-posh; winget install -h SteamGridDB.RomManager
pip install internetarchive "git+https://github.com/arecarn/dploy.git"
# powershell
Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force
#Install-Module PowerShellGet
#Update-Module PowerShellGet -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name posh-git,npm-completion,yarn-completion,Terminal-Icons,PSWindowsUpdate -Scope CurrentUser

# https://docs.microsoft.com/en-us/windows/wsl/install
wsl --install -–no-launch

# https://haali.su/winutils/
Invoke-WebRequest -Uri "https://haali.net/winutils/lswitch.exe" -OutFile "$env:USERPROFILE/lswitch.exe"
schtasks /create /tn "switch language with right ctrl" /sc onlogon /rl highest /tr "$env:USERPROFILE\lswitch.exe 163"
schtasks /run /tn "switch language with right ctrl"

# setup dotfiles
Remove-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
dploy stow dotfiles "$env:USERPROFILE"

# https://yarnpkg.com/getting-started/install
cd ~; corepack enable; yarn set version stable

# setup WSL2
bash wsl.sh

# https://habr.com/ru/news/t/586786/comments/#comment_23656428
schtasks /change /disable /tn "\Microsoft\Windows\Management\Provisioning\Logon"

# https://www.reddit.com/r/Windows11/comments/qs96dp/comment/hkbp794/ or https://www.ghacks.net/2021/10/08/how-to-uninstall-widgets-in-windows-11/
Get-AppxPackage MicrosoftWindows.Client.WebExperience* | Remove-AppxPackage

# cleanup https://docs.microsoft.com/en-us/windows/application-management/provisioned-apps-windows-client-os
#winget uninstall Microsoft.WindowsMaps_8wekyb3d8bbwe
#winget uninstall Microsoft.Windows.Photos_8wekyb3d8bbwe
#winget uninstall Microsoft.549981C3F5F10_8wekyb3d8bbwe
#winget uninstall Microsoft.GetHelp_8wekyb3d8bbwe
#winget uninstall Microsoft.WindowsCamera_8wekyb3d8bbwe
#winget uninstall Microsoft.PowerAutomateDesktop
#winget uninstall Microsoft.Getstarted

# gsudo
sudo config CacheMode Auto

# https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428 https://support.xbox.com/en-US/help/friends-social-activity/share-socialize/xbox-game-bar-performance
net localgroup "Пользователи журналов производительности" User /add

# enable cloudflare dns with DOH
# https://superuser.com/questions/1626047/powershell-how-to-figure-out-adapterindex-for-interface-to-public/1626051#1626051
# https://winitpro.ru/index.php/2020/07/10/nastroyka-dns-over-https-doh-v-windows/
Set-DnsClientServerAddress -InterfaceIndex (Get-NetRoute | % { Process { If (!$_.RouteMetric) { $_.ifIndex } } }) -ServerAddresses "1.1.1.1","1.0.0.1"
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name 'EnableAutoDoh' -Value 2 -PropertyType DWord -Force

# shortcuts, https://stackoverflow.com/a/31815367
# TODO: letyshops user.js proxy
C:\Program` Files\Mozilla` Firefox\firefox.exe -CreateProfile letyshops
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Firefox - LetyShops profile.lnk")
$Shortcut.TargetPath = "C:\Program Files\Mozilla Firefox\firefox.exe"
$Shortcut.Arguments = "-P letyshops"
$Shortcut.Save()
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\RTSS.lnk")
$Shortcut.TargetPath = "C:\Program Files (x86)\RivaTuner Statistics Server\RTSS.exe"
$Shortcut.Save()
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Core Temp.lnk")
$Shortcut.TargetPath = "C:\ProgramData\chocolatey\lib\coretemp\tools\Core Temp.exe"
$Shortcut.Save()
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\BreakTimer - disable.lnk")
$Shortcut.TargetPath = "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe"
$Shortcut.Arguments = "disable"
$Shortcut.Save()
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\BreakTimer - enable.lnk")
$Shortcut.TargetPath = "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe"
$Shortcut.Arguments = "enable"
$Shortcut.Save()

# add tor service, https://gitlab.torproject.org/tpo/core/tor/-/issues/17145
New-Service -Name "tor" -BinaryPathName '"C:\ProgramData\chocolatey\lib\tor\tools\Tor\tor.exe --nt-service -f C:\Users\User\git\dotfiles_windows\torrc"'

# backup task
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "C:\Users\User\AppData\Local\Microsoft\WindowsApps\wt.exe" -Argument "--title Backup pwsh -c backup") -TaskName "Backup everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -At 12:00 -DaysOfWeek 3)

# https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsLogon::DisableStartupSound
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableStartupSound' -Value 1 -Force

# https://github.com/po5/mpv_sponsorblock
git clone --depth=1 "https://github.com/po5/mpv_sponsorblock.git" $env:APPDATA\mpv.net\scripts
Remove-Item -LiteralPath "$env:APPDATA\mpv.net\scripts\.git" -Force -Recurse
Remove-Item "$env:APPDATA\mpv.net\scripts\*" -include README.md, LICENSE
# https://www.kittell.net/code/powershell-unix-sed-equivalent-change-text-file/
(Get-Content $env:APPDATA\mpv.net\scripts\sponsorblock.lua).replace('local_database = true', 'local_database = false') | Set-Content $env:APPDATA\mpv.net\scripts\sponsorblock.lua

# https://github.com/fbriere/mpv-scripts/tree/master/scripts
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/tree-profiles.lua" -OutFile $env:APPDATA\mpv.net\scripts\tree-profiles.lua
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/brace-expand.lua" -OutFile $env:APPDATA\mpv.net\scripts\brace-expand.lua

# disable lock screen, https://superuser.com/a/1659652/1506333 https://www.techrepublic.com/article/how-to-disable-the-lock-screen-in-windows-11-an-update/
$Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization"
If  ( -Not ( Test-Path "Registry::$Key")){New-Item -Path "Registry::$Key" -ItemType RegistryKey -Force}
Set-ItemProperty -path "Registry::$Key" -Name "NoLockScreen" -Type "DWORD" -Value 1

# i don't need this thanks https://github.com/AveYo/MediaCreationTool.bat/blob/8a54cb4be75be05636c2bc20841f5b2338c14a58/MediaCreationTool.bat#L833-L835
New-ItemProperty -Path 'HKCU:\Control Panel\UnsupportedHardwareNotificationCache' -Name 'SV2' -Value 0 -PropertyType DWord -Force

# explorer tweaks https://stackoverflow.com/a/8110982/4207635
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key HideFileExt 0

# https://pureinfotech.com/enable-hardware-accelerated-gpu-scheduling-windows-11/
#New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name HwSchMode -PropertyType DWord -Value 2 -Force

# winget autoupdate https://github.com/microsoft/winget-cli/issues/212
Invoke-WebRequest -Uri "https://github.com/Romanitho/Winget-AutoUpdate/archive/refs/heads/main.zip" -OutFile "$env:USERPROFILE/Winget-AutoUpdate.zip"
Expand-Archive "$env:USERPROFILE/Winget-AutoUpdate.zip" -DestinationPath "$env:USERPROFILE"
pwsh "$env:USERPROFILE/Winget-AutoUpdate-main\Winget-AutoUpdate-Install.ps1" -NotificationLevel None -UpdatesInterval Weekly
Set-ScheduledTask -TaskName Winget-AutoUpdate -Trigger (New-ScheduledTaskTrigger -Weekly -At 12:00 -DaysOfWeek 2)
# TODO: will C:\ProgramData\Winget-AutoUpdate\excluded_apps.txt be overriden on wau update?

# https://github.com/PowerShell/PowerShell/issues/14216#issuecomment-1084010061
Invoke-WebRequest -Uri "https://gist.githubusercontent.com/soredake/9e7b6fc7f04d9d96a2fc798b25d5186f/raw/powershell_context_shell_fix.reg" -OutFile "$env:TEMP/powershell_context_shell_fix.reg"
reg import "$env:TEMP/powershell_context_shell_fix.reg"
