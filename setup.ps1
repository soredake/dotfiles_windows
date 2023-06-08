$machine = 'BlueStack.BlueStacks', 'lycheeverse.lychee', 'AppWork.JDownloader', 'Google.Drive', 'GOG.Galaxy', 'DupeGuru.DupeGuru', 'Syncplay.Syncplay', 'alexx2000.DoubleCommander', 'AntibodySoftware.WizTree', 'Rclone.Rclone', 'yt-dlp.yt-dlp', 'Gyan.FFmpeg', 'Parsec.Parsec', 'LogMeIn.Hamachi', 'ViGEm.ViGEmBus', 'GitHub.cli', 'mcmilk.7zip-zstd', 'Haali.WinUtils.lswitch', 'Libretro.RetroArch', 'HandBrake.HandBrake', 'ElectronicArts.EADesktop', 'OpenJS.NodeJS', 'Microsoft.PowerToys', 'KeePassXCTeam.KeePassXC', 'ProtonTechnologies.ProtonVPN', 'Canonical.Multipass'
$user = 'XP8K0HKJFRXGCK', '9NFH4HJG2Z9H', '9NZVDKPMR9RD', 'XPDC2RH70K22MN', '9PMZ94127M4G', 'Python.Python.3.11', 'XP99J3KP4XZ4VV', '9N3SQK8PDS8G', 'XPFM5P5KDWF0JP', 'SteamGridDB.RomManager', '64Gram.64Gram', 'Postman.Postman', 'ResponsivelyApp.ResponsivelyApp', 'RussellBanks.Komac', 'RamenSoftware.7+TaskbarTweaker', 'nomacs.nomacs', 'erengy.Taiga' # nanazip https://github.com/M2Team/NanaZip/issues/86
foreach ($p in $machine) { sudo winget install --scope machine --no-upgrade -h --accept-package-agreements --accept-source-agreements $p }
foreach ($p in $user) { winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements $p }
winget install -h -e --id TomWatson.BreakTimer -v 1.1.0 # https://github.com/tom-james-watson/breaktimer-app/issues/185
sudo winget install -h -e --id ViGEm.HidHide -v 1.2.98 # https://github.com/ViGEm/HidHide/issues/109 https://github.com/ViGEm/HidHide/issues/110 https://github.com/ViGEm/HidHide/issues/111
winget install Microsoft.VisualStudioCode --no-upgrade -h --accept-package-agreements --accept-source-agreements --override "/verysilent /suppressmsgboxes /mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'" # https://github.com/microsoft/winget-pkgs/issues/106091
sudo winget install --no-upgrade -h -l $HOME\Steam Valve.Steam
if (!$env:vm) {
  # set static ip https://stackoverflow.com/a/53991926
  $env:interfaceIndex = (Get-NetRoute | Where-Object -FilterScript { $_.DestinationPrefix -eq "0.0.0.0/0" } | Get-NetAdapter).InterfaceIndex
  sudo { New-NetIPAddress -InterfaceIndex $env:interfaceIndex -IPAddress 192.168.0.145 -AddressFamily IPv4 -PrefixLength 24 -DefaultGateway 192.168.0.1; Get-NetAdapter -Physical | Get-NetIPInterface -AddressFamily IPv4 | Set-DnsClientServerAddress -ServerAddresses 1.1.1.1, 1.0.0.1 }
}
Remove-Item -Recurse -Path ~\Downloads\Sophia*
irm script.sophi.app -useb | iex
sudo ~\Downloads\Sophia*\Sophia.ps1 -Function CreateRestorePoint, "TaskbarSearch -SearchIcon", "CastToDeviceContext -Hide", "ControlPanelView -LargeIcons", "FileTransferDialog -Detailed", "HiddenItems -Enable", "FileExtensions -Show", "TaskbarChat -Hide", "ShortcutsSuffix -Disable", "UnpinTaskbarShortcuts -Shortcuts Edge, Store", "OneDrive -Uninstall", "DNSoverHTTPS -Enable -PrimaryDNS 1.1.1.1 -SecondaryDNS 1.0.0.1" # "ThumbnailCacheRemoval -Disable"
sudo choco install -y --pin ds4windows syncthingtray achievement-watcher itch tor-browser # syncthingtray is pinned until https://gitlab.com/yan12125/chocolatey-packages/-/issues/2 is fixed
sudo choco install -y ryujinx virtualbox ytdownloader insomnia ppsspp steascree.install choco-cleaner msiafterburner nerdfont-hack tor --params "'/DesktopShortcut /NoShellHereIntegration /NoOpenSSH /RTSSDesktopShortcut /No32bitIcon'"; sudo choco install -y --pre mpvnet.portable pcsx2-dev rpcs3 --params "'/DesktopShortcut /NoAdmin'"; sudo choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:19:00'"
refreshenv # https://github.com/microsoft/winget-cli/issues/3077 https://github.com/chocolatey/choco/issues/2458
foreach ($b in "extras", "games", "nonportable") { scoop bucket add $b }
scoop install cheat-engine yuzu-pineapple #spotx-np
pip install pipx
pipx ensurepath
$pip = @("internetarchive", "git+https://github.com/arecarn/dploy.git", "tubeup")
foreach ($p in $pip) { pipx install $p } # https://github.com/pypa/pipx/issues/971
Install-PackageProvider -Name NuGet -Scope CurrentUser -Confirm:$false -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name posh-git, npm-completion, Terminal-Icons, PSAdvancedShortcut
npm install --global html-validate gulp-cli create-react-app
# https://github.com/yt-dlp/yt-dlp/issues/6496#issuecomment-1463202877
curl -L --create-dirs --remote-name-all --output-dir $env:APPDATA\mpv.net\scripts "https://raw.githubusercontent.com/mpv-player/mpv/master/player/lua/ytdl_hook.lua" "https://github.com/ekisu/mpv-webm/releases/download/latest/webm.lua" "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/tree-profiles.lua" "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/brace-expand.lua" "https://raw.githubusercontent.com/zenwarr/mpv-config/master/scripts/russian-layout-bindings.lua"
Invoke-WebRequest -Uri "https://github.com/Romanitho/Winget-AutoUpdate/archive/refs/heads/main.zip" -OutFile "$env:TEMP/Winget-AutoUpdate.zip"
Expand-Archive "$env:TEMP/Winget-AutoUpdate.zip" -DestinationPath "$env:TEMP"
sudo "$env:TEMP/Winget-AutoUpdate-main/Winget-AutoUpdate-Install.ps1" -StartMenuShortcut -Silent -NotificationLevel None -UpdatesInterval Weekly -DoNotUpdate -UpdatesAtTime 11AM
sudo mkdir C:\ProgramData\Winget-AutoUpdate
TODO: ln -sfv ./excluded_apps.txt C:\ProgramData\Winget-AutoUpdate\excluded_apps.txt
sudo Invoke-WebRequest -Uri "https://gist.github.com/soredake/f0c63deeaf104e30135a28c3238a6008/raw" -OutFile C:\ProgramData\Winget-AutoUpdate\excluded_apps.txt
# link dotfiles https://github.com/microsoft/terminal/issues/14730
sudo { Remove-Item -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json; New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $HOME\git\dotfiles_windows\dotfiles\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json }
New-Item -Path $env:APPDATA\mpv.net\script-opts -ItemType Directory
sudo dploy stow dotfiles $HOME
# shortcuts
Import-Module -Name $HOME\Documents\PowerShell\Modules\PSAdvancedShortcut
New-Shortcut -Name 'Disconnect gamepad' -Path $HOME\Desktop -Target "$env:ChocolateyInstall\bin\DS4Windows.exe" -Arguments "-command Disconnect" -IconPath '$env:ChocolateyInstall\lib\ds4windows\tools\DS4Windows\DS4Windows.exe'
New-Shortcut -Name 'Cheat Engine' -Path $HOME\Desktop -Target "$HOME\scoop\apps\cheat-engine\current\cheatengine-x86_64.exe" # https://github.com/ScoopInstaller/Scoop/issues/4212
New-Shortcut -Name 'BreakTimer - disable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments disable
New-Shortcut -Name 'BreakTimer - enable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments enable
New-Shortcut -Name 'SteaScree' -Path $HOME\Desktop -Target "C:\Program Files (x86)\SteaScree\SteaScree.exe" # TODO: https://github.com/chtof/chocolatey-packages/pull/92
New-Shortcut -Name 'yuzu Early Access' -Path $HOME\Desktop -Target "$HOME\scoop\apps\yuzu-pineapple\current\yuzu.exe"
# Tasks
sudo { Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WinGet\Links\lswitch.exe" -Argument "163") -TaskName "switch language with right ctrl" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)) -Trigger (New-ScheduledTaskTrigger -AtLogon) }
sudo Start-ScheduledTask -TaskName "switch language with right ctrl"
sudo Disable-ScheduledTask "Achievement` Watcher` Upgrade` Daily" # https://github.com/Xav83/chocolatey-packages/pull/24
sudo New-Service -Name "tor" -BinaryPathName '"C:\ProgramData\chocolatey\lib\tor\tools\Tor\tor.exe --nt-service -f C:\Users\User\AppData\Local\tor\torrc"' # # https://gitlab.torproject.org/tpo/core/tor/-/issues/17145
sudo sc failure tor reset=30 actions=restart/5000 # https://serverfault.com/a/983832 TODO: request support for service recovery options in powershell
Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument '--title "AMD cleanup task" pwsh -c amdcleanup') -TaskName "AMD cleanup task" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Friday -At 11:00)
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument "--title Backup pwsh -c backup") -TaskName "Backup everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -At 12:00 -DaysOfWeek 3)
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument '--title "Update everything" pwsh -c upgradeall') -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 11:00)
sudo choco feature enable -n=useRememberedArgumentsForUpgrades -n=removePackageInformationOnUninstall
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0 # https://remontka.pro/wake-timers-windows/
# https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsLogon::DisableStartupSound
sudo Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableStartupSound' -Value 1 -Force
# disable slide-away lock screen, https://superuser.com/a/1659652/1506333 https://www.techrepublic.com/article/how-to-disable-the-lock-screen-in-windows-11-an-update/
sudo reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization' /v 'NoLockScreen' /t REG_DWORD /d 1 /f
# https://winitpro.ru/index.php/2021/12/16/udalit-chat-microsoft-teams-v-windows/ https://www.outsidethebox.ms/21375/ https://aka.ms/AAh4nac
# sudo --ti reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d 0 /f
# https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428 https://support.xbox.com/en-US/help/friends-social-activity/share-socialize/xbox-game-bar-performance https://aka.ms/AAh2b88 https://aka.ms/AAh23gr
sudo net localgroup "Пользователи журналов производительности" User /add
# stop qbittorrent/ethernet from waking my pc https://superuser.com/a/1629820/1506333 https://superuser.com/a/1320579 https://aka.ms/AAkvx4s
sudo { powercfg /devicedisablewake "Intel(R) I211 Gigabit Network Connection #2" } # TODO: report this to qbittorent @ test with non-store version TODO: https://github.com/PowerShell/PowerShell/issues/13183
# vbs disable script
sudo .\vbs-disable.ps1
# prefer 7zip from winget
scoop shim rm 7zG 7z 7zfm
# https://www.outsidethebox.ms/21985/
sudo reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy /v fMinimizeConnections /t REG_DWORD /d 0
# https://winaero.com/change-icon-cache-size-windows-10/ 65535
# sudo Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'Max` Cached` Icons' -Type 'String' -Value 512535 -Force
# hide pwsh update notification, delete this if this https://github.com/microsoft/PowerToys/issues/10231 and https://github.com/microsoft/winget-cli/issues/212 is fixed, # TODO: turn update notification off in msstore version
setx POWERSHELL_UPDATECHECK Off
# https://docs.microsoft.com/en-us/windows/application-management/provisioned-apps-windows-client-os https://pureinfotech.com/view-installed-apps-powershell-windows-10/
$debloat = 'Clipchamp.Clipchamp_yxz26nhyzhsrt', 'Microsoft.Todos_8wekyb3d8bbwe', 'Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe', 'Microsoft.Getstarted_8wekyb3d8bbwe', 'Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe', 'Microsoft.ZuneMusic_8wekyb3d8bbwe', 'Microsoft.WindowsCamera_8wekyb3d8bbwe', 'Microsoft.ZuneVideo_8wekyb3d8bbwe', 'Microsoft.WindowsMaps_8wekyb3d8bbwe', 'Microsoft.Windows.Photos_8wekyb3d8bbwe', 'Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe', 'Microsoft.People_8wekyb3d8bbwe', 'Microsoft.BingWeather_8wekyb3d8bbwe', 'Microsoft.BingNews_8wekyb3d8bbwe', 'AdvancedMicroDevicesInc-2.AMDLink_0a9344xs7nr4m', 'Microsoft.GetHelp_8wekyb3d8bbwe', 'BlueStacks` X', 'microsoft.windowscommunicationsapps_8wekyb3d8bbwe', '9MSSGKG348SP' # 'Microsoft.549981C3F5F10_8wekyb3d8bbwe' https://support.microsoft.com/en-us/topic/end-of-support-for-cortana-in-windows-d025b39f-ee5b-4836-a954-0ab646ee1efa?ranMID=24542&OCID=AID2200057_aff_7593_1243925 # 'MicrosoftTeams_8wekyb3d8bbwe'
foreach ($p in $debloat) { sudo winget uninstall --accept-source-agreements -h $p }
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Achievement Watcher.lnk" # TODO: https://github.com/Xav83/chocolatey-packages/pull/24
if (!$env:vm) {
  sudo multipass set local.driver=virtualbox
  multipass set local.privileged-mounts=yes
  multipass set client.gui.autostart=no
  multipass launch --name primary -c 4 -m 4G --disk 10G --mount E:\:/mnt/e_host --mount C:\:/mnt/c_host
  multipass exec primary bash /mnt/c_host/Users/user/git/dotfiles_windows/wsl.sh
}
