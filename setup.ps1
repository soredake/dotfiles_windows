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

# Installing my scoop packages
# https://github.com/ScoopInstaller/Scoop/issues/5234 https://github.com/microsoft/winget-cli/issues/3240 https://github.com/microsoft/winget-cli/issues/3077 https://github.com/microsoft/winget-cli/issues/222, NodeJS installer uses machine scope https://github.com/nodejs/version-management/issues/16
# Portable apps are migrated to scoop until https://github.com/microsoft/winget-cli/issues/361, https://github.com/microsoft/winget-cli/issues/2299, https://github.com/microsoft/winget-cli/issues/4044, https://github.com/microsoft/winget-cli/issues/4070 and https://github.com/microsoft/winget-pkgs/issues/500 are fixed
# https://github.com/ScoopInstaller/Scoop/issues/5234 software that cannot be moved to scoop because of firewall/defender annoyance: lychee sudachi (only multiplayer), NodeJS and syncthingtray
# https://github.com/ScoopInstaller/Scoop/issues/2035 https://github.com/ScoopInstaller/Scoop/issues/5852 software that cannot be moved to scoop because scoop cleanup cannot close running programs: syncthingtray
scoop install windows11-classic-context-menu 7zip-zstd cheat-engine ryujinx winsetview yt-dlp-master ffmpeg rclone bfg psexec topgrade pipx plex-mpv-shim retroarch regscanner nosleep mpv-git sudachi proxychains process-explorer vivetool mkvtoolnix procmon nircmd "https://raw.githubusercontent.com/aandrew-me/ytDownloader/main/ytdownloader.json" # tor-browser
scoop hold ryujinx # tor-browser

# https://github.com/arecarn/dploy/issues/8
New-Item -Path $env:APPDATA\trakt-scrobbler, $env:APPDATA\plex-mpv-shim, $HOME\scoop\apps\mpv-git\current\portable_config\scripts -ItemType Directory -Force

# ff2mpv
git clone --depth=1 "https://github.com/woodruffw/ff2mpv" $HOME\git\ff2mpv
pwsh $HOME\git\ff2mpv\install.ps1 firefox

# Link winget settings
# Fix for winget downloading speed https://github.com/microsoft/winget-cli/issues/2124
# Do not enable `resume` feature for now https://github.com/microsoft/winget-cli/issues/4584
New-Item -ItemType HardLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Target "$PSScriptRoot\winget-settings.json"

# Downloading Sophia Script
Remove-Item -Path "$HOME\Downloads\Sophia*" -Recurse -Force
Invoke-WebRequest script.sophia.team -useb | Invoke-Expression

# NOTE: do not pass too much code to sudo or you will receive this:
# Program 'sudo.exe' failed to run: The filename or extension is too longAt line:1 char:1

# Sophia Script
sudo {
  # https://aka.ms/AAh4e0n https://aka.ms/AAftbsj https://aka.ms/AAd9j9k https://aka.ms/AAoal1u
  # https://www.outsidethebox.ms/22048/
  # Suggest ways to get the most out of Windows…: WhatsNewInWindows -Disable
  # Show the Windows welcome experience…: WindowsWelcomeExperience -Hide
  # Get tips and suggestions when using Windows…: WindowsTips -Disable
  ~\Downloads\Sophia*\Sophia.ps1 -Function "CreateRestorePoint", "TaskbarSearch -Hide", "ControlPanelView -LargeIcons", "FileTransferDialog -Detailed", "ShortcutsSuffix -Disable", "UnpinTaskbarShortcuts -Shortcuts Edge, Store", "DNSoverHTTPS -Enable -PrimaryDNS 1.1.1.1 -SecondaryDNS 1.0.0.1", "Hibernation -Disable", "ThumbnailCacheRemoval -Disable", "SaveRestartableApps -Enable", "WhatsNewInWindows -Disable", "UpdateMicrosoftProducts -Enable", "InputMethod -English"
}

