# Virtual Machine check
if ((Get-CimInstance -ClassName CIM_ComputerSystem).Model -match "Virtual|VMware") { $env:vm = 1 }

# Documents and Desktop folders are moved to OneDrive
$documentsPath = [Environment]::GetFolderPath('MyDocuments')
$desktopPath = [Environment]::GetFolderPath('Desktop')

if (!$env:vm) {
  $env:interfaceIndex = (Get-NetRoute | Where-Object -FilterScript { $_.DestinationPrefix -eq "0.0.0.0/0" } | Get-NetAdapter).InterfaceIndex
  sudo {
    # Set static IP https://stackoverflow.com/a/53991926
    New-NetIPAddress -InterfaceIndex $env:interfaceIndex -IPAddress 192.168.0.145 -AddressFamily IPv4 -PrefixLength 24 -DefaultGateway 192.168.0.1
    Get-NetAdapter -Physical | Get-NetIPInterface -AddressFamily IPv4 | Set-DnsClientServerAddress -ServerAddresses 1.1.1.1, 1.0.0.1
  }
}

# Adding scoop buckets
'games', 'extras', 'versions', 'sysinternals', 'java', 'nirsoft', 'nonportable' | ForEach-Object { scoop bucket add $_ }
scoop bucket add naderi "https://github.com/naderi/scoop-bucket"

# Installing my winget packages
winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements Discord.Discord Viber.Viber Python.Python.3.12 Haali.WinUtils.lswitch SteamGridDB.RomManager 64gram komac nomacs erengy.Taiga itch.io specialk IanWalton.JellyfinMPVShim Reshade.Setup.AddonsSupport Playnite.Playnite PragmaTwice.proxinject lycheeverse.lychee HumbleBundle.HumbleApp XP8K0HKJFRXGCK 9NZVDKPMR9RD 9P2B8MCSVPLN 9NTXGKQ8P7N0

# Installing my scoop packages
# https://github.com/ScoopInstaller/Scoop/issues/5234 https://github.com/microsoft/winget-cli/issues/3240 https://github.com/microsoft/winget-cli/issues/3077 https://github.com/microsoft/winget-cli/issues/222, NodeJS installer uses machine scope https://github.com/nodejs/version-management/issues/16
# Portable apps are migrated to scoop until https://github.com/microsoft/winget-cli/issues/361, https://github.com/microsoft/winget-cli/issues/2299, https://github.com/microsoft/winget-cli/issues/4044, https://github.com/microsoft/winget-cli/issues/4070 and https://github.com/microsoft/winget-pkgs/issues/500 are fixed
# https://github.com/ScoopInstaller/Scoop/issues/5234 software that cannot be moved to scoop because of firewall/defender annoyance: lychee sudachi (only multiplayer), NodeJS and syncthingtray
# https://github.com/ScoopInstaller/Scoop/issues/2035 https://github.com/ScoopInstaller/Scoop/issues/5852 software that cannot be moved to scoop because scoop cleanup cannot close running programs: syncthingtray
scoop install windows11-classic-context-menu 7zip-zstd cheat-engine ryujinx winsetview yt-dlp-master ffmpeg rclone bfg tor-browser psexec topgrade pipx plex-mpv-shim retroarch regscanner nosleep mpv-git sudachi proxychains process-explorer vivetool mkvtoolnix "https://raw.githubusercontent.com/aandrew-me/ytDownloader/main/ytdownloader.json"
scoop hold ryujinx tor-browser

# https://github.com/arecarn/dploy/issues/8
New-Item -Path $env:APPDATA\trakt-scrobbler, $env:APPDATA\plex-mpv-shim, $HOME\scoop\apps\mpv-git\current\portable_config\scripts -ItemType Directory

# ff2mpv
git clone --depth=1 "https://github.com/woodruffw/ff2mpv" $HOME\git\ff2mpv
pwsh $HOME\git\ff2mpv\install.ps1 firefox

# Downloading sophiscript
Invoke-WebRequest script.sophia.team -useb | Invoke-Expression

