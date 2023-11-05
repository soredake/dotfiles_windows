# [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
sudo winget install --scope machine --no-upgrade -h --accept-package-agreements --accept-source-agreements ViGEm.ViGEmBus ViGEm.HidHide BlueStack.BlueStacks XP99VR1BPSBQJ2 lycheeverse.lychee AppWork.JDownloader Google.Drive GOG.Galaxy DupeGuru.DupeGuru Syncplay.Syncplay alexx2000.DoubleCommander AntibodySoftware.WizTree Rclone.Rclone yt-dlp.yt-dlp Gyan.FFmpeg Parsec.Parsec LogMeIn.Hamachi mcmilk.7zip-zstd Haali.WinUtils.lswitch Libretro.RetroArch HandBrake.HandBrake ElectronicArts.EADesktop OpenJS.NodeJS Microsoft.PowerToys KeePassXCTeam.KeePassXC ProtonTechnologies.ProtonVPN Canonical.Multipass rcmaehl.MSEdgeRedirect Guru3D.Afterburner StrawberryMusicPlayer.Strawberry Oracle.VirtualBox AwthWathje.SteaScree PPSSPPTeam.PPSSPP Oracle.JDK.17 SSHFS-Win.SSHFS-Win Dropbox.Dash
winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements XP8K0HKJFRXGCK 9NFH4HJG2Z9H 9NZVDKPMR9RD XPDC2RH70K22MN 9PMZ94127M4G Python.Python.3.11 9N3SQK8PDS8G XPFM5P5KDWF0JP SteamGridDB.RomManager 64Gram.64Gram Postman.Postman ResponsivelyApp.ResponsivelyApp RussellBanks.Komac RamenSoftware.7+TaskbarTweaker nomacs.nomacs erengy.Taiga ItchIo.Itch 9N64SQZTB3LM WinFsp.WinFsp # nanazip https://github.com/M2Team/NanaZip/issues/86
winget install -h -e --id TomWatson.BreakTimer -v 1.1.0 # https://github.com/tom-james-watson/breaktimer-app/issues/185
winget install Microsoft.VisualStudioCode --no-upgrade -h --accept-package-agreements --accept-source-agreements --custom "/mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'" # https://github.com/microsoft/winget-pkgs/issues/106091
sudo winget install --no-upgrade -h -l ~\Steam Valve.Steam
if (!$env:vm) {
  $env:interfaceIndex = (Get-NetRoute | Where-Object -FilterScript { $_.DestinationPrefix -eq "0.0.0.0/0" } | Get-NetAdapter).InterfaceIndex
  sudo {
    # set static ip https://stackoverflow.com/a/53991926
    New-NetIPAddress -InterfaceIndex $env:interfaceIndex -IPAddress 192.168.0.145 -AddressFamily IPv4 -PrefixLength 24 -DefaultGateway 192.168.0.1
    Get-NetAdapter -Physical | Get-NetIPInterface -AddressFamily IPv4 | Set-DnsClientServerAddress -ServerAddresses 1.1.1.1, 1.0.0.1
    # lychee fix
    Set-NetIPInterface -InterfaceIndex $env:interfaceIndex -InterfaceMetric 1
  }
}
Remove-Item -Recurse -Path ~\Downloads\Sophia*
irm script.sophi.app -useb | iex
sudo { ~\Downloads\Sophia*\Sophia.ps1 -Function "TaskbarSearch -SearchIcon", "CastToDeviceContext -Hide", "ControlPanelView -LargeIcons", "FileTransferDialog -Detailed", "HiddenItems -Enable", "FileExtensions -Show", "TaskbarChat -Hide", "ShortcutsSuffix -Disable", "UnpinTaskbarShortcuts -Shortcuts Edge, Store", "OneDrive -Uninstall", "DNSoverHTTPS -Enable -PrimaryDNS 1.1.1.1 -SecondaryDNS 1.0.0.1", "ThumbnailCacheRemoval -Disable" }
sudo { choco install -y --pin ds4windows tor-browser; choco install -y syncthingtray ytdownloader insomnia choco-cleaner nerdfont-hack tor; choco install -y --pre pcsx2-dev rpcs3 --params "'/DesktopShortcut /NoAdmin'"; choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:19:00'" }
refreshenv # https://github.com/microsoft/winget-cli/issues/3077 https://github.com/chocolatey/choco/issues/2458
foreach ($b in "extras", "games") { scoop bucket add $b }
scoop install cheat-engine yuzu-pineapple ryujinx-ava # https://github.com/Ryujinx/Ryujinx/issues/3662
pip install pipx
pipx ensurepath
$pip = @("internetarchive", "git+https://github.com/arecarn/dploy.git", "tubeup")
foreach ($p in $pip) { pipx install $p } # https://github.com/pypa/pipx/issues/971
Install-PackageProvider -Name NuGet -Scope CurrentUser -Confirm:$false -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name posh-git, npm-completion, Terminal-Icons, PSAdvancedShortcut, CompletionPredictor, command-not-found
npm install --global html-validate gulp-cli create-react-app
curl -L --create-dirs --remote-name-all --output-dir $env:APPDATA\mpv.net\scripts "https://github.com/ekisu/mpv-webm/releases/download/latest/webm.lua" "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/tree-profiles.lua" "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/brace-expand.lua" "https://raw.githubusercontent.com/zenwarr/mpv-config/master/scripts/russian-layout-bindings.lua"
Invoke-WebRequest -Uri "https://github.com/Romanitho/Winget-AutoUpdate/archive/refs/heads/main.zip" -OutFile "$env:TEMP/Winget-AutoUpdate.zip"
Expand-Archive "$env:TEMP/Winget-AutoUpdate.zip" -DestinationPath "$env:TEMP"
sudo "$env:TEMP/Winget-AutoUpdate-main/Winget-AutoUpdate-Install.ps1" -StartMenuShortcut -Silent -NotificationLevel None -UpdatesInterval Weekly -DoNotUpdate -UpdatesAtTime 11AM
sudo mkdir C:\ProgramData\Winget-AutoUpdate
New-Item -ItemType Junction -Path C:\ProgramData\Winget-AutoUpdate\mods -Target $HOME\git\dotfiles_windows\WAU\mods
sudo New-Item -ItemType SymbolicLink -Path C:\ProgramData\Winget-AutoUpdate\excluded_apps.txt -Target $HOME\git\dotfiles_windows\WAU\excluded_apps.txt
# link dotfiles https://github.com/microsoft/terminal/issues/14730
sudo { Remove-Item -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json; New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $HOME\git\dotfiles_windows\dotfiles\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json }
New-Item -Path $env:APPDATA\mpv.net\script-opts -ItemType Directory
sudo dploy stow dotfiles $HOME
# Shortcuts, https://github.com/ScoopInstaller/Scoop/issues/4212 https://github.com/microsoft/winget-cli/issues/3314 https://github.com/hrydgard/ppsspp/issues/17487
Import-Module -Name $HOME\Documents\PowerShell\Modules\PSAdvancedShortcut
New-Shortcut -Name 'Disconnect gamepad' -Path $HOME\Desktop -Target "$env:ChocolateyInstall\bin\DS4Windows.exe" -Arguments "-command Disconnect" -IconPath '$env:ChocolateyInstall\lib\ds4windows\tools\DS4Windows\DS4Windows.exe'
New-Shortcut -Name 'BreakTimer - disable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments disable
New-Shortcut -Name 'BreakTimer - enable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments enable
New-Shortcut -Name 'Cheat Engine' -Path $HOME\Desktop -Target "$HOME\scoop\apps\cheat-engine\current\cheatengine-x86_64.exe"
New-Shortcut -Name 'SteaScree' -Path $HOME\Desktop -Target "${env:ProgramFiles(x86)}\SteaScree\SteaScree.exe"
New-Shortcut -Name 'PPSSPP' -Path $HOME\Desktop -Target "$env:ProgramFiles\PPSSPP\PPSSPPWindows64.exe"
New-Shortcut -Name 'yuzu Early Access' -Path $HOME\Desktop -Target "$HOME\scoop\apps\yuzu-pineapple\current\yuzu.exe"
New-Shortcut -Name 'Ryujinx' -Path $HOME\Desktop -Target "$HOME\scoop\apps\ryujinx-ava\current\Ryujinx.Ava.exe"
# Tasks
sudo { Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WinGet\Links\lswitch.exe" -Argument "163") -TaskName "switch language with right ctrl" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)) -Trigger (New-ScheduledTaskTrigger -AtLogon) }
sudo Start-ScheduledTask -TaskName "switch language with right ctrl"
sudo New-Service -Name "tor" -BinaryPathName '"C:\ProgramData\chocolatey\lib\tor\tools\Tor\tor.exe --nt-service -f $HOME\git\dotfiles_windows\torrc"' # https://gitlab.torproject.org/tpo/core/tor/-/issues/17145
sudo sc failure tor reset=30 actions=restart/5000 # https://serverfault.com/a/983832 TODO: request support for service recovery options in powershell
Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument '--title "AMD cleanup task" pwsh -c amdcleanup') -TaskName "AMD cleanup task" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Friday -At 11:00)
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument "--title Backup pwsh -c backup") -TaskName "Backup everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -At 12:00 -DaysOfWeek 3)
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument '--title "Upgrade everything" pwsh -c upgradeall') -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 11:00)
# https://github.com/chocolatey/choco/issues/1465
sudo choco feature enable -n=useRememberedArgumentsForUpgrades -n=removePackageInformationOnUninstall
# https://remontka.pro/wake-timers-windows/
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0
# disable hibernation
sudo powercfg /h off
# https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsLogon::DisableStartupSound
sudo Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableStartupSound' -Value 1 -Force
# disable slide-away lock screen, https://superuser.com/a/1659652/1506333 https://www.techrepublic.com/article/how-to-disable-the-lock-screen-in-windows-11-an-update/
sudo reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization' /v 'NoLockScreen' /t REG_DWORD /d 1 /f
# https://winaero.com/change-icon-cache-size-windows-10/ 65535 512535
sudo { Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'Max Cached Icons' -Type 'String' -Value 512535 -Force }
# https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428 https://support.xbox.com/en-US/help/friends-social-activity/share-socialize/xbox-game-bar-performance https://aka.ms/AAh2b88 https://aka.ms/AAh23gr
# sudo net localgroup "Пользователи журналов производительности" $env:USERNAME /add
# stop qbittorrent/ethernet from waking my pc from sleep https://superuser.com/a/1629820/1506333 https://superuser.com/a/1320579 https://aka.ms/AAkvx4s
sudo { powercfg /devicedisablewake "Intel(R) I211 Gigabit Network Connection #2" } # TODO: report this to qbittorent @ test with non-store version TODO: https://github.com/PowerShell/PowerShell/issues/13183
# https://www.outsidethebox.ms/21985/
sudo reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WcmSvc\GroupPolicy' /v 'fMinimizeConnections' /t REG_DWORD /d 0 /f
# vbs disable script
sudo --ti .\scripts\vbs-disable\vbs-disable.ps1
# prefer 7zip from winget
scoop shim rm 7zG 7z 7zfm
# pwsh settings https://learn.microsoft.com/en-us/powershell/scripting/learn/experimental-features?view=powershell-7.3
Enable-ExperimentalFeature -Name PSFeedbackProvider
Enable-ExperimentalFeature -Name PSCommandNotFoundSuggestion
# hide pwsh update notification
setx POWERSHELL_UPDATECHECK Off
# multipass setup
if (!$env:vm) {
  sudo multipass set local.driver=virtualbox
  multipass set local.privileged-mounts=yes
  multipass set client.gui.autostart=no
  multipass launch --name primary -c 4 -m 4G --disk 10G --mount E:\:/mnt/e_host --mount D:\:/mnt/d_host --mount C:\:/mnt/c_host
  multipass exec primary bash /mnt/c_host/Users/$env:USERNAME/git/dotfiles_windows/wsl.sh
}
# https://github.com/MicrosoftDocs/windows-itpro-docs/blob/fa1414a7716f274200e9b7829124b2afac29ac20/windows/application-management/provisioned-apps-windows-client-os.md https://pureinfotech.com/view-installed-apps-powershell-windows-10/ ||| sudo { Get-AppxPackage -AllUsers | Select-Object -Property PackageFamilyName }
# https://www.neowin.net/news/windows-11-insider-canary-channel-build-25987-adds-png-viewing-and-editing-metadata-support/ Microsoft.WindowsMaps_8wekyb3d8bbwe Microsoft.ZuneVideo_8wekyb3d8bbwe
sudo winget uninstall --accept-source-agreements -h Clipchamp.Clipchamp_yxz26nhyzhsrt Microsoft.Todos_8wekyb3d8bbwe Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe Microsoft.Getstarted_8wekyb3d8bbwe Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe Microsoft.ZuneMusic_8wekyb3d8bbwe Microsoft.WindowsCamera_8wekyb3d8bbwe Microsoft.Windows.Photos_8wekyb3d8bbwe Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe Microsoft.People_8wekyb3d8bbwe Microsoft.BingWeather_8wekyb3d8bbwe Microsoft.BingNews_8wekyb3d8bbwe AdvancedMicroDevicesInc-2.AMDLink_0a9344xs7nr4m microsoft.windowscommunicationsapps_8wekyb3d8bbwe MicrosoftCorporationII.WindowsSubsystemForLinux_8wekyb3d8bbwe
sudo --ti { Remove-Item -Path "C:\ProgramData\Microsoft\Windows Defender", "C:\ProgramData\Microsoft\WSL" -Recurse }
