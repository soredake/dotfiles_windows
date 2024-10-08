# Virtual Machine check
if ((Get-CimInstance -ClassName CIM_ComputerSystem).Model -match "Virtual|VMware") { $env:vm = 1 }

# Documents and Desktop folders are moved to OneDrive
$documentsPath = [Environment]::GetFolderPath('MyDocuments')
$desktopPath = [Environment]::GetFolderPath('Desktop')

if (!$env:vm) {
  $env:currentNetworkInterfaceIndex = (Get-NetRoute | Where-Object { $_.DestinationPrefix -eq "0.0.0.0/0" -and $_.NextHop -like "192.168*" } | Get-NetAdapter).InterfaceIndex
  gsudo {
    # Set static IP https://stackoverflow.com/a/53991926
    New-NetIPAddress -InterfaceIndex $env:currentNetworkInterfaceIndex -IPAddress 192.168.0.145 -AddressFamily IPv4 -PrefixLength 24 -DefaultGateway 192.168.0.1
    Get-NetAdapter -Physical | Get-NetIPInterface -AddressFamily IPv4 | Set-DnsClientServerAddress -ServerAddresses 1.1.1.1, 1.0.0.1
  }
}

# Install powershell modules early to avoid https://github.com/badrelmers/RefrEnv/issues/9
# NOTE: https://github.com/microsoft/winget-command-not-found/issues/3
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name posh-git, PSAdvancedShortcut, PSCompletions, CompletionPredictor, Microsoft.WinGet.Client, Microsoft.WinGet.CommandNotFound

# Adding scoop buckets
'games', 'extras', 'versions', 'sysinternals', 'java', 'nirsoft', 'nonportable' | ForEach-Object { scoop bucket add $_ }
scoop bucket add naderi "https://github.com/naderi/scoop-bucket"
scoop bucket add soredake "https://github.com/soredake/scoop-bucket"

# Installing my scoop packages
# https://github.com/ScoopInstaller/Scoop/issues/5234 https://github.com/microsoft/winget-cli/issues/3240 https://github.com/microsoft/winget-cli/issues/3077 https://github.com/microsoft/winget-cli/issues/222
# Portable apps are migrated to scoop until https://github.com/microsoft/winget-cli/issues/361, https://github.com/microsoft/winget-cli/issues/2299, https://github.com/microsoft/winget-cli/issues/4044, https://github.com/microsoft/winget-cli/issues/4070 and https://github.com/microsoft/winget-pkgs/issues/500 are fixed
# https://github.com/ScoopInstaller/Scoop/issues/5234 software that cannot be moved to scoop because of firewall/defender annoyance: lychee sudachi (only multiplayer), NodeJS and syncthingtray
# https://github.com/ScoopInstaller/Scoop/issues/2035 https://github.com/ScoopInstaller/Scoop/issues/5852 software that cannot be moved to scoop because scoop cleanup cannot close running programs: syncthingtray
# NOTE: tor-browser package is broken as of 25.08.2024 https://github.com/ScoopInstaller/Extras/issues/13324
scoop install anydesk regedix jq windows11-classic-context-menu cheat-engine winsetview yt-dlp-master ffmpeg bfg psexec topgrade pipx plex-mpv-shim retroarch regscanner nosleep mpv-git sudachi proxychains process-explorer vivetool mkvtoolnix procmon nircmd autoruns goodbyedpi hatt "https://raw.githubusercontent.com/aandrew-me/ytDownloader/main/ytdownloader.json" # tor-browser
#scoop hold tor-browser

# https://github.com/arecarn/dploy/issues/8
New-Item -Path $env:APPDATA\trakt-scrobbler, $env:APPDATA\plex-mpv-shim, $HOME\scoop\apps\mpv-git\current\portable_config\scripts -ItemType Directory

# ff2mpv
git clone --depth=1 "https://github.com/woodruffw/ff2mpv" $HOME\git\ff2mpv
pwsh $HOME\git\ff2mpv\install.ps1 firefox

