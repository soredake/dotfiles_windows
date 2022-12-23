function reloadenv { $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") # https://stackoverflow.com/a/31845512 https://github.com/microsoft/winget-cli/issues/222 } # refreshenv
$packages='AppWork.JDownloader','XPFM5P5KDWF0JP','9NCBCSZSJRSB','9NZVDKPMR9RD','XPDC2RH70K22MN','gerardog.gsudo','BlueStack.BlueStacks','9PMZ94127M4G','Microsoft.PowerShell','Microsoft.VisualStudioCode','TomWatson.BreakTimer','Python.Python.3','9N64SQZTB3LM','ElectronicArts.EADesktop','lycheeverse.lychee'
foreach ($package in $packages) { winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements $package } # https://github.com/microsoft/winget-cli/issues/219
reloadenv
sudo config CacheMode Auto
irm script.sophi.app -useb | iex
sudo Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
# https://www.phoronix.com/news/Windows-11-22H2-Terminal "DefaultTerminalApp -WindowsTerminal"
# CleanupTask -Register, SoftwareDistributionTask -Register, TempTask -Register, StorageSenseTempFiles -Enable, GPUScheduling -Enable
echo '~\Downloads\Sophia*\Sophia.ps1 -Function CreateRestorePoint, "Autoplay -Disable", "CastToDeviceContext -Hide", "ControlPanelView -LargeIcons", "TaskManagerWindow -Expanded", "FileTransferDialog -Detailed", "HiddenItems -Enable", "FileExtensions -Show", "TaskbarChat -Hide", "ControlPanelView -LargeIcons", "TaskManagerWindow -Expanded", "ShortcutsSuffix -Disable", "UnpinTaskbarShortcuts -Shortcuts Edge, Store", "OneDrive -Uninstall", "HEIF -Install", CheckUWPAppsUpdates, "DNSoverHTTPS -Enable -PrimaryDNS 1.0.0.1 -SecondaryDNS 1.1.1.1"' | sudo powershell
sudo powershell -c "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
reloadenv
# https://github.com/chocolatey-community/chocolatey-packages/issues/2072 https://github.com/chocolatey-community/chocolatey-packages/discussions/2040
sudo choco install -y --pin vigembus 64gram achievement-watcher ryujinx steam-rom-manager itch zoom powertoys googledrive parsec goggalaxy hamachi protonvpn steam-client tor-browser hidhide
# TODO: https://community.chocolatey.org/packages/taiga/1.4.0
# TODO: trakt scrobbler
sudo choco install -y --pin --pre pcsx2-dev rpcs3 --params "/Desktop /UseQt"
sudo choco install -y dupeguru keepassxc ffmpeg screentogif.install superf4 responsively insomnia wsldiskshrinker oh-my-posh 7tt 7zip.install qbittorrent doublecmd wiztree nomacs nodejs.install ppsspp retroarch steascree.install ds4windows autoruns choco-cleaner rclone.portable msiafterburner yt-dlp nerdfont-hack tor --params "/DesktopShortcut";
sudo choco install -y git.install --params "/NoShellHereIntegration /NoOpenSSH"; sudo choco install -y syncplay --pre --version 1.7.0-Beta1; sudo choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:19:00'" # reloadenv
pip install internetarchive "git+https://github.com/arecarn/dploy.git" tubeup "git+https://github.com/gdamdam/iagitup.git"
Install-PackageProvider -Name NuGet -Scope CurrentUser -Confirm:$false -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
pwsh -c 'Install-Module -Name posh-git,npm-completion,yarn-completion,Terminal-Icons,PSAdvancedShortcut,PSWindowsUpdate,PSScheduledJob'
sudo wsl --install --no-launch Ubuntu # https://github.com/microsoft/WSL/issues/9266
sudo corepack enable; yarn set version stable # https://yarnpkg.com/getting-started/install https://nodejs.org/dist/latest/docs/api/corepack.html
npm install --global html-validate
pwsh -c 'curl --create-dirs --remote-name-all --output-dir $env:APPDATA\mpv.net\scripts "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/tree-profiles.lua" "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/brace-expand.lua" "https://raw.githubusercontent.com/zenwarr/mpv-config/master/scripts/russian-layout-bindings.lua"'
# https://haali.su/winutils/
Invoke-WebRequest -Uri "https://haali.net/winutils/lswitch.exe" -OutFile $HOME/lswitch.exe
sudo schtasks /create /tn "switch language with right ctrl" /sc onlogon /rl highest /tr "$HOME\lswitch.exe 163"
schtasks /run /tn "switch language with right ctrl"
# winget autoupdate https://github.com/microsoft/winget-cli/issues/212
Invoke-WebRequest -Uri "https://github.com/Romanitho/Winget-AutoUpdate/archive/refs/heads/main.zip" -OutFile "$env:TEMP/Winget-AutoUpdate.zip"
Expand-Archive "$env:TEMP/Winget-AutoUpdate.zip" -DestinationPath "$env:TEMP"
sudo pwsh "$env:TEMP/Winget-AutoUpdate-main/Winget-AutoUpdate-Install.ps1" -NotificationLevel None -UpdatesInterval Weekly -DoNotUpdate -UpdatesAtTime 11AM
sudo pwsh -c 'Invoke-WebRequest -Uri "https://gist.github.com/soredake/f0c63deeaf104e30135a28c3238a6008/raw" -OutFile C:\ProgramData\Winget-AutoUpdate\excluded_apps.txt'

# setup dotfiles
Remove-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
# mkdir $HOME\Documents\PowerShell
sudo dploy stow dotfiles $HOME

# shortcuts
Import-Module -name $HOME\Documents\PowerShell\Modules\PSAdvancedShortcut
# New-Shortcut -Name 'PPSSPP' -Path $HOME\Desktop -Target "C:\Program Files\PPSSPP\PPSSPPWindows64.exe" # TODO: будут ли при апдейте созданы ярлыки обратно? https://github.com/kzdixon/chocolatey-packages/commit/66e63fe217c4d9d22210a09f3d555ff3da880cf6
New-Shortcut -Name 'Yuzu EA no update' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\yuzu\yuzu-windows-msvc-early-access\yuzu.exe" # https://github.com/yuzu-emu/yuzu/issues/9380
New-Shortcut -Name RTSS -Path $HOME\Desktop -Target "C:\Program Files (x86)\RivaTuner Statistics Server\RTSS.exe" # TODO: https://github.com/HunterZ/choco/issues/6
New-Shortcut -Name 'BreakTimer - disable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments disable
New-Shortcut -Name 'BreakTimer - enable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments enable
# add tor service, https://gitlab.torproject.org/tpo/core/tor/-/issues/17145
sudo New-Service -Name "tor" -BinaryPathName '"C:\ProgramData\chocolatey\lib\tor\tools\Tor\tor.exe --nt-service -f C:\Users\User\AppData\Local\tor\torrc"'
# backup task
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument "--title Backup pwsh -c backup") -TaskName "Backup everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -At 12:00 -DaysOfWeek 3)
# update task
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument '--title "Update everything" pwsh -c upgradeall') -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Friday -At 12:00)
# https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsLogon::DisableStartupSound https://aka.ms/AAh46ae
sudo Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableStartupSound' -Value 1 -Force
# disable slide-away lock screen, https://superuser.com/a/1659652/1506333 https://www.techrepublic.com/article/how-to-disable-the-lock-screen-in-windows-11-an-update/ https://aka.ms/AAh3io0
sudo reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization' /v 'NoLockScreen' /t REG_DWORD /d 1 /f
# https://wccftech.com/how-to/how-to-disable-windows-10-background-apps/ https://www.outsidethebox.ms/21739/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f
# https://winitpro.ru/index.php/2021/12/16/udalit-chat-microsoft-teams-v-windows/ https://www.outsidethebox.ms/21375/ https://aka.ms/AAh4nac
sudo --ti reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d 0 /f
# https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428 https://support.xbox.com/en-US/help/friends-social-activity/share-socialize/xbox-game-bar-performance https://aka.ms/AAh2b88 https://aka.ms/AAh23gr
sudo net localgroup "Пользователи журналов производительности" User /add
# stop device connect/remove sound
Remove-Item -Path 'HKCU:\AppEvents\Schemes\Apps\.Default\DeviceConnect\.Current','HKCU:\AppEvents\Schemes\Apps\.Default\DeviceDisconnect\.Current' -Force
# cleanup https://docs.microsoft.com/en-us/windows/application-management/provisioned-apps-windows-client-os https://pureinfotech.com/view-installed-apps-powershell-windows-10/
$debloat='MicrosoftTeams_8wekyb3d8bbwe','Microsoft.Todos_8wekyb3d8bbwe','Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe','Microsoft.Getstarted_8wekyb3d8bbwe','Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe','Microsoft.ZuneMusic_8wekyb3d8bbwe','Microsoft.WindowsCamera_8wekyb3d8bbwe','Microsoft.ZuneVideo_8wekyb3d8bbwe','Microsoft.WindowsMaps_8wekyb3d8bbwe','Microsoft.Windows.Photos_8wekyb3d8bbwe','Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe','Microsoft.People_8wekyb3d8bbwe','Microsoft.BingWeather_8wekyb3d8bbwe','Microsoft.BingNews_8wekyb3d8bbwe','AdvancedMicroDevicesInc-2.AMDLink_0a9344xs7nr4m','Microsoft.GetHelp_8wekyb3d8bbwe','Microsoft.549981C3F5F10_8wekyb3d8bbwe',"BlueStacks X",'microsoft.windowscommunicationsapps_8wekyb3d8bbwe',"windows web experience pack"
foreach ($package in $debloat) { winget uninstall -h $package}
sudo Disable-ScheduledTask "Achievement Watcher Upgrade Daily"
sudo Disable-ScheduledTask "StartAUEP"
sudo Set-Service -Name "AUEPLauncher" -Status stopped -StartupType disabled
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0 # https://remontka.pro/wake-timers-windows/
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Achievement Watcher.lnk","$HOME\Desktop\Google Docs.lnk","$HOME\Desktop\Google Sheets.lnk","$HOME\Desktop\Google Slides.lnk"
sudo Disable-ScheduledTask "Microsoft\Windows\Management\Provisioning\Logon" # https://habr.com/ru/news/t/586786/comments/#comment_23656428 https://aka.ms/AAh177w
# https://windowsloop.com/how-to-remove-amd-radeon-software-from-context-menu/
# sudo reg delete "HKLM\SOFTWARE\Classes\Directory\background\shellex\ContextMenuHandlers\ACE" /f
sudo choco feature enable -n=useRememberedArgumentsForUpgrades -n=removePackageInformationOnUninstall
# amd cleanup task
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument '--title "AMD cleanup task" pwsh -c amdcleanup') -TaskName "AMD cleanup task" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Friday -At 11:00)
