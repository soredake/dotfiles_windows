# https://stackoverflow.com/a/31602095
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# https://docs.chocolatey.org/en-us/choco/setup#install-with-powershell.exe
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# https://www.free-codecs.com/download/hevc_video_extension.htm
Invoke-WebRequest -Uri "https://www.free-codecs.com/download_soft.php?d=0ca6d1645416c69a1655fb4af4e2d6ab&s=1024&r=&f=hevc_video_extension.htm" -OutFile "$env:TEMP/hevc_extension.appx"
Add-AppPackage -Path "$env:TEMP/hevc_extension.appx"

# install my packages
# TODO: github rate limiting 429
# TODO: https://github.com/microsoft/vscode/issues/147408 is caused by installing vscode in user mode with admin rights
# nsudo is needed until https://github.com/gerardog/gsudo/issues/136 is done
choco install -y hamachi spotify nsudo steam-client keepassxc powertoys ds4windows qbittorrent discord.install goggalaxy autoruns choco-cleaner viber jdownloader nodejs.install nomacs tor-browser wiztree zeal.install rclone.portable parsec protonvpn ppsspp firefox doublecmd google-drive-file-stream itch msiafterburner steascree.install ffmpeg adb yt-dlp gsudo nerdfont-hack tor
choco install pcsx2-dev -y --params "/Desktop /UseQt" --pre; choco install -y git.install --params "/NoShellHereIntegration /NoOpenSSH"; choco install -y retroarch --params '/DesktopShortcut'; choco install -y --ignore-checksums origin --params '/DesktopIcon'; choco install -y rpcs3 syncplay --pre; choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:15:00'"
ForEach ($app in 'viber','steam-client','firefox','origin','discord.install','rpcs3','tor-browser','goggalaxy','pcsx2-dev') { choco pin add -n="$app"} # https://github.com/chocolatey/choco/issues/1607
$packages='BlueStack.BlueStacks','9pmz94127m4g','microsoft.powershell','BiSS.WSLDiskShrinker','Microsoft.VisualStudioCode','TomWatson.BreakTimer','Python.Python.3','9n64sqztb3lm','rammichael.7+TaskbarTweaker.Beta','64Gram.64Gram','mcmilk.7zip-zstd','stromcon.emusak','AnthonyBeaumont.AchievementWatcher','oh-my-posh','SteamGridDB.RomManager'
foreach ($package in $packages) { winget install -h --accept-package-agreements --accept-source-agreements $package }
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") # https://stackoverflow.com/a/31845512 https://github.com/microsoft/winget-cli/issues/222
pip install internetarchive "git+https://github.com/arecarn/dploy.git"
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name posh-git,npm-completion,yarn-completion,Terminal-Icons
wsl --install --no-launch
# https://yarnpkg.com/getting-started/install https://nodejs.org/dist/latest/docs/api/corepack.html
cd ~; corepack enable; yarn set version stable
bash wsl.sh

# https://haali.su/winutils/
Invoke-WebRequest -Uri "https://haali.net/winutils/lswitch.exe" -OutFile $HOME/lswitch.exe
schtasks /create /tn "switch language with right ctrl" /sc onlogon /rl highest /tr "$HOME\lswitch.exe 163"
schtasks /run /tn "switch language with right ctrl"

# setup dotfiles
Remove-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
mkdir $HOME\Documents\PowerShell
mkdir $env:APPDATA\mpv.net\scripts
# TODO: --no-folding flag for dploy/psdotfiles https://news.ycombinator.com/item?id=7927930
dploy stow dotfiles $HOME

# cleanup https://docs.microsoft.com/en-us/windows/application-management/provisioned-apps-windows-client-os https://pureinfotech.com/view-installed-apps-powershell-windows-10/
$debloat='MicrosoftTeams_8wekyb3d8bbwe','Microsoft.Todos_8wekyb3d8bbwe','Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe','Microsoft.Getstarted_8wekyb3d8bbwe','Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe','Microsoft.ZuneMusic_8wekyb3d8bbwe','Microsoft.WindowsCamera_8wekyb3d8bbwe','Microsoft.ZuneVideo_8wekyb3d8bbwe','Microsoft.WindowsMaps_8wekyb3d8bbwe','Microsoft.Windows.Photos_8wekyb3d8bbwe','Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe','Microsoft.People_8wekyb3d8bbwe','Microsoft.OneDriveSync_8wekyb3d8bbwe','Microsoft.BingWeather_8wekyb3d8bbwe','Microsoft.BingNews_8wekyb3d8bbwe','AdvancedMicroDevicesInc-2.AMDLink_0a9344xs7nr4m','Microsoft.GetHelp_8wekyb3d8bbwe','Microsoft.549981C3F5F10_8wekyb3d8bbwe',"BlueStacks X",'Microsoft.OneDrive','microsoft.windowscommunicationsapps_8wekyb3d8bbwe',"windows web experience pack"
foreach ($package in $debloat) { winget uninstall -h $package}