# Software install
sudo {
  # Jellyfin.Server cannot be installed silently https://github.com/jellyfin/jellyfin-server-windows/issues/109
  winget install --accept-package-agreements --accept-source-agreements Jellyfin.Server

  # https://aka.ms/AAnr43h https://aka.ms/AAnr43j
  # Some monikers can't be used until https://github.com/microsoft/winget-cli/issues/3547 is fixed
  # run-hidden is needed because of this https://github.com/PowerShell/PowerShell/issues/3028
  winget install -h --accept-package-agreements --accept-source-agreements HumbleBundle.HumbleApp lycheeverse.lychee PragmaTwice.proxinject Playnite.Playnite Reshade.Setup.AddonsSupport IanWalton.JellyfinMPVShim specialk itch.io erengy.Taiga nomacs komac 64gram SteamGridDB.RomManager Haali.WinUtils.lswitch Python.Python.3.12 xpfm5p5kdwf0jp Discord.Discord abbodi1406.vcredist OpenJS.NodeJS.LTS Rem0o.FanControl epicgameslauncher WireGuard.WireGuard Microsoft.OfficeDeploymentTool Chocolatey.Chocolatey virtualbox Ryochan7.DS4Windows AppWork.JDownloader google-drive GOG.Galaxy dupeguru doublecmd wiztree Parsec.Parsec hamachi eaapp KeePassXCTeam.KeePassXC protonvpn multipass msedgeredirect afterburner rivatuner bcuninstaller voidtools.Everything AwthWathje.SteaScree PPSSPPTeam.PPSSPP sshfs-win galaclient RamenSoftware.Windhawk qBittorrent.qBittorrent AdoptOpenJDK.OpenJDK.11 HermannSchinagl.LinkShellExtension Plex.Plex Jellyfin.JellyfinMediaPlayer Ubisoft.Connect actualsolution.VolumeLock Plex.PlexMediaServer Syncplay.Syncplay Cloudflare.Warp Motorola.ReadyForAssistant stax76.run-hidden Enyium.NightLight HandBrake.HandBrake HydraLauncher.Hydra SomePythonThings.WingetUIStore Zoom.Zoom.EXE xp8k0hkjfrxgck 9nzvdkpmr9rd 9p2b8mcsvpln 9ntxgkq8p7n0

  # This is needed to display thumbnails for videos with HEVC or cbr/cbz formats
  # https://github.com/microsoft/winget-cli/issues/2771#issuecomment-2197617810
  winget install -h Xanashi.Icaros --source winget

  # SSHFS mounts is broken in >=1.13.0 https://github.com/canonical/multipass/issues/3442
  winget install -h -e --id=Canonical.Multipass -v "1.12.2+win"

  # PowerToys is here because I need to remap my broken ESC key to PAUSE
  # WAU for some reason tries to update OpenJS.NodeJS.LTS in user scope even though it is installed system-wide
  winget install --scope machine -h --accept-package-agreements --accept-source-agreements Microsoft.PowerToys OpenJS.NodeJS.LTS

  # Windows 11 installer wipes Program Files directories, so I install Steam to user directory now
  winget install -h -l ~\Steam Valve.Steam

  # This requires UAC
  # Traditional installer is not yet created https://github.com/GerbilSoft/rom-properties/issues/108
  scoop install rom-properties-np

  # Chocolatey stuff
  choco install -y syncthingtray choco-cleaner tor samsung-magician nerd-fonts-hack
  choco install -y --forcex86 aimp
  choco install -y --pin nerd-fonts-hack
  choco install -y --pre pcsx2-dev rpcs3 --params "'/NoAdmin'"
  # This package is unmaintained and now (18.07.2024) is broken, I now update chocolatey packages with topgrade
  # choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:10:00'"

  # Installing Microsoft Office suite
  # https://config.office.com/deploymentsettings
  C:\Program` Files\OfficeDeploymentTool\setup.exe /configure "$($args[0])\Office-365-Config.xml"

  # I need all the latest fixes
  wsl --update --pre-release

  # For storing ssh key
  powershell -c 'Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0'

  # Winget-AutoUpdate installation
  # https://github.com/Romanitho/Winget-AutoUpdate/issues/625
  git clone --depth=1 "https://github.com/Romanitho/Winget-AutoUpdate" "$HOME/Downloads/Winget-AutoUpdate"
  ~\Downloads\Winget-AutoUpdate\Sources\WAU\Winget-AutoUpdate-Install.ps1 -StartMenuShortcut -Silent -InstallUserContext -NotificationLevel Full -UpdatesInterval BiDaily -DoNotUpdate -UpdatesAtTime 11AM
  Remove-Item -Path C:\ProgramData\Winget-AutoUpdate\excluded_apps.txt
  dploy stow $($args[0])\WAU C:\ProgramData\Winget-AutoUpdate
} -args "$PSScriptRoot"

# Various settings and tasks
sudo {
  # Start ssh-agent at boot
  Set-Service -Name ssh-agent -StartupType Automatic
  # https://github.com/bcurran3/ChocolateyPackages/issues/48
  Set-ScheduledTask -TaskName choco-cleaner -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable)

  # https://github.com/chocolatey/choco/issues/797#issuecomment-1515603050
  choco feature enable -n=useRememberedArgumentsForUpgrades -n=removePackageInformationOnUninstall

  # https://github.com/microsoft/terminal/issues/2933 https://github.com/microsoft/terminal/issues/14730
  # https://github.com/microsoft/terminal/issues/17455
  Remove-Item -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
  New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $HOME\git\dotfiles_windows\dotfiles\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

  # Linking dotfiles
  dploy stow $($args[0])\dotfiles $HOME

  # https://gitlab.torproject.org/tpo/core/tor/-/issues/17145
  New-Service -Name "tor" -BinaryPathName '"C:\ProgramData\chocolatey\lib\tor\tools\Tor\tor.exe --nt-service -f $HOME\git\dotfiles_windows\torrc"'
  # https://serverfault.com/a/983832 https://github.com/PowerShell/PowerShell/issues/21400
  sc failure tor reset=30 actions=restart/5000

  # Task for enabling language change by pressing right ctrl
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe lswitch) -Argument "163") -TaskName "switch language with right ctrl" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)) -Trigger (New-ScheduledTaskTrigger -AtLogon)
  Start-ScheduledTask -TaskName "switch language with right ctrl"

  # Tasks for starting and stopping lycheefix
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -c lycheefixon") -TaskName "Start lycheefix"
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -c lycheefixoff") -TaskName "Stop lycheefix"

  # Task for restarting Taiga every day until https://github.com/erengy/taiga/issues/1120 and https://github.com/erengy/taiga/issues/1161 is fixed
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -File $HOME\git\dotfiles_windows\scripts\restart-taiga.ps1") -TaskName "Restart Taiga every day" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00)

  # Task for restarting qBittorrent every day until https://github.com/qbittorrent/qBittorrent/issues/20305 is fixed
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -File $HOME\git\dotfiles_windows\scripts\restart-qbittorrent.ps1") -TaskName "Restart qBittorrent every day" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00), (New-ScheduledTaskTrigger -Daily -At 16:00)

  # Night Light is usually not turned off automatically in the morning https://aka.ms/AAqoje8
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -c night-light -l switch --off") -TaskName "Turning off the night light in the morning" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 08:00)

  # Start plex-mpv-shim at logon
  # https://github.com/iwalton3/plex-mpv-shim/issues/118
  #Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -c Start-Sleep -Seconds 120 && Start-Process -FilePath $HOME\scoop\apps\plex-mpv-shim\current\run.exe -WorkingDirectory $HOME\scoop\apps\plex-mpv-shim\current") -TaskName "plex-mpv-shim" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)) -Trigger (New-ScheduledTaskTrigger -AtLogon)

  # Start Plex For Windows at logon
  # https://forums.plex.tv/t/add-autostart-on-logon-option-to-plex-for-windows/880558
  #Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:ProgramFiles\Plex\Plex\Plex.exe" -WorkingDirectory "$env:ProgramFiles\Plex\Plex") -TaskName "Plex For Windows" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable) -Trigger (New-ScheduledTaskTrigger -AtLogon)

  # Backup task
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe" -Argument "-WindowStyle Minimized $HOME\git\dotfiles_windows\scripts\backup-script.ps1") -TaskName "Backup everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -At 13:00 -DaysOfWeek 3)

  # Upgrade everything with topgrade task
  # Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe" -Argument "-WindowStyle Hidden -c upgradeall") -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 12:00)
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe" -Argument "-WindowStyle Minimized $HOME\git\dotfiles_windows\scripts\upgrade-all.ps1") -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 12:00)

  # https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsLogon::DisableStartupSound https://aka.ms/AAns3as
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableStartupSound /t REG_DWORD /d 1 /f
  # Disable slide-away lock screen, https://superuser.com/a/1659652/1506333 https://aka.ms/AAnrbky https://aka.ms/AAnrixl
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f
  # https://www.elevenforum.com/t/change-automatic-maintenance-time-in-windows-11.16687/
  #reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "Activation Boundary" /t REG_SZ /d "2001-01-01T08:00:00" /f
  # https://github.com/winfsp/sshfs-win/issues/194#issuecomment-632281505
  reg add "HKLM\SOFTWARE\WOW6432Node\WinFsp\Services\sshfs" /v Recovery /t REG_DWORD /d 1 /f

  # Register mpv-git associations
  cmd /c $HOME\scoop\apps\mpv-git\current\installer\mpv-install.bat

  # https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428 https://support.xbox.com/en-US/help/friends-social-activity/share-socialize/xbox-game-bar-performance https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers https://aka.ms/AAh2b88 https://aka.ms/AAh23gr https://aka.ms/AAnrbkw
  Add-LocalGroupMember -Group ((New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-559")).Translate([System.Security.Principal.NTAccount]).Value.Replace("BUILTIN\", "")) -Member $env:USERNAME

  # I don't need this file types scanned
  Add-MpPreference -ExclusionExtension ".vhd", ".vhdx", ".vdi", ".vmdk"

  # I need local manifests
  winget settings --enable LocalManifestFiles

  # https://stackoverflow.com/a/67123362
  # https://learn.microsoft.com/en-us/answers/questions/794854/run-a-program-every-time-the-computer-comes-out-of

  # Define the trigger for the event ID 1 from the Power-Troubleshooter source
  # $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date)
  # $trigger | Add-Member -MemberType NoteProperty -Name 'Subscription' -Value '<QueryList><Query Id="0" Path="System"><Select Path="System">*[System[Provider[@Name=''Power-Troubleshooter''] and EventID=1]]</Select></Query></QueryList>'

  # Create list of triggers, including AtLogOn and custom event trigger
  $triggers = @()
  $triggers += New-ScheduledTaskTrigger -AtLogOn

  # Define custom event trigger
  $subscription = @"
<QueryList><Query Id="0" Path="System"><Select Path="System">*[System[Provider[@Name='Microsoft-Windows-Power-Troubleshooter'] and EventID=1]]</Select></Query></QueryList>
"@

  # Register the custom event trigger using CIM
  $CIMTriggerClass = Get-CimClass -ClassName MSFT_TaskEventTrigger -Namespace Root/Microsoft/Windows/TaskScheduler
  $trigger = New-CimInstance -CimClass $CIMTriggerClass -ClientOnly
  $trigger.Subscription = $subscription
  $trigger.Enabled = $true
  $triggers += $trigger

  # Register the scheduled task
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe $HOME\git\dotfiles_windows\scripts\restart-plex-player-and-shim.ps1") -TaskName "Restarting plex for windows and plex-mpv-shim" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable) -Trigger $triggers -Force
} -args "$PSScriptRoot"

# Cleanup
sudo {
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
    "Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe"
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
pipx install internetarchive tubeup guessit subliminal "git+https://github.com/arecarn/dploy.git" "git+https://github.com/iamkroot/trakt-scrobbler.git"
# https://github.com/guessit-io/guessit/issues/766
pipx inject guessit setuptools

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name posh-git, PSAdvancedShortcut
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
firefox -CreateProfile letyshops
firefox -CreateProfile alwaysonproxy

# https://www.elevenforum.com/t/turn-on-or-off-enhance-pointer-precision-in-windows-11.7327/
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f

# Shortcuts https://github.com/microsoft/winget-cli/issues/3314
Import-Module -Name $documentsPath\PowerShell\Modules\PSAdvancedShortcut
Invoke-WebRequest -Uri "https://icon-icons.com/downloadimage.php?id=152991&root=2552/ICO/48/&file=firefox_browser_logo_icon_152991.ico" -OutFile "$HOME\firefox.ico"
New-Shortcut -Name 'Firefox - LetyShops profile' -Path $desktopPath -Target "$env:LOCALAPPDATA\Microsoft\WindowsApps\firefox.exe" -Arguments "-P letyshops" -IconPath "$HOME\firefox.ico"
New-Shortcut -Name 'Firefox - AlwaysOnProxy profile' -Path $desktopPath -Target "$env:LOCALAPPDATA\Microsoft\WindowsApps\firefox.exe" -Arguments "-P alwaysonproxy" -IconPath "$HOME\firefox.ico"
New-Shortcut -Name 'BreakTimer - disable' -Path $desktopPath -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments disable
New-Shortcut -Name 'BreakTimer - enable' -Path $desktopPath -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments enable

# Start Visual Studio Code at logon
# https://www.medo64.com/2021/09/add-application-to-auto-start-from-powershell/
# https://github.com/microsoft/vscode/issues/211583
New-ItemProperty -Path "HKCU:Software\Microsoft\Windows\CurrentVersion\Run" -Name "VSCode" -Value '"C:\Users\user\AppData\Local\Programs\Microsoft VS Code\Code.exe"'

# https://www.elevenforum.com/t/add-or-remove-edit-in-notepad-context-menu-in-windows-11.20485/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{CA6CC9F1-867A-481E-951E-A28C5E4F01EA}" /t REG_SZ /d "" /f

# Enabling classic context menu https://www.outsidethebox.ms/22361/#_842
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# WSL2 installation
wsl --install --no-launch Ubuntu-22.04

# WinSetView is used to make Windows Explorer sort by date modified (from filesystem metadata) rather than sorting by EXIF metadata (which is VERY slow even on NVMe when you have 1000+ photos or videos in folder): https://superuser.com/questions/487647/sorting-by-date-very-slow https://superuser.com/questions/238825/sort-files-by-date-modified-but-folders-always-before-files-in-windows-explorer https://superuser.com/questions/738978/how-to-prevent-windows-explorer-from-slowly-reading-file-content-to-create-metad
# https://aka.ms/AAnqwpr https://aka.ms/AAnriyc https://aka.ms/AAnr44v
winsetview.ps1 $PSScriptRoot\explorer-preset.ini

# yoink installation
# TODO: to winget
$archivePath = "$HOME/Downloads/yoink_windows_amd64.zip"
$desiredFilePath = "$HOME/yoink.exe"
$tempDir = "$HOME/Downloads/yoink/"
Invoke-WebRequest -Uri "https://github.com/MrMarble/yoink/releases/download/v0.5.0/yoink_windows_amd64.zip" -OutFile "$HOME/Downloads/yoink_windows_amd64.zip"
New-Item -ItemType Directory -Path $tempDir -Force
Expand-Archive -Path $archivePath -DestinationPath $tempDir
$extractedFilePath = Join-Path -Path $tempDir -ChildPath "yoink.exe"
Move-Item -Path $extractedFilePath -Destination $desiredFilePath
Remove-Item -Path $tempDir -Recurse -Force