sudo {
  # https://aka.ms/AAh4e0n https://aka.ms/AAftbsj https://aka.ms/AAd9j9k https://aka.ms/AAoal1u
  # https://www.outsidethebox.ms/22048/
  # Suggest ways to get the most out of Windows…: WhatsNewInWindows -Disable
  # Show the Windows welcome experience…: WindowsWelcomeExperience -Hide
  # Get tips and suggestions when using Windows…: WindowsTips -Disable
  ~\Downloads\Sophia*\Sophia.ps1 -Function "CreateRestorePoint", "TaskbarSearch -Hide", "ControlPanelView -LargeIcons", "FileTransferDialog -Detailed", "ShortcutsSuffix -Disable", "UnpinTaskbarShortcuts -Shortcuts Edge, Store", "DNSoverHTTPS -Enable -PrimaryDNS 1.1.1.1 -SecondaryDNS 1.0.0.1", "Hibernation -Disable", "CastToDeviceContext -Hide", "ThumbnailCacheRemoval -Disable", "SaveRestartableApps -Enable", "WhatsNewInWindows -Disable", "UpdateMicrosoftProducts -Enable"

  # https://aka.ms/AAnr43h https://aka.ms/AAnr43j
  # Some monikers can't be used until https://github.com/microsoft/winget-cli/issues/3547 is fixed
  # Jellyfin.Server cannot be installed silently https://github.com/jellyfin/jellyfin-server-windows/issues/109
  winget install --no-upgrade --accept-package-agreements --accept-source-agreements Jellyfin.Server

  # run-hidden is needed because of this https://github.com/PowerShell/PowerShell/issues/3028
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements abbodi1406.vcredist OpenJS.NodeJS.LTS Rem0o.FanControl epicgameslauncher WireGuard.WireGuard Microsoft.OfficeDeploymentTool Chocolatey.Chocolatey virtualbox Ryochan7.DS4Windows AppWork.JDownloader google-drive GOG.Galaxy dupeguru doublecmd wiztree Parsec.Parsec hamachi eaapp KeePassXCTeam.KeePassXC protonvpn multipass msedgeredirect afterburner rivatuner bcuninstaller voidtools.Everything AwthWathje.SteaScree PPSSPPTeam.PPSSPP sshfs-win galaclient RamenSoftware.Windhawk qBittorrent.qBittorrent AdoptOpenJDK.OpenJDK.11 HermannSchinagl.LinkShellExtension Plex.Plex Jellyfin.JellyfinMediaPlayer Ubisoft.Connect actualsolution.VolumeLock Plex.PlexMediaServer Syncplay.Syncplay Cloudflare.Warp Motorola.ReadyForAssistant stax76.run-hidden

  # SSHFS mounts is broken in >=1.13.0 https://github.com/canonical/multipass/issues/3442
  winget install -h -e --id=Canonical.Multipass -v "1.12.2+win"

  # PowerToys is here because I need to remap my broken ESC key to PAUSE
  # WAU for some reason tries to update OpenJS.NodeJS.LTS in user scope even though it is installed system-wide
  winget install --scope machine --no-upgrade -h --accept-package-agreements --accept-source-agreements Microsoft.PowerToys OpenJS.NodeJS.LTS
  # Windows 11 installer wipes Program Files directories so I install Steam to user directory now
  winget install --no-upgrade -h -l ~\Steam Valve.Steam

  # This requires UAC
  # Traditional installer is not yet created https://github.com/GerbilSoft/rom-properties/issues/108
  scoop install rom-properties-np

  # Chocolatey stuff
  choco install -y syncthingtray choco-cleaner tor samsung-magician nerd-fonts-hack
  choco install -y --pin nerd-fonts-hack
  choco install -y --pre pcsx2-dev rpcs3 --params "'/NoAdmin'"
  choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:10:00'"

  # https://github.com/bcurran3/ChocolateyPackages/issues/48
  Set-ScheduledTask -TaskName choco-cleaner -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable)

  # https://github.com/chocolatey/choco/issues/797#issuecomment-1515603050
  choco feature enable -n=useRememberedArgumentsForUpgrades -n=removePackageInformationOnUninstall

  # Installing Microsoft Office suite
  C:\Program` Files\OfficeDeploymentTool\setup.exe /configure $PSScriptRoot\Office-Config.xml

  # I need all the latest fixes
  wsl --update --pre-release

  # For storing ssh key
  powershell -c 'Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0'
  Set-Service -Name ssh-agent -StartupType Automatic

  # Winget-AutoUpdate installation
  git clone --depth=1 "https://github.com/Romanitho/Winget-AutoUpdate" "$HOME/Downloads/Winget-AutoUpdate"
  ~\Downloads\Winget-AutoUpdate\Sources\WAU\Winget-AutoUpdate-Install.ps1 -StartMenuShortcut -Silent -InstallUserContext -NotificationLevel Full -UpdatesInterval BiDaily -DoNotUpdate -UpdatesAtTime 11AM
  Remove-Item -Path C:\ProgramData\Winget-AutoUpdate\excluded_apps.txt
  dploy stow $PSScriptRoot\WAU C:\ProgramData\Winget-AutoUpdate

  # https://github.com/microsoft/terminal/issues/2933 https://github.com/microsoft/terminal/issues/14730
  Remove-Item -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
  New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $HOME\git\dotfiles_windows\dotfiles\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

  # OneDrive can't backup symlinks
  New-Item -ItemType HardLink -Path "$documentsPath\PowerShell\Profile.ps1" -Target "$HOME\git\dotfiles_windows\dotfiles\Documents\PowerShell\Profile.ps1"

  # Linking dotfiles
  dploy stow $PSScriptRoot\dotfiles $HOME

  # https://gitlab.torproject.org/tpo/core/tor/-/issues/17145
  New-Service -Name "tor" -BinaryPathName '"C:\ProgramData\chocolatey\lib\tor\tools\Tor\tor.exe --nt-service -f $HOME\git\dotfiles_windows\torrc"'
  # https://serverfault.com/a/983832 https://github.com/PowerShell/PowerShell/issues/21400
  sc failure tor reset=30 actions=restart/5000
  # I need tor to install AIMP
  sc start tor

  # Installing AIMP requires proxy
  # [net.webrequest]::defaultwebproxy = new-object net.webproxy "http://127.0.0.1:8118"
  # scoop install aimp
  # TODO: waiting for AIMP pr to be merged
  #winget install -h AIMP.AIMP --proxy "http://127.0.0.1:8118" --architecture x86

  # Task for enabling language change by pressing right ctrl
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe lswitch) -Argument "163") -TaskName "switch language with right ctrl" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)) -Trigger (New-ScheduledTaskTrigger -AtLogon)
  Start-ScheduledTask -TaskName "switch language with right ctrl"

  # Tasks for starting and stopping lycheefix
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -c lycheefixon") -TaskName "Start lycheefix"
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -c lycheefixoff") -TaskName "Stop lycheefix"

  # Task for restarting Taiga every day until https://github.com/erengy/taiga/issues/1120 and https://github.com/erengy/taiga/issues/1161 is fixed
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -File $HOME\git\dotfiles_windows\scripts\restart-taiga.ps1") -TaskName "Restart Taiga every day" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00)

  # Task for restarting qBittorrent every day until https://github.com/qbittorrent/qBittorrent/issues/20305 is fixed
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -File $HOME\git\dotfiles_windows\scripts\restart-qbittorrent.ps1") -TaskName "Restart qBittorrent every day" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00)

  # Backup task
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe" -Argument "-WindowStyle Hidden -c backup") -TaskName "Backup everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -At 13:00 -DaysOfWeek 3)

  # Upgrade everything with topgrade task
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe" -Argument "-WindowStyle Hidden -c upgradeall") -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 12:00)

  # https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsLogon::DisableStartupSound https://aka.ms/AAns3as
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableStartupSound /t REG_DWORD /d 1 /f
  # Disable slide-away lock screen, https://superuser.com/a/1659652/1506333 https://aka.ms/AAnrbky https://aka.ms/AAnrixl
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f
  # https://www.elevenforum.com/t/change-automatic-maintenance-time-in-windows-11.16687/
  reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "Activation Boundary" /t REG_SZ /d "2001-01-01T08:00:00" /f
  # https://github.com/winfsp/sshfs-win/issues/194#issuecomment-632281505
  reg add "HKLM\SOFTWARE\WOW6432Node\WinFsp\Services\sshfs" /v "Recovery" /t REG_DWORD /d 1 /f

  # Register mpv-git associations
  cmd /c $HOME\scoop\apps\mpv-git\current\installer\mpv-install.bat

  # https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428 https://support.xbox.com/en-US/help/friends-social-activity/share-socialize/xbox-game-bar-performance https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers https://aka.ms/AAh2b88 https://aka.ms/AAh23gr https://aka.ms/AAnrbkw
  Add-LocalGroupMember -Group ((New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-559")).Translate([System.Security.Principal.NTAccount]).Value.Replace("BUILTIN\", "")) -Member $env:USERNAME

  # I don't need this file types scanned
  Add-MpPreference -ExclusionExtension ".cbz", ".cbr", ".jpeg", ".jpg", ".png", ".webp", ".avif", ".jxl", ".gif", ".mp3", ".flac", ".ogg", ".wav", ".mkv", ".avi", ".mp4", ".m4v", ".mpg", ".ts", ".webm", ".parts", ".ass", ".srt", ".vhd", ".vhdx", ".vdi", ".vmdk", ".xci", ".nca", ".nsp", ".torrents"

  # I need local manifests
  winget settings --enable LocalManifestFiles

  # To list all inbox packages:
  # $allPackages = Get-AppxPackage -AllUsers; $startApps = Get-StartApps; $allPackages | % { $pkg = $_; $startApps | ? { $_.AppID -like "*$($pkg.PackageFamilyName)*" } | % { New-Object PSObject -Property @{PackageFamilyName=$pkg.PackageFamilyName; AppName=$_.Name} } } | Format-List
  # --accept-source-agreements
  # I converted this to for-each again because of this bug: https://github.com/microsoft/winget-cli/issues/3903
  # Note: after removing notepad you no longer can create .txt files, so don't do this
  $packages = @(
    "Clipchamp.Clipchamp_yxz26nhyzhsrt",
    "Microsoft.Todos_8wekyb3d8bbwe",
    "Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe",
    "Microsoft.WindowsCamera_8wekyb3d8bbwe",
    "Microsoft.Windows.Photos_8wekyb3d8bbwe",
    "Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe",
    "Microsoft.BingWeather_8wekyb3d8bbwe",
    "Microsoft.BingNews_8wekyb3d8bbw",
    "microsoft.windowscommunicationsapps_8wekyb3d8bbwe",
    "Microsoft.OutlookForWindows_8wekyb3d8bbwe",
    "Microsoft.ZuneMusic_8wekyb3d8bbwe",
    "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe",
    "Microsoft.OfficeDeploymentTool"
  )
  foreach ($package in $packages) {
    winget uninstall -h $package
  }
}

# https://github.com/tom-james-watson/breaktimer-app/issues/185
winget install -h -e --id TomWatson.BreakTimer -v 1.1.0

# https://github.com/microsoft/winget-pkgs/issues/106091 https://github.com/microsoft/vscode/issues/198519
winget install vscode --no-upgrade -h --accept-package-agreements --accept-source-agreements --custom "/mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'"

# Add pipx bin dir to PATH
pipx ensurepath

# Refreshing PATH env
. "$HOME/refrenv.ps1"

# Installing pipx packages
pipx install internetarchive tubeup guessit "git+https://github.com/arecarn/dploy.git" "git+https://github.com/iamkroot/trakt-scrobbler.git" "git+https://github.com/Diaoul/subliminal@develop"
# https://github.com/Diaoul/subliminal/issues/1061
#pipx inject subliminal setuptools
# https://github.com/guessit-io/guessit/issues/766
pipx inject guessit setuptools

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
# CompletionPredictor is breaks PSCompletions https://github.com/PowerShell/CompletionPredictor/issues/37
# PSCompletions is no longer installed as I don't use it, and it adds 2-3 seconds to load delay
Install-Module -Name posh-git, PSAdvancedShortcut
#psc add npm winget scoop
npm install --global html-validate gulp-cli create-react-app webtorrent-mpv-hook
curl -L --create-dirs --remote-name-all --output-dir $HOME\scoop\apps\mpv-git\current\portable_config\scripts "https://github.com/ekisu/mpv-webm/releases/download/latest/webm.lua" "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/zenwarr/mpv-config/master/scripts/russian-layout-bindings.lua" "https://github.com/CogentRedTester/mpv-sub-select/raw/master/sub-select.lua" "https://raw.githubusercontent.com/d87/mpv-persist-properties/master/persist-properties.lua" "https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/lua/autoload.lua"
Invoke-WebRequest -Uri "https://github.com/tsl0922/mpv-menu-plugin/releases/download/2.4.1/menu.zip" -OutFile "$HOME/Downloads/mpv-menu-plugin.zip"
Expand-Archive -Force "$HOME/Downloads/mpv-menu-plugin.zip" -DestinationPath "$HOME\scoop\apps\mpv-git\current\portable_config\scripts"
Move-Item -Force "$HOME\scoop\apps\mpv-git\current\portable_config\scripts\menu\*" "$HOME\scoop\apps\mpv-git\current\portable_config\scripts"
Remove-Item -Recurse -Path "$HOME\scoop\apps\mpv-git\current\portable_config\scripts\menu"

# https://github.com/mrxdst/webtorrent-mpv-hook
New-Item -ItemType SymbolicLink -Path "$HOME\scoop\apps\mpv-git\current\portable_config\scripts\webtorrent.js" -Target "$env:APPDATA\npm\node_modules\webtorrent-mpv-hook\build\webtorrent.js"

# https://github.com/CogentRedTester/mpv-sub-select/issues/30
(Get-Content "$HOME\scoop\apps\mpv-git\current\portable_config\scripts\sub-select.lua") -replace 'force_prediction = false', 'force_prediction = true' | Set-Content "$HOME\scoop\apps\mpv-git\current\portable_config\scripts\sub-select.lua"

# Multipass setup
if (!$env:vm) {
  sudo multipass set local.driver=virtualbox
  multipass set local.privileged-mounts=yes
  multipass set client.gui.autostart=no
  multipass launch --name primary -c 4 -m 4G --mount E:\:/mnt/e_host --mount D:\:/mnt/d_host --mount C:\:/mnt/c_host
  multipass exec primary bash /mnt/c_host/Users/$env:USERNAME/git/dotfiles_windows/wsl.sh
  multipass stop
}

# Misc
mkdir $HOME\torrents
trakts autostart enable
#psc config update 0
#psc config module_update 0
firefox -CreateProfile letyshops
firefox -CreateProfile alwaysonproxy

# https://www.elevenforum.com/t/turn-on-or-off-enhance-pointer-precision-in-windows-11.7327/
reg add 'HKCU\Control Panel\Mouse' /v MouseSpeed /t REG_SZ /d 0 /f
reg add 'HKCU\Control Panel\Mouse' /v MouseThreshold1 /t REG_SZ /d 0 /f
reg add 'HKCU\Control Panel\Mouse' /v MouseThreshold2 /t REG_SZ /d 0 /f

# Shortcuts https://github.com/microsoft/winget-cli/issues/3314
Import-Module -Name $documentsPath\PowerShell\Modules\PSAdvancedShortcut
Invoke-WebRequest -Uri "https://icon-icons.com/downloadimage.php?id=152991&root=2552/ICO/48/&file=firefox_browser_logo_icon_152991.ico" -OutFile "$env:TEMP\firefox.ico"
New-Shortcut -Name 'Firefox - LetyShops profile' -Path $desktopPath -Target "$env:LOCALAPPDATA\Microsoft\WindowsApps\firefox.exe" -Arguments "-P letyshops" -IconPath "$env:TEMP\firefox.ico"
New-Shortcut -Name 'Firefox - AlwaysOnProxy profile' -Path $desktopPath -Target "$env:LOCALAPPDATA\Microsoft\WindowsApps\firefox.exe" -Arguments "-P alwaysonproxy" -IconPath "$env:TEMP\firefox.ico"
New-Shortcut -Name 'BreakTimer - disable' -Path $desktopPath -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments disable
New-Shortcut -Name 'BreakTimer - enable' -Path $desktopPath -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments enable

# WinSetView is used to make Windows Explorer sort by date modified (from filesystem metadata) rather than sorting by EXIF metadata (which is VERY slow even on NVMe when you have 1000+ photos or videos in folder): https://superuser.com/questions/487647/sorting-by-date-very-slow https://superuser.com/questions/238825/sort-files-by-date-modified-but-folders-always-before-files-in-windows-explorer https://superuser.com/questions/738978/how-to-prevent-windows-explorer-from-slowly-reading-file-content-to-create-metad
# https://aka.ms/AAnqwpr https://aka.ms/AAnriyc https://aka.ms/AAnr44v
winsetview.ps1 $PSScriptRoot\explorer-preset.ini

# Start Visual Studio Code at logon
# https://www.medo64.com/2021/09/add-application-to-auto-start-from-powershell/
# https://github.com/microsoft/vscode/issues/211583
New-ItemProperty -Path "HKCU:Software\Microsoft\Windows\CurrentVersion\Run" -Name "VSCode" -Value '"C:\Users\user\AppData\Local\Programs\Microsoft VS Code\Code.exe"'
# Start plex-mpv-shim at logon
New-ItemProperty -Path "HKCU:Software\Microsoft\Windows\CurrentVersion\Run" -Name "plex-mpv-shim" -Value '"C:\Users\user\scoop\apps\plex-mpv-shim\current\run.exe"'

# https://www.elevenforum.com/t/add-or-remove-edit-in-notepad-context-menu-in-windows-11.20485/
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{CA6CC9F1-867A-481E-951E-A28C5E4F01EA}" /t REG_SZ /d "" /f

# Enabling classic context menu https://www.outsidethebox.ms/22361/#_842
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# WSL2 installation
wsl --install --no-launch Ubuntu-22.04