# Link winget settings
# Fix for winget downloading speed https://github.com/microsoft/winget-cli/issues/2124
New-Item -ItemType HardLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Target "$PSScriptRoot\winget-settings.json"

# NOTE: sudo script-blocks can take only 3008 characters https://github.com/gerardog/gsudo/issues/364

# Downloading and running Sophia Script
# https://aka.ms/AAh4e0n https://aka.ms/AAftbsj https://aka.ms/AAd9j9k https://aka.ms/AAoal1u
# https://www.outsidethebox.ms/22048/
# Suggest ways to get the most out of Windows…: WhatsNewInWindows -Disable
# Show the Windows welcome experience…: WindowsWelcomeExperience -Hide
# Get tips and suggestions when using Windows…: WindowsTips -Disable
gsudo {
  Remove-Item -Path "$HOME\Downloads\Sophia*" -Recurse -Force
  Invoke-WebRequest script.sophia.team -useb | Invoke-Expression
  ~\Downloads\Sophia*\Sophia.ps1 -Function "CreateRestorePoint", "TaskbarSearch -Hide", "ControlPanelView -LargeIcons", "FileTransferDialog -Detailed", "ShortcutsSuffix -Disable", "UnpinTaskbarShortcuts -Shortcuts Edge, Store", "DNSoverHTTPS -Enable -PrimaryDNS 1.1.1.1 -SecondaryDNS 1.0.0.1", "ThumbnailCacheRemoval -Disable", "SaveRestartableApps -Enable", "WhatsNewInWindows -Disable", "UpdateMicrosoftProducts -Enable", "InputMethod -English", "RegistryBackup -Enable"
}

# Installing software from winget
gsudo {
  # Jellyfin.Server cannot be installed silently https://github.com/jellyfin/jellyfin-server-windows/issues/109
  winget install --interactive --no-upgrade --accept-package-agreements --accept-source-agreements Jellyfin.Server

  # https://aka.ms/AAnr43h https://aka.ms/AAnr43j
  # Some monikers can't be used until https://github.com/microsoft/winget-cli/issues/3547 is fixed
  # run-hidden is needed because of this https://github.com/PowerShell/PowerShell/issues/3028
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements --exact Sandboxie.Classic yoink Mozilla.Firefox JanDeDobbeleer.OhMyPosh HumbleBundle.HumbleApp lycheeverse.lychee PragmaTwice.proxinject Playnite.Playnite Reshade.Setup.AddonsSupport IanWalton.JellyfinMPVShim specialk itch.io erengy.Taiga nomacs komac 64gram SteamGridDB.RomManager Haali.WinUtils.lswitch Python.Python.3.12 discord abbodi1406.vcredist Rem0o.FanControl epicgameslauncher wireguard Microsoft.OfficeDeploymentTool Chocolatey.Chocolatey virtualbox Ryochan7.DS4Windows AppWork.JDownloader google-drive GOG.Galaxy dupeguru wiztree Parsec.Parsec hamachi eaapp KeePassXCTeam.KeePassXC protonvpn msedgeredirect afterburner rivatuner bcuninstaller voidtools.Everything AwthWathje.SteaScree PPSSPPTeam.PPSSPP sshfs-win galaclient RamenSoftware.Windhawk qBittorrent.qBittorrent adoptopenjdk11 HermannSchinagl.LinkShellExtension Plex.Plex jellyfin-media-player ubisoft-connect volumelock plexmediaserver syncplay Cloudflare.Warp Motorola.ReadyForAssistant stax76.run-hidden Rclone.Rclone Enyium.NightLight handbrake SomePythonThings.WingetUIStore Zoom.Zoom.EXE tcmd FxSoundLLC.FxSound darkthumbs nodejs-lts 9pmz94127m4g xpfm5p5kdwf0jp 9p2b8mcsvpln 9ntxgkq8p7n0

  # This is needed to display thumbnails for videos with HEVC or cbr/cbz formats
  # https://github.com/microsoft/winget-cli/issues/2771#issuecomment-2197617810
  winget install --no-upgrade -h Xanashi.Icaros --source winget

  # SSHFS mounts is broken in >=1.13.0 https://github.com/canonical/multipass/issues/3442
  winget install --no-upgrade -h -e multipass -v "1.12.2+win"

  # PowerToys should be ran as admin to be fully functional
  winget install --no-upgrade --scope machine -h --accept-package-agreements --accept-source-agreements --exact powertoys

  # Windows 11 installer wipes Program Files directories, so I install Steam to user directory now
  winget install --no-upgrade -h -l ~\Steam Valve.Steam
}

