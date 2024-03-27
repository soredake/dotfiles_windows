# Virtual Machine check
if ((Get-CimInstance -ClassName CIM_ComputerSystem).Model -match "Virtual|VMware") { $env:vm = 1 }

# Documents folder is moved to OneDrive
$documentsPath = [Environment]::GetFolderPath('MyDocuments')

if (!$env:vm) {
  $env:interfaceIndex = (Get-NetRoute | Where-Object -FilterScript { $_.DestinationPrefix -eq "0.0.0.0/0" } | Get-NetAdapter).InterfaceIndex
  sudo {
    # set static ip https://stackoverflow.com/a/53991926
    New-NetIPAddress -InterfaceIndex $env:interfaceIndex -IPAddress 192.168.0.145 -AddressFamily IPv4 -PrefixLength 24 -DefaultGateway 192.168.0.1
    Get-NetAdapter -Physical | Get-NetIPInterface -AddressFamily IPv4 | Set-DnsClientServerAddress -ServerAddresses 1.1.1.1, 1.0.0.1
  }
}

# Adding scoop buckets
'games', 'extras', 'versions', 'sysinternals', 'java', 'nirsoft', 'nonportable' | ForEach-Object { scoop bucket add $_ }
scoop bucket add naderi "https://github.com/naderi/scoop-bucket"

# Installing my winget packages
winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements 9N8G7TSCL18R XP8K0HKJFRXGCK 9NZVDKPMR9RD Discord.Discord 9P2B8MCSVPLN 9NTXGKQ8P7N0 Viber.Viber Python.Python.3.12 Haali.WinUtils.lswitch mpv.net SteamGridDB.RomManager 64gram postman responsivelyapp komac nomacs erengy.Taiga itch.io specialk IanWalton.JellyfinMPVShim Plex.Plexamp

# Downloading sophiscript
Invoke-WebRequest script.sophia.team -useb | Invoke-Expression