# gsudo
sudo config CacheMode Auto

# shortcuts, https://stackoverflow.com/a/31815367
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\RTSS.lnk") # TODO: propose creating a link for it here https://github.com/HunterZ/choco
$Shortcut.TargetPath = "C:\Program Files (x86)\RivaTuner Statistics Server\RTSS.exe"
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

# https://codeberg.org/jouni/mpv_sponsorblock_minimal
Invoke-WebRequest -Uri "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" -OutFile $env:APPDATA\mpv.net\scripts\sponsorblock_minimal.lua
# https://github.com/fbriere/mpv-scripts/tree/master/scripts
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/tree-profiles.lua" -OutFile $env:APPDATA\mpv.net\scripts\tree-profiles.lua
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/brace-expand.lua" -OutFile $env:APPDATA\mpv.net\scripts\brace-expand.lua

# https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsLogon::DisableStartupSound https://aka.ms/AAh46ae
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableStartupSound' -Value 1 -Force
# disable slide-away lock screen, https://superuser.com/a/1659652/1506333 https://www.techrepublic.com/article/how-to-disable-the-lock-screen-in-windows-11-an-update/ https://aka.ms/AAh3io0
reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization' /v 'NoLockScreen' /t REG_DWORD /d 1 /f
# explorer tweaks https://stackoverflow.com/a/8110982/4207635
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key HideFileExt 0
# https://www.ghacks.net/2021/10/22/how-to-remove-chat-in-windows-11/
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /f /v ChatIcon /t REG_DWORD /d 3
# https://winitpro.ru/index.php/2021/12/16/udalit-chat-microsoft-teams-v-windows/ https://www.outsidethebox.ms/21375/ https://aka.ms/AAh4nac
NSudoLG.exe -U:T reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v ConfigureChatAutoInstall /t REG_DWORD /d 0 /f
# https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428 https://support.xbox.com/en-US/help/friends-social-activity/share-socialize/xbox-game-bar-performance https://aka.ms/AAh2b88 https://aka.ms/AAh23gr
net localgroup "Пользователи журналов производительности" User /add
# enable cloudflare dns with DOH https://superuser.com/a/1626051/1506333 https://winitpro.ru/index.php/2020/07/10/nastroyka-dns-over-https-doh-v-windows. https://aka.ms/AAh4e0n
Set-DnsClientServerAddress -InterfaceIndex (Get-NetRoute | % { Process { If (!$_.RouteMetric) { $_.ifIndex } } }) -ServerAddresses "1.1.1.1","1.0.0.1"
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name 'EnableAutoDoh' -Value 2 -PropertyType DWord -Force
# https://habr.com/ru/news/t/586786/comments/#comment_23656428 https://aka.ms/AAh177w
Disable-ScheduledTask "Microsoft\Windows\Management\Provisioning\Logon"
# cleanup scheduled tasks https://aka.ms/AAh3y2n
ForEach ($task in "Achievement Watcher Upgrade OnLogon","OneDrive*") { Unregister-ScheduledTask "$task" -Confirm:$false }

# winget autoupdate https://github.com/microsoft/winget-cli/issues/212
Invoke-WebRequest -Uri "https://github.com/Romanitho/Winget-AutoUpdate/archive/refs/heads/main.zip" -OutFile "$env:TEMP/Winget-AutoUpdate.zip"
Expand-Archive "$env:TEMP/Winget-AutoUpdate.zip" -DestinationPath "$env:TEMP"
pwsh "$env:TEMP/Winget-AutoUpdate-main\Winget-AutoUpdate-Install.ps1" -NotificationLevel None -UpdatesInterval Weekly
Set-ScheduledTask -TaskName Winget-AutoUpdate -Trigger (New-ScheduledTaskTrigger -Weekly -At 12:00 -DaysOfWeek 2)
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Romanitho/Winget-AutoUpdate/574194c76441c6d835ecf70c58597ffda5b16247/excluded_apps.txt" -OutFile C:\ProgramData\Winget-AutoUpdate\excluded_apps.txt