# Refreshing PATH env
. "$HOME/refrenv.ps1"

# Add pipx bin dir to PATH
pipx ensurepath

# Refreshing PATH env
. "$HOME/refrenv.ps1"

# Installing pipx packages
pipx install autoremove-torrents internetarchive tubeup guessit subliminal "git+https://github.com/arecarn/dploy.git" "git+https://github.com/iamkroot/trakt-scrobbler.git"
# https://github.com/guessit-io/guessit/issues/766
pipx inject guessit setuptools

# Refreshing PATH env
. "$HOME/refrenv.ps1"

# Software installation
gsudo {
  # This requires UAC
  # Traditional installer is not yet created https://github.com/GerbilSoft/rom-properties/issues/108
  scoop install rom-properties-np

  # Chocolatey stuff
  # samsung-magician is outdated https://github.com/mkevenaar/chocolatey-packages/issues/237
  choco install -y syncthingtray choco-cleaner tor
  choco install -y --forcex86 aimp
  choco install -y --pin nerd-fonts-hack tor-browser
  choco install -y --pre pcsx2-dev rpcs3 --params "'/NoAdmin'"

  # Installing Microsoft Office suite
  # https://config.office.com/deploymentsettings
  # Run the script to check if Office is installed, and store the result
  $officeInstalled = & pwsh -File "$HOME\git\dotfiles_windows\scripts\check-if-office-is-installed.ps1"

  # Check if Office is not installed
  if (-not $officeInstalled) {
    # Run the Office Deployment Tool setup with the specified configuration file
    C:\Program` Files\OfficeDeploymentTool\setup.exe /configure "$($args[0])\Office-365-Config.xml"
  }

  # For storing ssh key
  # NOTE: Add-WindowsCapability is not working in pwsh msix https://github.com/PowerShell/PowerShell/issues/24283
  dism /Online /Add-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0
}

# Winget-AutoUpdate installation
# NOTE: https://github.com/Romanitho/Winget-AutoUpdate/issues/625
# TODO: change url to `latest` once msi version will be stable
Push-Location $HOME\Downloads
curl -s "https://api.github.com/repos/Romanitho/Winget-AutoUpdate/releases/tags/v1.22.5-n" | jq -r '.assets[] | select(.name | test("WAU.msi")) | .browser_download_url' | ForEach-Object { curl -L $_ -o ($_ -split '/' | Select-Object -Last 1) }
gsudo { msiexec /i WAU.msi /qb STARTMENUSHORTCUT=1 USERCONTEXT=1 NOTIFICATIONLEVEL=Full UPDATESINTERVAL=BiDaily UPDATESATTIME=11AM }
Pop-Location

# Refreshing PATH env
. "$HOME/refrenv.ps1"

# Various settings
gsudo {
  # Stop ethernet/qbittorrent from waking my pc https://superuser.com/a/1629820/1506333
  $ifIndexes = (Get-NetRoute | Where-Object -Property DestinationPrefix -EQ "0.0.0.0/0").ifIndex
  $CurrentNetworkAdapterName = (Get-NetAdapter | Where-Object { $ifIndexes -contains $_.ifIndex -and $_.Name -like "Ethernet*" } | Select-Object -ExpandProperty InterfaceDescription)
  powercfg /devicedisablewake $CurrentNetworkAdapterName

  # Start ssh-agent at boot
  Set-Service -Name ssh-agent -StartupType Automatic
  # https://github.com/bcurran3/ChocolateyPackages/issues/48
  Set-ScheduledTask -TaskName choco-cleaner -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable)

  # https://github.com/chocolatey/choco/issues/797#issuecomment-1515603050
  choco feature enable -n=useRememberedArgumentsForUpgrades -n=removePackageInformationOnUninstall

  # https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsLogon::DisableStartupSound https://aka.ms/AAns3as
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableStartupSound /t REG_DWORD /d 1 /f
  # Disable slide-away lock screen, https://superuser.com/a/1659652/1506333 https://aka.ms/AAnrbky https://aka.ms/AAnrixl
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f
  # https://github.com/winfsp/sshfs-win/issues/194#issuecomment-632281505
  reg add "HKLM\SOFTWARE\WOW6432Node\WinFsp\Services\sshfs" /v Recovery /t REG_DWORD /d 1 /f

  # Register mpv-git associations
  cmd /c "$HOME\scoop\apps\mpv-git\current\installer\mpv-install.bat /u"

  # https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428 https://support.xbox.com/en-US/help/friends-social-activity/share-socialize/xbox-game-bar-performance https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers https://aka.ms/AAh2b88 https://aka.ms/AAh23gr https://aka.ms/AAnrbkw
  Add-LocalGroupMember -Group ((New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-559")).Translate([System.Security.Principal.NTAccount]).Value.Replace("BUILTIN\", "")) -Member $env:USERNAME

  # I don't need this file types scanned
  Add-MpPreference -ExclusionExtension ".vhd", ".vhdx", ".vdi", ".vmdk"

  # I need local manifests
  winget settings --enable LocalManifestFiles

  # Once in a while I need hibernation
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v ShowHibernateOption /t REG_DWORD /d 1 /f

  # Allow in-place upgrade
  # https://github.com/InjectedPie/Windows-11-Inplace-Upgrade-unsupported-Hardware/blob/main/Windows11%20Inplace%20Upgrade%20on%20unsupported%20Hardware.reg
  reg add "HKLM\SYSTEM\Setup\MoSetup" /v AllowUpgradesWithUnsupportedTPMOrCPU /t REG_DWORD /d 1 /f
  reg add "HKCU\SOFTWARE\Microsoft\PCHC" /v UpgradeEligibility /t REG_DWORD /d 1 /f
}

# Various settings continuation
gsudo {
  # https://habr.com/ru/companies/timeweb/articles/845214/
  reg add "HKLM\SOFTWARE\Microsoft\Windows\Hotpatch\Environment" /v "AllowRebootlessUpdates" /t REG_DWORD /d 1 /f

  # Edit qbittorrent shortcut to fix https://github.com/qbittorrent/qBittorrent/issues/21423
  # https://github.com/qbittorrent/qBittorrent/issues/21423#issuecomment-2383875303
  $shortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\qBittorrent\qBittorrent.lnk"
  $WScriptShell = New-Object -ComObject WScript.Shell
  $shortcut = $WScriptShell.CreateShortcut($shortcutPath)
  $shortcut.TargetPath = $shortcut.TargetPath
  $shortcut.Arguments = "-style WindowsVista"
  $shortcut.Save()
  # And autostart entry
  reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v qBittorrent /t REG_SZ /d '"C:\Program Files\qBittorrent\qbittorrent.exe" "--profile=" "--configuration=" "--style=WindowsVista"' /f

  # Set hibernation timeout to 13 hours
  # https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/powercfg-command-line-options#change-or-x
  # NOTE: this is needed only when hypervisor boot is enabled
  #powercfg /change /hibernate-timeout-ac 780
  #powercfg /change /hibernate-timeout-dc 780
}

# Dotfiles preparations
# https://github.com/microsoft/terminal/issues/2933 https://github.com/microsoft/terminal/issues/14730 https://github.com/microsoft/terminal/issues/17455
Remove-Item -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json; New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $HOME\git\dotfiles_windows\dotfiles\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
# Linking dotfiles
gsudo {
  dploy stow $($args[0])\dotfiles $HOME
  dploy stow $($args[0])\WAU $env:ProgramFiles\Winget-AutoUpdate
} -args "$PSScriptRoot"

# Band-aid tasks
gsudo {
  # Tasks for starting and stopping lycheefix
  Unregister-ScheduledTask -TaskName "Start lycheefix" -Confirm:$false
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -c lycheefixon") -TaskName "Start lycheefix"
  Unregister-ScheduledTask -TaskName "Stop lycheefix" -Confirm:$false
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -c lycheefixoff") -TaskName "Stop lycheefix"

  # Task for restarting Taiga every day until https://github.com/erengy/taiga/issues/1120 and https://github.com/erengy/taiga/issues/1161 is fixed
  Unregister-ScheduledTask -TaskName "Restart Taiga every day" -Confirm:$false
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -File $HOME\git\dotfiles_windows\scripts\restart-taiga.ps1") -TaskName "Restart Taiga every day" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00)

  # Task for restarting qBittorrent every day until https://github.com/qbittorrent/qBittorrent/issues/20305 is fixed
  Unregister-ScheduledTask -TaskName "Restart qBittorrent every day" -Confirm:$false
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -File $HOME\git\dotfiles_windows\scripts\restart-qbittorrent.ps1") -TaskName "Restart qBittorrent every day" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00), (New-ScheduledTaskTrigger -Daily -At 16:00)

  # Night Light is usually not turned off automatically in the morning https://aka.ms/AAqoje8
  Unregister-ScheduledTask -TaskName "Turning off the night light in the morning" -Confirm:$false
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -c night-light -l switch --off") -TaskName "Turning off the night light in the morning" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 08:00)
}

# Tasks & services
gsudo {
  # https://gitlab.torproject.org/tpo/core/tor/-/issues/17145
  New-Service -Name "tor" -BinaryPathName '"C:\ProgramData\chocolatey\lib\tor\tools\Tor\tor.exe --nt-service -f $HOME\git\dotfiles_windows\torrc"'
  # https://serverfault.com/a/983832 https://github.com/PowerShell/PowerShell/issues/21400
  sc failure tor reset=30 actions=restart/5000

  # Task for enabling language change by pressing right ctrl
  Unregister-ScheduledTask -TaskName "switch language with right ctrl" -Confirm:$false
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe lswitch) -Argument "163") -TaskName "switch language with right ctrl" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)) -Trigger (New-ScheduledTaskTrigger -AtLogon)
  Start-ScheduledTask -TaskName "switch language with right ctrl"

  # Backup task
  Unregister-ScheduledTask -TaskName "Backup everything" -Confirm:$false
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe" -Argument "-WindowStyle Minimized $HOME\git\dotfiles_windows\scripts\backup-script.ps1") -TaskName "Backup everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00 -DaysInterval 3)

  # Upgrade everything with topgrade task
  Unregister-ScheduledTask -TaskName "Upgrade everything" -Confirm:$false
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe" -Argument "-WindowStyle Minimized $HOME\git\dotfiles_windows\scripts\upgrade-all.ps1") -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 12:00)

  # Start plex-mpv-shim at logon
  # https://github.com/iwalton3/plex-mpv-shim/issues/118
  Unregister-ScheduledTask -TaskName "plex-mpv-shim" -Confirm:$false
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$HOME\scoop\apps\plex-mpv-shim\current\run.exe" -WorkingDirectory "$HOME\scoop\apps\plex-mpv-shim\current") -TaskName "plex-mpv-shim" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)) -Trigger (New-ScheduledTaskTrigger -AtLogon)
}

# Task for cleaning Downloads folder
gsudo {
  # Storage Sense cannot clear Downloads folder as windows defender is modifying last access date when scanning it
  # https://www.reddit.com/r/WindowsHelp/comments/vnt53e/storage_sense_does_not_delete_files_in_my/ https://answers.microsoft.com/en-us/windows/forum/all/storage-sense-does-not-delete-files-in-my/50ee4069-3e67-4379-9e65-e7274f30e104 https://aka.ms/AAral56
  Unregister-ScheduledTask -TaskName "Clear downloads folder" -Confirm:$false
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe -File $HOME\git\dotfiles_windows\scripts\clear-downloads-folder.ps1") -TaskName "Clear downloads folder" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 08:00)
}

# Cleanup
# https://www.elevenforum.com/t/add-or-remove-edit-in-notepad-context-menu-in-windows-11.20485/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{CA6CC9F1-867A-481E-951E-A28C5E4F01EA}" /t REG_SZ /d "" /f
gsudo {
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
    winget uninstall --accept-source-agreements -h $package
  }
}

# https://github.com/tom-james-watson/breaktimer-app/issues/185
winget install --no-upgrade -h -e --id TomWatson.BreakTimer -v 1.1.0

# https://github.com/microsoft/winget-pkgs/issues/106091 https://github.com/microsoft/vscode/issues/198519
winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements vscode --custom "/mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'"

# Refreshing PATH env
. "$HOME/refrenv.ps1"

npm install --global html-validate gulp-cli create-react-app webtorrent-mpv-hook
# "https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/lua/autoload.lua" is no longer needed after https://github.com/mpv-player/mpv/pull/14555
curl -L --create-dirs --remote-name-all --output-dir $HOME\scoop\apps\mpv-git\current\portable_config\scripts "https://github.com/ekisu/mpv-webm/releases/download/latest/webm.lua" "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/zenwarr/mpv-config/master/scripts/russian-layout-bindings.lua" "https://github.com/CogentRedTester/mpv-sub-select/raw/master/sub-select.lua" "https://raw.githubusercontent.com/d87/mpv-persist-properties/master/persist-properties.lua" "https://github.com/mpv-player/mpv/raw/master/TOOLS/lua/acompressor.lua" "https://github.com/4e6/mpv-reload/raw/master/reload.lua"

# Change script keybind
(Get-Content "$HOME\scoop\apps\mpv-git\current\portable_config\scripts\reload.lua") -replace 'reload_key_binding\s*=\s*"Ctrl\+r"', 'reload_key_binding = "Ctrl+k"' | Set-Content "$HOME\scoop\apps\mpv-git\current\portable_config\scripts\reload.lua"

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
  gsudo multipass set local.driver=virtualbox
  multipass set local.privileged-mounts=yes
  multipass set client.gui.autostart=no
  # TODO: check if it will use 24.04 image by default https://multipass.run/docs/create-an-instance
  multipass launch --name primary -c 4 -m 4G --mount E:\:/mnt/e_host --mount F:\:/mnt/d_host --mount C:\:/mnt/c_host
  multipass exec primary bash /mnt/c_host/Users/$env:USERNAME/git/dotfiles_windows/wsl.sh
  multipass stop
}

# Misc
mkdir $HOME\torrents
trakts autostart enable
firefox -CreateProfile letyshops
firefox -CreateProfile alwaysonproxy

# This optimization takes some time to complete, so it makes sense to enable it at the end
scoop config use_sqlite_cache true

# https://www.elevenforum.com/t/turn-on-or-off-enhance-pointer-precision-in-windows-11.7327/
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f

# Task for cleaning torrents
# https://github.com/jerrymakesjelly/autoremove-torrents
Unregister-ScheduledTask -TaskName "Torrents cleanup" -Confirm:$false
Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME") -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\pwsh.exe" -Argument "-WindowStyle Minimized -c autoremove-torrents --conf=$HOME\Мой`` диск\документы\autoremove-torrents.yaml --log=$HOME\Downloads") -TaskName "Torrents cleanup" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 12:00)

# Shortcuts https://github.com/microsoft/winget-cli/issues/3314
Import-Module -Name $documentsPath\PowerShell\Modules\PSAdvancedShortcut
Invoke-WebRequest -Uri "https://icon-icons.com/downloadimage.php?id=152991&root=2552/ICO/48/&file=firefox_browser_logo_icon_152991.ico" -OutFile "$HOME\firefox.ico"
New-Shortcut -Name 'Firefox - LetyShops profile' -Path $desktopPath -Target "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -Arguments "-P letyshops" -IconPath "$HOME\firefox.ico"
New-Shortcut -Name 'Firefox - AlwaysOnProxy profile' -Path $desktopPath -Target "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -Arguments "-P alwaysonproxy" -IconPath "$HOME\firefox.ico"
New-Shortcut -Name 'BreakTimer - disable' -Path $desktopPath -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments disable
New-Shortcut -Name 'BreakTimer - enable' -Path $desktopPath -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments enable

# Start Visual Studio Code at logon
# https://www.medo64.com/2021/09/add-application-to-auto-start-from-powershell/
# https://github.com/microsoft/vscode/issues/211583
New-ItemProperty -Path "HKCU:Software\Microsoft\Windows\CurrentVersion\Run" -Name "VSCode" -Value '"C:\Users\user\AppData\Local\Programs\Microsoft VS Code\Code.exe"'

# Enabling classic context menu https://www.outsidethebox.ms/22361/#_842
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# Just because I can do this
#New-Item -Path "$desktopPath\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" -ItemType Directory
git clone "https://github.com/ThioJoe/Windows-Super-God-Mode" $HOME\git\Windows-Super-God-Mode
Push-Location $HOME\git\Windows-Super-God-Mode
pwsh .\Super_God_Mode.ps1 -NoGUI

# Enable Hyper-V, hypervisor platform and VMP but disable hypervisor boot
gsudo {
  dism /Online /Enable-Feature /FeatureName:VirtualMachinePlatform /All /NoRestart
  dism /Online /Enable-Feature /FeatureName:Microsoft-Hyper-V /All /NoRestart
  # HypervisorPlatform is needed for VMware Workstation
  dism /Online /Enable-Feature /FeatureName:HypervisorPlatform /All /NoRestart
  # https://stackoverflow.com/a/35812945
  # Disabling hypervisor boot by default
  bcdedit /set hypervisorlaunchtype off
}

# WSL2 installation
# https://github.com/microsoft/WSL/issues/10386#issuecomment-2268703768
wsl --install --no-launch -d Ubuntu-24.04
ubuntu2404 install --root
wsl -d Ubuntu-24.04 --user root -- /bin/bash $PSScriptRoot/wsl-create-user.sh
# https://superuser.com/questions/1566022/how-to-set-default-user-for-manually-installed-wsl-distro
ubuntu2404 config --default-user ubuntu
wsl -d Ubuntu-24.04 --user ubuntu -- /bin/bash $PSScriptRoot/wsl.sh
# Update WSL2 to latest pre-release
gsudo { wsl --update --pre-release }

# PSCompletions setup
psc config enable_completions_update 0
psc config enable_module_update 0
psc add npm winget scoop

# WinSetView is used to make Windows Explorer sort by date modified (from filesystem metadata) rather than sorting by EXIF metadata (which is VERY slow even on NVMe when you have 1000+ photos or videos in folder): https://superuser.com/questions/487647/sorting-by-date-very-slow https://superuser.com/questions/238825/sort-files-by-date-modified-but-folders-always-before-files-in-windows-explorer https://superuser.com/questions/738978/how-to-prevent-windows-explorer-from-slowly-reading-file-content-to-create-metad
# https://aka.ms/AAnqwpr https://aka.ms/AAnriyc https://aka.ms/AAnr44v
winsetview.ps1 $PSScriptRoot\explorer-preset.ini
