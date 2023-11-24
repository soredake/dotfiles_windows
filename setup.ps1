# [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
# https://www.outsidethebox.ms/9961/#default-state https://aka.ms/AAns3an
sudo Enable-ComputerRestore -Drive $env:SystemDrive
if (!$env:vm) {
  $env:interfaceIndex = (Get-NetRoute | Where-Object -FilterScript { $_.DestinationPrefix -eq "0.0.0.0/0" } | Get-NetAdapter).InterfaceIndex
  sudo { # set static ip https://stackoverflow.com/a/53991926
    New-NetIPAddress -InterfaceIndex $env:interfaceIndex -IPAddress 192.168.0.145 -AddressFamily IPv4 -PrefixLength 24 -DefaultGateway 192.168.0.1
    Get-NetAdapter -Physical | Get-NetIPInterface -AddressFamily IPv4 | Set-DnsClientServerAddress -ServerAddresses 1.1.1.1, 1.0.0.1 }
  $env:interfaceGuid = (Get-NetAdapter | Where-Object { $_.InterfaceDescription -like 'Intel(R) I211*' } | Select-Object -Property InterfaceGuid).InterfaceGuid
  # TODO: delete this
  # http://war2.ru/modules/newbb_plus/viewtopic.php?topic_id=1882&forum=1
  # https://www.ru.playblackdesert.com/Community/Detail?topicNo=45670&topicType=101#
  sudo { reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$env:interfaceGuid" /v 'TcpAckFrequency' /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$env:interfaceGuid" /v 'TCPNoDelay' /t REG_DWORD /d 1 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$env:interfaceGuid" /v 'TcpDelAckTicks' /t REG_DWORD /d 0 /f
    reg add 'HKLM\SOFTWARE\Microsoft\MSMQ\Parameters' /v 'TCPNoDelay' /t REG_DWORD /d 1 /f }
}
Remove-Item -Recurse -Path ~\Downloads\Sophia*
irm script.sophi.app -useb | iex
sudo { ~\Downloads\Sophia*\Sophia.ps1 -Function "CreateRestorePoint", "TaskbarSearch -SearchIcon", "ControlPanelView -LargeIcons", "FileTransferDialog -Detailed", "HiddenItems -Enable", "FileExtensions -Show", "TaskbarChat -Hide", "ShortcutsSuffix -Disable", "UnpinTaskbarShortcuts -Shortcuts Edge, Store", "OneDrive -Uninstall", "DNSoverHTTPS -Enable -PrimaryDNS 1.1.1.1 -SecondaryDNS 1.0.0.1", "ThumbnailCacheRemoval -Disable", "Windows10ContextMenu -Enable" } # https://aka.ms/AAh4e0n https://aka.ms/AAftbsj
sudo winget install --scope machine --no-upgrade -h --accept-package-agreements --accept-source-agreements Microsoft.PowerToys
sudo winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements XP99VR1BPSBQJ2 virtualbox Ryochan7.DS4Windows bluestacks AppWork.JDownloader google-drive GOG.Galaxy dupeguru Syncplay.Syncplay doublecmd wiztree Parsec.Parsec hamachi 7zip-zstd retroarch handbrake eaapp nodejs KeePassXCTeam.KeePassXC protonvpn multipass msedgeredirect afterburner strawberry-music AwthWathje.SteaScree PPSSPPTeam.PPSSPP sshfs-win Dropbox.Dash galaclient RamenSoftware.Windhawk qBittorrent.qBittorrent # https://aka.ms/AAnr43h https://aka.ms/AAnr43j
winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements XP8K0HKJFRXGCK 9NZVDKPMR9RD XPDC2RH70K22MN 9PMZ94127M4G 9N3SQK8PDS8G XPFM5P5KDWF0JP 9N64SQZTB3LM Python.Python.3 SteamGridDB.RomManager 64gram postman responsivelyapp komac nomacs erengy.Taiga itch.io Ryujinx.Ryujinx.Ava ytdownloader Rclone.Rclone yt-dlp.yt-dlp Haali.WinUtils.lswitch LesFerch.WinSetView
winget install -h -e --id TomWatson.BreakTimer -v 1.1.0 # https://github.com/tom-james-watson/breaktimer-app/issues/185
winget install vscode --no-upgrade -h --accept-package-agreements --accept-source-agreements --custom "/mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'" # https://github.com/microsoft/winget-pkgs/issues/106091
sudo winget install --no-upgrade -h -l ~\Steam Valve.Steam
sudo { choco install -y --pin tor-browser; choco install -y syncthingtray insomnia choco-cleaner nerdfont-hack tor; choco install -y --pre pcsx2-dev rpcs3 --params "'/NoAdmin'"; choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:19:00'" }
# refreshenv # https://github.com/microsoft/winget-cli/issues/3077 https://github.com/chocolatey/choco/issues/2458
foreach ($b in "extras", "games") { scoop bucket add $b }
scoop install cheat-engine yuzu-pineapple
pip install pipx
pipx ensurepath
$pip = @("internetarchive", "git+https://github.com/arecarn/dploy.git", "tubeup", "trakt-scrobbler")
foreach ($p in $pip) { pipx install $p } # https://github.com/pypa/pipx/issues/971
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name posh-git, npm-completion, Terminal-Icons, PSAdvancedShortcut, CompletionPredictor, command-not-found
npm install --global html-validate gulp-cli create-react-app
curl -L --create-dirs --remote-name-all --output-dir $env:APPDATA\mpv.net\scripts "https://github.com/ekisu/mpv-webm/releases/download/latest/webm.lua" "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/tree-profiles.lua" "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/brace-expand.lua" "https://raw.githubusercontent.com/zenwarr/mpv-config/master/scripts/russian-layout-bindings.lua"
Invoke-WebRequest -Uri "https://github.com/Romanitho/Winget-AutoUpdate/archive/refs/heads/main.zip" -OutFile "$env:TEMP/Winget-AutoUpdate.zip"
Expand-Archive "$env:TEMP/Winget-AutoUpdate.zip" -DestinationPath "$env:TEMP"
sudo { pwsh "$env:TEMP/Winget-AutoUpdate-main/Winget-AutoUpdate-Install.ps1" -StartMenuShortcut -Silent -NotificationLevel None -UpdatesInterval Weekly -DoNotUpdate -UpdatesAtTime 11AM; Remove-Item -Path C:\ProgramData\Winget-AutoUpdate\excluded_apps.txt; dploy stow WAU C:\ProgramData\Winget-AutoUpdate }
# link dotfiles
New-Item -Path $env:APPDATA\mpv.net\script-opts -ItemType Directory
sudo { Remove-Item -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json; New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $HOME\git\dotfiles_windows\dotfiles\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json } # https://github.com/microsoft/terminal/issues/2933 https://github.com/microsoft/terminal/issues/14730
sudo dploy stow dotfiles $HOME
# Shortcuts, https://github.com/ScoopInstaller/Scoop/issues/4212 https://github.com/microsoft/winget-cli/issues/3314 https://github.com/hrydgard/ppsspp/issues/17487
Import-Module -Name $HOME\Documents\PowerShell\Modules\PSAdvancedShortcut
New-Shortcut -Name 'BreakTimer - disable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments disable
New-Shortcut -Name 'BreakTimer - enable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments enable
New-Shortcut -Name 'Ryujinx' -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs" -Target "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Ryujinx.Ryujinx.Ava_Microsoft.Winget.Source_8wekyb3d8bbwe\publish\Ryujinx.Ava.exe"
# Tasks
sudo { Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe lswitch) -Argument "163") -TaskName "switch language with right ctrl" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)) -Trigger (New-ScheduledTaskTrigger -AtLogon) # https://github.com/microsoft/PowerToys/issues/15817
  Start-ScheduledTask -TaskName "switch language with right ctrl"
  New-Service -Name "tor" -BinaryPathName '"C:\ProgramData\chocolatey\lib\tor\tools\Tor\tor.exe --nt-service -f $HOME\git\dotfiles_windows\torrc"' # https://gitlab.torproject.org/tpo/core/tor/-/issues/17145
  sc failure tor reset=30 actions=restart/5000 # https://serverfault.com/a/983832 TODO: request support for service recovery options in powershell
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument "--title Backup pwsh -c backup") -TaskName "Backup everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -At 12:00 -DaysOfWeek 3)
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument '--title "Upgrade everything" pwsh -c upgradeall') -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 11:00)
  # https://github.com/bcurran3/ChocolateyPackages/issues/46 https://github.com/bcurran3/ChocolateyPackages/issues/48
  Set-ScheduledTask -TaskName choco-cleaner -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable) }
