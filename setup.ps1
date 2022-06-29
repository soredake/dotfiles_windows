# https://stackoverflow.com/a/31602095
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# https://docs.chocolatey.org/en-us/choco/setup#install-with-powershell.exe
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# https://www.free-codecs.com/download/hevc_video_extension.htm
Invoke-WebRequest -Uri "https://www.free-codecs.com/download_soft.php?d=0ca6d1645416c69a1655fb4af4e2d6ab&s=1024&r=&f=hevc_video_extension.htm" -OutFile "$env:TEMP/hevc_extension.appx"
Add-AppPackage -Path "$env:TEMP/hevc_extension.appx"

# install my packages
# TODO: https://github.com/microsoft/vscode/issues/147408 is caused by installing vscode in user mode with admin rights
# nsudo is needed until https://github.com/gerardog/gsudo/issues/136 is done
choco install -y hamachi nsudo steam-client keepassxc powertoys ds4windows goggalaxy autoruns choco-cleaner viber jdownloader nodejs.install nomacs tor-browser wiztree zeal.install rclone.portable parsec protonvpn ppsspp doublecmd google-drive-file-stream itch msiafterburner steascree.install ffmpeg adb yt-dlp nerdfont-hack tor
choco install pcsx2-dev -y --params "/Desktop /UseQt" --pre; choco install -y git.install --params "/NoShellHereIntegration /NoOpenSSH"; choco install -y --ignore-checksums origin --params '/DesktopIcon'; choco install -y rpcs3 syncplay --pre; choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:15:00'"
ForEach ($app in 'viber','steam-client','origin','rpcs3','tor-browser','goggalaxy','pcsx2-dev') { choco pin add -n="$app"} # https://github.com/chocolatey/choco/issues/1607
$packages='9NFH4HJG2Z9H','9NCBCSZSJRSB','9NZVDKPMR9RD','XPDC2RH70K22MN','Libretro.RetroArch','gerardog.gsudo','BlueStack.BlueStacks','9pmz94127m4g','9MZ1SNWT0N5D','BiSS.WSLDiskShrinker','Microsoft.VisualStudioCode','TomWatson.BreakTimer','Python.Python.3','9n64sqztb3lm','rammichael.7+TaskbarTweaker.Beta','64Gram.64Gram','mcmilk.7zip-zstd','stromcon.emusak','AnthonyBeaumont.AchievementWatcher','JanDeDobbeleer.OhMyPosh','SteamGridDB.RomManager'
foreach ($package in $packages) { winget install -h --accept-package-agreements --accept-source-agreements $package }
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") # https://stackoverflow.com/a/31845512 https://github.com/microsoft/winget-cli/issues/222
pip install internetarchive "git+https://github.com/arecarn/dploy.git"
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name posh-git,npm-completion,yarn-completion,Terminal-Icons,PSAdvancedShortcut
wsl --install --no-launch
cd ~; corepack enable; yarn set version stable # https://yarnpkg.com/getting-started/install https://nodejs.org/dist/latest/docs/api/corepack.html
bash wsl.sh
curl --create-dirs --remote-name-all --output-dir $env:APPDATA\mpv.net\scripts "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/tree-profiles.lua" "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/brace-expand.lua"

# https://haali.su/winutils/
Invoke-WebRequest -Uri "https://haali.net/winutils/lswitch.exe" -OutFile $HOME/lswitch.exe
schtasks /create /tn "switch language with right ctrl" /sc onlogon /rl highest /tr "$HOME\lswitch.exe 163"
schtasks /run /tn "switch language with right ctrl"

# setup dotfiles
Remove-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
mkdir $HOME\Documents\PowerShell
# https://github.com/ralish/PSDotFiles/issues/12 https://github.com/arecarn/dploy/issues/8
sudo dploy stow dotfiles $HOME

# cleanup https://docs.microsoft.com/en-us/windows/application-management/provisioned-apps-windows-client-os https://pureinfotech.com/view-installed-apps-powershell-windows-10/
$debloat='MicrosoftTeams_8wekyb3d8bbwe','Microsoft.Todos_8wekyb3d8bbwe','Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe','Microsoft.Getstarted_8wekyb3d8bbwe','Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe','Microsoft.ZuneMusic_8wekyb3d8bbwe','Microsoft.WindowsCamera_8wekyb3d8bbwe','Microsoft.ZuneVideo_8wekyb3d8bbwe','Microsoft.WindowsMaps_8wekyb3d8bbwe','Microsoft.Windows.Photos_8wekyb3d8bbwe','Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe','Microsoft.People_8wekyb3d8bbwe','Microsoft.OneDriveSync_8wekyb3d8bbwe','Microsoft.BingWeather_8wekyb3d8bbwe','Microsoft.BingNews_8wekyb3d8bbwe','AdvancedMicroDevicesInc-2.AMDLink_0a9344xs7nr4m','Microsoft.GetHelp_8wekyb3d8bbwe','Microsoft.549981C3F5F10_8wekyb3d8bbwe',"BlueStacks X",'Microsoft.OneDrive','microsoft.windowscommunicationsapps_8wekyb3d8bbwe',"windows web experience pack"
foreach ($package in $debloat) { winget uninstall -h $package}

# gsudo
sudo config CacheMode Auto

# shortcuts
New-Shortcut -Name RTSS -Path $HOME\Desktop -Target "C:\Program Files (x86)\RivaTuner Statistics Server\RTSS.exe" # https://github.com/HunterZ/choco/issues/6
New-Shortcut -Name 'BreakTimer - disable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments disable
New-Shortcut -Name 'BreakTimer - enable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments enable

# add tor service, https://gitlab.torproject.org/tpo/core/tor/-/issues/17145
sudo New-Service -Name "tor" -BinaryPathName '"C:\ProgramData\chocolatey\lib\tor\tools\Tor\tor.exe --nt-service -f C:\Users\User\AppData\Local\tor\torrc"'

# backup task
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "C:\Users\User\AppData\Local\Microsoft\WindowsApps\wt.exe" -Argument "--title Backup pwsh -c backup") -TaskName "Backup everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -At 12:00 -DaysOfWeek 3)

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
Invoke-WebRequest -Uri "https://gist.github.com/soredake/f0c63deeaf104e30135a28c3238a6008/raw" -OutFile C:\ProgramData\Winget-AutoUpdate\excluded_apps.txt