sudo {
  # https://aka.ms/AAh4e0n https://aka.ms/AAftbsj https://aka.ms/AAd9j9k https://aka.ms/AAoal1u
  ~\Downloads\Sophia*\Sophia.ps1 -Function "CreateRestorePoint", "TaskbarSearch -SearchIcon", "ControlPanelView -LargeIcons", "FileTransferDialog -Detailed", "ShortcutsSuffix -Disable", "UnpinTaskbarShortcuts -Shortcuts Edge, Store", "DNSoverHTTPS -Enable -PrimaryDNS 1.1.1.1 -SecondaryDNS 1.0.0.1", "Windows10ContextMenu -Enable", "Hibernation -Disable"

  # https://aka.ms/AAnr43h https://aka.ms/AAnr43j
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements EpicGames.EpicGamesLauncher WireGuard.WireGuard Microsoft.OfficeDeploymentTool Chocolatey.Chocolatey virtualbox Ryochan7.DS4Windows AppWork.JDownloader Google.GoogleDrive GOG.Galaxy dupeguru Syncplay.Syncplay doublecmd wiztree Parsec.Parsec hamachi 7zip-zstd eaapp KeePassXCTeam.KeePassXC protonvpn multipass msedgeredirect afterburner rivatuner bcuninstaller voidtools.Everything strawberry-music AwthWathje.SteaScree PPSSPPTeam.PPSSPP sshfs-win Dropbox.Dash galaclient RamenSoftware.Windhawk qBittorrent.qBittorrent AdoptOpenJDK.OpenJDK.11 HermannSchinagl.LinkShellExtension Plex.Plex Jellyfin.JellyfinMediaPlayer Jellyfin.Server XPFM11Z0W10R7G xp8jrf5sxv03zm

  # lychee is installed in machine scope until https://github.com/microsoft/winget-cli/issues/4044 is fixed
  # PowerToys is here because i need to remap my broken ESC key to PAUSE
  winget install --scope machine --no-upgrade -h --accept-package-agreements --accept-source-agreements Microsoft.PowerToys lycheeverse.lychee

  # Windows 11 installer wipes Program Files directories so i install Steam to user directory now
  winget install --no-upgrade -h -l ~\Steam Valve.Steam

  # This requires UAC
  scoop install rom-properties-np

  # Chocolatey stuff
  choco install -y syncthingtray choco-cleaner nerd-fonts-hack tor samsung-magician
  choco install -y --pre pcsx2-dev rpcs3 --params "'/NoAdmin'"
  choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:10:00'"
  # https://github.com/bcurran3/ChocolateyPackages/issues/48
  Set-ScheduledTask -TaskName choco-cleaner -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable)
  # https://github.com/chocolatey/choco/issues/797#issuecomment-1515603050
  choco feature enable -n=useRememberedArgumentsForUpgrades

  # Installing microsoft office suite
  C:\Program` Files\OfficeDeploymentTool\setup.exe /configure $PSScriptRoot\Office-Config.xml

  # I need all the latest fixes
  wsl --update --pre-release

  # For storing ssh key
  powershell -c 'Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0'
  Set-Service -Name ssh-agent -StartupType Automatic

  # WAU installation
  git clone --depth=1 "https://github.com/Romanitho/Winget-AutoUpdate" "$HOME/Downloads/Winget-AutoUpdate"
  ~\Downloads\Winget-AutoUpdate\Sources\WAU\Winget-AutoUpdate-Install.ps1 -StartMenuShortcut -Silent -InstallUserContext -NotificationLevel Full -UpdatesInterval Weekly -DoNotUpdate -UpdatesAtTime 11AM
  Remove-Item -Path C:\ProgramData\Winget-AutoUpdate\excluded_apps.txt

  # https://github.com/microsoft/terminal/issues/2933 https://github.com/microsoft/terminal/issues/14730
  Remove-Item -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
  New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $HOME\git\dotfiles_windows\dotfiles\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

  # OneDrive can't backup symlinks
  New-Item -ItemType HardLink -Path "$documentsPath\PowerShell\Profile.ps1" -Target "$HOME\git\dotfiles_windows\dotfiles\Documents\PowerShell\Profile.ps1"

  # Linking dotfiles
  dploy stow WAU C:\ProgramData\Winget-AutoUpdate
  dploy stow dotfiles $HOME

  # Task for enabling language change by pressing right ctrl
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe lswitch) -Argument "163") -TaskName "switch language with right ctrl" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)) -Trigger (New-ScheduledTaskTrigger -AtLogon)
  Start-ScheduledTask -TaskName "switch language with right ctrl"

  # https://gitlab.torproject.org/tpo/core/tor/-/issues/17145
  New-Service -Name "tor" -BinaryPathName '"C:\ProgramData\chocolatey\lib\tor\tools\Tor\tor.exe --nt-service -f $HOME\git\dotfiles_windows\torrc"'
  # https://serverfault.com/a/983832 TODO: request support for service recovery options in pwsh
  sc failure tor reset=30 actions=restart/5000

  # Backup task
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe" -Argument "-c backup") -TaskName "Backup everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -At 13:00 -DaysOfWeek 3)

  # Upgrade everything with topgrade task
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe" -Argument "-c upgradeall") -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 12:00)

  # https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsLogon::DisableStartupSound https://aka.ms/AAns3as
  reg add 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' /v DisableStartupSound /t REG_DWORD /d 1 /f
  # disable slide-away lock screen, https://superuser.com/a/1659652/1506333 https://aka.ms/AAnrbky https://aka.ms/AAnrixl
  reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization' /v NoLockScreen /t REG_DWORD /d 1 /f

  # https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428 https://support.xbox.com/en-US/help/friends-social-activity/share-socialize/xbox-game-bar-performance https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers https://aka.ms/AAh2b88 https://aka.ms/AAh23gr https://aka.ms/AAnrbkw
  Add-LocalGroupMember -Group ((New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-559")).Translate([System.Security.Principal.NTAccount]).Value.Replace("BUILTIN\", "")) -Member $env:USERNAME

  # I don't need defender https://remontka.pro/windows-defender-turn-off/
  reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender' /v DisableAntiSpyware /t REG_DWORD /d 1 /f
  reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender' /v ServiceKeepAlive /t REG_DWORD /d 0 /f
  reg add 'HKLM\SOFTWARE\Policies\Microsoft\Microsoft Antimalware\SpyNet' /v SubmitSamplesConsent /t REG_DWORD /d 0 /f
  reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection' /v DisableIOAVProtection /t REG_DWORD /d 1 /f
  reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection' /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f

  # I need local manifests
  winget settings --enable LocalManifestFiles

  # To list all inbox packages:
  # $allPackages = Get-AppxPackage -AllUsers; $startApps = Get-StartApps; $allPackages | % { $pkg = $_; $startApps | ? { $_.AppID -like "*$($pkg.PackageFamilyName)*" } | % { New-Object PSObject -Property @{PackageFamilyName=$pkg.PackageFamilyName; AppName=$_.Name} } } | Format-List
  # --accept-source-agreements
  winget uninstall -h Clipchamp.Clipchamp_yxz26nhyzhsrt Microsoft.Todos_8wekyb3d8bbwe Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe Microsoft.WindowsCamera_8wekyb3d8bbwe Microsoft.Windows.Photos_8wekyb3d8bbwe Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe Microsoft.BingWeather_8wekyb3d8bbwe Microsoft.BingNews_8wekyb3d8bbw microsoft.windowscommunicationsapps_8wekyb3d8bbwe Microsoft.OutlookForWindows_8wekyb3d8bbwe Microsoft.ZuneMusic_8wekyb3d8bbwe Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe Microsoft.OfficeDeploymentTool
}

# WSL2
wsl --install --no-launch Ubuntu-22.04

# https://github.com/tom-james-watson/breaktimer-app/issues/185
winget install -h -e --id TomWatson.BreakTimer -v 1.1.0

# https://github.com/microsoft/winget-pkgs/issues/106091 https://github.com/microsoft/vscode/issues/198519
winget install vscode --no-upgrade -h --accept-package-agreements --accept-source-agreements --custom "/mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'"

# https://github.com/ScoopInstaller/Scoop/issues/5234 https://github.com/microsoft/winget-cli/issues/3240 https://github.com/microsoft/winget-cli/issues/3077 https://github.com/microsoft/winget-cli/issues/222, nodejs installer uses machine scope https://github.com/nodejs/version-management/issues/16
# Portable apps are migrated to scoop until https://github.com/microsoft/winget-cli/issues/361, https://github.com/microsoft/winget-cli/issues/2299, https://github.com/microsoft/winget-cli/issues/4044, https://github.com/microsoft/winget-cli/issues/4070 and https://github.com/microsoft/winget-pkgs/issues/500 are fixed
# https://github.com/ScoopInstaller/Scoop/issues/5234 software that cannot be moved to scoop because of firewall/defender annoyance: lychee yuzu-pineapple (only multiplayer) and syncthingtray
# https://github.com/ScoopInstaller/Scoop/issues/2035 software that cannot be moved to scoop because scoop cleanup cannot close running programs: syncthingtray
scoop install eza lsd cheat-engine yuzu-pineapple nodejs ryujinx winsetview yt-dlp ffmpeg rclone bfg tor-browser psexec topgrade pipx plex-mpv-shim retroarch regscanner nosleep sonixd windows11-classic-context-menu "https://raw.githubusercontent.com/aandrew-me/ytDownloader/main/ytdownloader.json" # yuzu-pineapple is dead
scoop hold ryujinx tor-browser

pipx install internetarchive "git+https://github.com/arecarn/dploy.git" tubeup "git+https://github.com/iamkroot/trakt-scrobbler.git" subliminal guessit
# https://github.com/jjjake/internetarchive/pull/621
pipx inject tubeup setuptools
pipx inject internetarchive setuptools
pipx inject subliminal setuptools
# https://github.com/guessit-io/guessit/issues/766
pipx inject guessit setuptools

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
# Terminal-Icons
Install-Module -Name posh-git, PSAdvancedShortcut, CompletionPredictor, PSCompletions
psc add npm winget scoop
npm i -g html-validate gulp-cli create-react-app
New-Item -Path $env:APPDATA\trakt-scrobbler, $env:APPDATA\plex-mpv-shim -ItemType Directory
curl -L --create-dirs --remote-name-all --output-dir $env:APPDATA\mpv.net\scripts "https://github.com/serenae-fansubs/mpv-webm/releases/download/latest/webm.lua" "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/zenwarr/mpv-config/master/scripts/russian-layout-bindings.lua" "https://github.com/CogentRedTester/mpv-sub-select/raw/master/sub-select.lua"

# TODO: make mpv command name configurable
(Get-Content "$env:APPDATA\mpv.net\scripts\webm.lua") -replace '"mpv"', '"mpvnet.exe"' | Set-Content "$env:APPDATA\mpv.net\scripts\webm.lua"

# Multipass setup
if (!$env:vm) {
  sudo multipass set local.driver=virtualbox
  multipass set local.privileged-mounts=yes
  multipass set client.gui.autostart=no
  multipass launch --name primary -c 4 -m 4G --mount E:\:/mnt/e_host --mount D:\:/mnt/d_host --mount C:\:/mnt/c_host
  multipass exec primary bash /mnt/c_host/Users/$env:USERNAME/git/dotfiles_windows/wsl.sh
}

# Misc
mkdir $HOME\torrents
trakts autostart enable
psc config update 0
psc config module_update 0
# psc ui menu powershell
firefox -CreateProfile letyshops

# https://remontka.pro/wake-timers-windows/
# https://winaero.com/windows-11-may-soon-install-monthly-updates-without-a-reboot/
# powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0

# https://www.elevenforum.com/t/turn-on-or-off-enhance-pointer-precision-in-windows-11.7327/
reg add 'HKCU\Control Panel\Mouse' /v MouseSpeed /t REG_SZ /d 0 /f
reg add 'HKCU\Control Panel\Mouse' /v MouseThreshold1 /t REG_SZ /d 0 /f
reg add 'HKCU\Control Panel\Mouse' /v MouseThreshold2 /t REG_SZ /d 0 /f

# Shortcuts https://github.com/microsoft/winget-cli/issues/3314
Import-Module -Name $documentsPath\PowerShell\Modules\PSAdvancedShortcut
Invoke-WebRequest -Uri "https://icon-icons.com/downloadimage.php?id=152991&root=2552/ICO/48/&file=firefox_browser_logo_icon_152991.ico" -OutFile "$env:TEMP\firefox.ico"
New-Shortcut -Name 'Firefox - LetyShops profile' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Microsoft\WindowsApps\firefox.exe" -Arguments "-P letyshops" -IconPath "$env:TEMP\firefox.ico"
New-Shortcut -Name 'BreakTimer - disable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments disable
New-Shortcut -Name 'BreakTimer - enable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments enable

# WinSetView https://aka.ms/AAnqwpr https://aka.ms/AAnriyc https://aka.ms/AAnr44v
winsetview.ps1 $PSScriptRoot\explorer-preset.ini