# https://docs.chocolatey.org/en-us/configuration#userememberedargumentsforupgrades https://github.com/chocolatey/choco/issues/797#issuecomment-1515603050
sudo choco feature enable -n=useRememberedArgumentsForUpgrades
# https://remontka.pro/wake-timers-windows/
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0
# disable hibernation
sudo powercfg /h off
# https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsLogon::DisableStartupSound https://aka.ms/AAns3as
sudo Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableStartupSound' -Value 1 -Force
# disable slide-away lock screen, https://superuser.com/a/1659652/1506333 https://aka.ms/AAnrbky https://aka.ms/AAnrixl
sudo reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization' /v 'NoLockScreen' /t REG_DWORD /d 1 /f
# https://winaero.com/change-icon-cache-size-windows-10/ https://www.elevenforum.com/t/change-icon-cache-size-in-windows-11.2050/ 65535 512535
# sudo { Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'MaxCachedIcons' -Type 'String' -Value 65535 -Force }
# https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428 https://support.xbox.com/en-US/help/friends-social-activity/share-socialize/xbox-game-bar-performance https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers https://aka.ms/AAh2b88 https://aka.ms/AAh23gr https://aka.ms/AAnrbkw
sudo { Add-LocalGroupMember -Group ((New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-559")).Translate([System.Security.Principal.NTAccount]).Value.Replace("BUILTIN\", "")) -Member $env:USERNAME }
# https://remontka.pro/windows-defender-turn-off/
sudo { reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender' /v 'DisableAntiSpyware' /t REG_DWORD /d 1 /f
  reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender' /v 'ServiceKeepAlive' /t REG_DWORD /d 1 /f
  reg add 'HKLM\SOFTWARE\Policies\Microsoft\Microsoft Antimalware\SpyNet' /v 'SubmitSamplesConsent' /t REG_DWORD /d 0 /f
  reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection' /v 'DisableIOAVProtection' /t REG_DWORD /d 1 /f
  reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection' /v 'DisableRealtimeMonitoring' /t REG_DWORD /d 1 /f }
# disable vbs
sudo Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All, VirtualMachinePlatform
# prefer 7zip from winget
scoop shim rm 7zG 7z 7zfm
# https://learn.microsoft.com/en-us/powershell/scripting/learn/experimental-features?view=powershell-7.4
Enable-ExperimentalFeature -Name PSCommandNotFoundSuggestion
# hide pwsh update notification https://github.com/PowerShell/PowerShell/issues/19528 https://github.com/PowerShell/PowerShell/issues/19520 https://github.com/PowerShell/PowerShell/issues/20210
# TODO: disable update check https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4#support-for-microsoft-update-in-powershell-72-and-newer when ENABLE_MU and USE_MU is set to 1
setx POWERSHELL_UPDATECHECK Off
# winget
sudo winget settings --enable LocalManifestFiles
# winsetview https://aka.ms/AAnqwpr https://aka.ms/AAnriyc https://aka.ms/AAnr44v
WinSetView.ps1 explorer-preset.ini
# multipass setup
if (!$env:vm) { sudo multipass set local.driver=virtualbox; multipass set local.privileged-mounts=yes; multipass set client.gui.autostart=no; multipass launch --name primary -c 4 -m 4G --mount E:\:/mnt/e_host --mount D:\:/mnt/d_host --mount C:\:/mnt/c_host; multipass exec primary bash /mnt/c_host/Users/$env:USERNAME/git/dotfiles_windows/wsl.sh }
# https://github.com/MicrosoftDocs/windows-itpro-docs/blob/fa1414a7716f274200e9b7829124b2afac29ac20/windows/application-management/provisioned-apps-windows-client-os.md sudo { Get-AppxPackage -AllUsers | Select-Object -Property PackageFamilyName }
sudo winget uninstall --accept-source-agreements -h Clipchamp.Clipchamp_yxz26nhyzhsrt Microsoft.Todos_8wekyb3d8bbwe Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe Microsoft.WindowsCamera_8wekyb3d8bbwe Microsoft.Windows.Photos_8wekyb3d8bbwe Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe Microsoft.People_8wekyb3d8bbwe Microsoft.BingWeather_8wekyb3d8bbwe Microsoft.BingNews_8wekyb3d8bbwe AdvancedMicroDevicesInc-2.AMDLink_0a9344xs7nr4m microsoft.windowscommunicationsapps_8wekyb3d8bbwe Microsoft.ZuneMusic_8wekyb3d8bbwe
# trakts setup
trakts autostart enable
trakts config set players.monitored mpv syncplay@mpv
trakts config set fileinfo.whitelist E:\non-anime, E:\shared-unruhe
trakts config set players.mpv.ipc_path \\.\pipe\mpvsocket
