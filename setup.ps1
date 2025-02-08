# Virtual Machine check
if ((Get-CimInstance -ClassName CIM_ComputerSystem).Model -match "Virtual|VMware") { $env:vm = 1 }

# Documents and Desktop folders are moved to OneDrive
# https://learn.microsoft.com/en-us/dotnet/api/system.environment.specialfolder?view=net-9.0
$musicPath = [Environment]::GetFolderPath('MyMusic')
$documentsPath = [Environment]::GetFolderPath('MyDocuments')
$startMenuPath = [Environment]::GetFolderPath('StartMenu')

if (!$env:vm) {
  $env:currentNetworkInterfaceIndex = (Get-NetRoute | Where-Object { $_.DestinationPrefix -eq "0.0.0.0/0" -and $_.NextHop -like "192.168*" } | Get-NetAdapter).InterfaceIndex
  gsudo {
    # Set static IP https://stackoverflow.com/a/53991926
    New-NetIPAddress -InterfaceIndex $env:currentNetworkInterfaceIndex -IPAddress 192.168.0.145 -AddressFamily IPv4 -PrefixLength 24 -DefaultGateway 192.168.0.1
    Get-NetAdapter -Physical | Get-NetIPInterface -AddressFamily IPv4 | Set-DnsClientServerAddress -ServerAddresses 8.8.8.8, 8.8.4.4
  }
}

# Install powershell modules early to avoid https://github.com/badrelmers/RefrEnv/issues/9
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name posh-git, PSAdvancedShortcut

# Adding scoop buckets
'extras' | ForEach-Object { scoop bucket add $_ }
scoop bucket add soredake "https://github.com/soredake/scoop-bucket"
scoop bucket add holes "https://github.com/instinctualjealousy/holes"

# Installing my scoop packages
# https://github.com/ScoopInstaller/Scoop/issues/2035 https://github.com/ScoopInstaller/Scoop/issues/5852 software that cannot be moved to scoop because scoop cleanup cannot close running programs: syncthingtray
# NOTE: tor-browser package is broken as of 25.08.2024 https://github.com/ScoopInstaller/Extras/issues/13324
# TODO: move topgrade to winget once https://github.com/topgrade-rs/topgrade/issues/958 is fixed
scoop install topgrade pipx nosleep onthespot persistent-windows # tor-browser
#scoop hold tor-browser

# https://github.com/arecarn/dploy/issues/8
New-Item -Path $env:APPDATA\trakt-scrobbler, $env:LOCALAPPDATA\Plex\scripts, $env:APPDATA\mpv\scripts -ItemType Directory -Force | Out-Null

# ff2mpv
git clone --depth=1 "https://github.com/woodruffw/ff2mpv" $HOME\git\ff2mpv
pwsh $HOME\git\ff2mpv\install.ps1 firefox

# winget settings
gsudo {
  # Link winget settings to fix download speed https://github.com/microsoft/winget-cli/issues/2124
  New-Item -ItemType HardLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Target "$($args[0])\winget-settings.json"

  # Developer Mode is needed to create symlinks in winget without admin rights, adding to PATH approach have problems https://github.com/microsoft/winget-cli/issues/4044 https://github.com/microsoft/winget-cli/issues/3601 https://github.com/microsoft/winget-cli/issues/361
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
} -args "$PSScriptRoot"

# NOTE: sudo script-blocks can take only 3008 characters https://github.com/gerardog/gsudo/issues/364

# Downloading and running Sophia Script
# NOTE: "NetworkAdaptersSavePower -Disable" is workaround for https://github.com/qbittorrent/qBittorrent/issues/21709
Remove-Item -Path "$HOME\Downloads\Sophia*" -Recurse -Force
iwr script.sophia.team -useb | iex
gsudo {
  ~\Downloads\Sophia*\Sophia.ps1 -Function "DNSoverHTTPS -Enable -PrimaryDNS 8.8.8.8 -SecondaryDNS 8.8.4.4", "TempTask -Register", "EditWithClipchampContext -Hide", "NetworkAdaptersSavePower -Disable"
}

# Installing software
gsudo {
  # Some monikers can't be used until https://github.com/microsoft/winget-cli/issues/3547 is fixed
  # run-hidden is needed because of this https://github.com/PowerShell/PowerShell/issues/3028
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements WingetPathUpdater
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements --exact Sandboxie.Classic Mozilla.Firefox JanDeDobbeleer.OhMyPosh lycheeverse.lychee itch.io erengy.Taiga nomacs komac 64gram Haali.WinUtils.lswitch Python.Python.3.12 discord Rem0o.FanControl epicgameslauncher wireguard Chocolatey.Chocolatey Valve.Steam Ryochan7.DS4Windows AppWork.JDownloader google-drive GOG.Galaxy dupeguru wiztree hamachi eaapp KeePassXCTeam.KeePassXC protonvpn msedgeredirect afterburner rivatuner bcuninstaller voidtools.Everything sshfs-win RamenSoftware.Windhawk qBittorrent.qBittorrent adoptopenjdk11 HermannSchinagl.LinkShellExtension Plex.Plex ubisoft-connect volumelock plexmediaserver syncplay Motorola.ReadyForAssistant stax76.run-hidden Rclone.Rclone SomePythonThings.WingetUIStore nodejs-lts LesFerch.WinSetView Oracle.VirtualBox yt-dlp.yt-dlp.nightly advaith.CurrencyConverterPowerToys Microsoft.Sysinternals.PsTools Google.PlatformTools 9pfz3g4d1c9r 9pmz94127m4g xpfm5p5kdwf0jp 9p2b8mcsvpln
  winget install --no-upgrade --scope machine -h --accept-package-agreements --accept-source-agreements --exact powertoys

  # This is needed to display thumbnails for HEVC videos
  # https://github.com/microsoft/winget-cli/issues/2771#issuecomment-2197617810
  winget install --no-upgrade -h Xanashi.Icaros --source winget

  # SSHFS mounts is broken in >=1.13.0 https://github.com/canonical/multipass/issues/3442 https://github.com/canonical/multipass/issues/104
  winget install --no-upgrade -h -e multipass -v "1.12.2+win"

  # Winget-AutoUpdate installation
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements Romanitho.Winget-AutoUpdate --override "/qb STARTMENUSHORTCUT=1 USERCONTEXT=1 NOTIFICATIONLEVEL=None UPDATESINTERVAL=BiDaily UPDATESATTIME=11AM"

  # Add pipx bin dir to PATH
  pipx ensurepath

  # Refreshing PATH env
  . "$HOME/refrenv.ps1"

  # Installing pipx packages
  pipx install autoremove-torrents internetarchive "git+https://github.com/arecarn/dploy.git" "git+https://github.com/iamkroot/trakt-scrobbler.git"

  # Chocolatey stuff
  choco install -y syncthingtray choco-cleaner aimp mpvio.install
  choco install -y --pin nerd-fonts-hack tor-browser

  # For storing ssh key
  dism /Online /Add-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0
  # Hypervisor Platform is needed for VMware Workstation
  dism /Online /Enable-Feature /FeatureName:HypervisorPlatform /All /NoRestart
}

# Refreshing PATH env
. "$HOME/refrenv.ps1"

# Various settings
gsudo {
  # Disable slide-away lock screen, https://superuser.com/a/1659652/1506333
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d 1 /f
  # https://github.com/winfsp/sshfs-win/issues/194#issuecomment-632281505
  reg add "HKLM\SOFTWARE\WOW6432Node\WinFsp\Services\sshfs" /v "Recovery" /t REG_DWORD /d 1 /f

  # https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428 https://support.xbox.com/en-US/help/friends-social-activity/share-socialize/xbox-game-bar-performance https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers https://aka.ms/AAh2b88 https://aka.ms/AAh23gr https://aka.ms/AAnrbkw
  Add-LocalGroupMember -Group ((New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-559")).Translate([System.Security.Principal.NTAccount]).Value.Replace("BUILTIN\", "")) -Member $env:USERNAME

  # winget settings https://github.com/microsoft/winget-cli/blob/master/schemas/JSON/settings/settings.export.schema.0.1.json
  winget settings --enable LocalManifestFiles
  winget settings --enable InstallerHashOverride
  winget settings --enable ProxyCommandLineOptions

  # Disable hypervisor boot
  # https://stackoverflow.com/a/35812945
  bcdedit /set hypervisorlaunchtype off

  # toprgrade uses `sudo` alias to run choco upgrade
  # https://www.elevenforum.com/t/enable-or-disable-sudo-command-in-windows-11.22329/
  # TODO: don't require sudo when topgrade is run as admin https://github.com/topgrade-rs/topgrade/blob/224bb96a98b06f1000106f511012c12963f2e115/src/steps/os/windows.rs#L22-L28 https://github.com/topgrade-rs/topgrade/issues/1025
  # https://gerardog.github.io/gsudo/docs/gsudo-vs-sudo#what-if-i-install-both
  sudo config --enable normal
}

# Dotfiles preparations
# https://github.com/microsoft/terminal/issues/2933 https://github.com/microsoft/terminal/issues/14730 https://github.com/microsoft/terminal/issues/17455
Remove-Item -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json; New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $HOME\git\dotfiles_windows\dotfiles\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
# Linking dotfiles
gsudo {
  # Plex
  Remove-Item -Path $env:LOCALAPPDATA\Plex\mpv.conf
  # OneDrive cannot backup symlinks
  New-Item -ItemType HardLink -Path "$documentsPath\PowerShell\Profile.ps1" -Target "$($args[0])\Profile.ps1"
  dploy stow $($args[0])\dotfiles $HOME
  dploy stow $($args[0])\WAU $env:ProgramFiles\Winget-AutoUpdate
} -args "$PSScriptRoot"

# Band-aid tasks
gsudo {
  # Storage Sense cannot clear Downloads folder as windows defender is modifying last access date when scanning it
  # https://www.reddit.com/r/WindowsHelp/comments/vnt53e/storage_sense_does_not_delete_files_in_my/ https://answers.microsoft.com/en-us/windows/forum/all/storage-sense-does-not-delete-files-in-my/50ee4069-3e67-4379-9e65-e7274f30e104 https://aka.ms/AAral56
  #Unregister-ScheduledTask -TaskName "Clear downloads folder" -Confirm:$false
  #Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:ProgramFiles\PowerShell\7\pwsh.exe -File $HOME\git\dotfiles_windows\scripts\clear-downloads-folder.ps1") -TaskName "Clear downloads folder" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 08:00)
}

# Tasks & services
gsudo {
  # Workaround for https://github.com/erengy/taiga/issues/1120 and https://github.com/erengy/taiga/issues/1161
  Unregister-ScheduledTask -TaskName "Restart Taiga every day" -Confirm:$false
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:ProgramFiles\PowerShell\7\pwsh.exe -File $HOME\git\dotfiles_windows\scripts\restart-taiga.ps1") -TaskName "Restart Taiga every day" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00)

  # Task for enabling language change by pressing right ctrl
  Unregister-ScheduledTask -TaskName "switch language with right ctrl" -Confirm:$false
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe lswitch) -Argument "163") -TaskName "switch language with right ctrl" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)) -Trigger (New-ScheduledTaskTrigger -AtLogon)
  Start-ScheduledTask -TaskName "switch language with right ctrl"

  # Backup task
  Unregister-ScheduledTask -TaskName "Backup everything" -Confirm:$false
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$env:ProgramFiles\PowerShell\7\pwsh.exe" -Argument "-NoProfile -WindowStyle Minimized $HOME\git\dotfiles_windows\scripts\backup-script.ps1") -TaskName "Backup everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00 -DaysInterval 3)

  # Upgrade everything with topgrade task
  Unregister-ScheduledTask -TaskName "Upgrade everything" -Confirm:$false
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$env:ProgramFiles\PowerShell\7\pwsh.exe" -Argument "-WindowStyle Minimized $HOME\git\dotfiles_windows\scripts\upgrade-all.ps1") -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 12:00)

  # Run `Temp` task every week, https://github.com/M2Team/NanaZip/issues/297
  Set-ScheduledTask -TaskName "Sophia\Temp" -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 9:00AM)

  # Start ssh-agent at boot
  Set-Service -Name ssh-agent -StartupType Automatic

  # Run task if scheduled run time is missed
  Set-ScheduledTask -TaskName choco-cleaner -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable)

  # https://github.com/kangyu-california/PersistentWindows
  ~\scoop\apps\persistent-windows\current\auto_start_pw_aux.ps1
}

# Tasks & services continuation
gsudo {
  # Task for cleaning torrents
  # https://github.com/jerrymakesjelly/autoremove-torrents
  Unregister-ScheduledTask -TaskName "Torrents cleanup" -Confirm:$false
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:ProgramFiles\PowerShell\7\pwsh.exe" -Argument "-NoProfile -WindowStyle Minimized -c autoremove-torrents --conf=$HOME\Мой`` диск\документы\configs\autoremove-torrents.yaml --log=$HOME\Downloads") -TaskName "Torrents cleanup" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 12:00)
}

# Cleanup
# https://www.elevenforum.com/t/add-or-remove-edit-in-notepad-context-menu-in-windows-11.20485/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{CA6CC9F1-867A-481E-951E-A28C5E4F01EA}" /t REG_SZ /d "" /f

# https://github.com/tom-james-watson/breaktimer-app/issues/185
winget install --no-upgrade -h -e --id TomWatson.BreakTimer -v 1.1.0

# https://github.com/microsoft/winget-pkgs/issues/106091
winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements vscode --custom "/mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'"

# Refreshing PATH env
. "$HOME/refrenv.ps1"

npm install --global webtorrent-mpv-hook inshellisense
# mpv plugins installation
curl -L --create-dirs --remote-name-all --output-dir $env:APPDATA\mpv\scripts "https://github.com/ekisu/mpv-webm/releases/download/latest/webm.lua" "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/zenwarr/mpv-config/master/scripts/russian-layout-bindings.lua" "https://github.com/CogentRedTester/mpv-sub-select/raw/master/sub-select.lua" "https://raw.githubusercontent.com/d87/mpv-persist-properties/master/persist-properties.lua" "https://github.com/mpv-player/mpv/raw/master/TOOLS/lua/acompressor.lua" "https://github.com/4e6/mpv-reload/raw/master/reload.lua"
curl -L "https://github.com/tsl0922/mpv-menu-plugin/releases/download/2.4.1/menu.zip" -o "$HOME\Downloads\mpv-menu-plugin.zip"
7z e "$HOME\Downloads\mpv-menu-plugin.zip" -o"$env:APPDATA\mpv\scripts" -y
# https://github.com/mrxdst/webtorrent-mpv-hook
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\mpv\scripts\webtorrent.js" -Target "$env:APPDATA\npm\node_modules\webtorrent-mpv-hook\build\webtorrent.js"

# Change script keybind
(Get-Content "$env:APPDATA\mpv\scripts\reload.lua") -replace 'reload_key_binding\s*=\s*"Ctrl\+r"', 'reload_key_binding = "Ctrl+k"' | Set-Content "$env:APPDATA\mpv\scripts\reload.lua"

# https://github.com/CogentRedTester/mpv-sub-select/issues/30
(Get-Content "$env:APPDATA\mpv\scripts\sub-select.lua") -replace 'force_prediction = false', 'force_prediction = true' | Set-Content "$env:APPDATA\mpv\scripts\sub-select.lua"

# Multipass setup
if (!$env:vm) {
  $env:ESSD = (Get-Volume -FileSystemLabel "ExternalSSDVentoy 256gb").DriveLetter
  gsudo multipass set local.driver=virtualbox
  multipass set local.privileged-mounts=yes
  multipass set client.gui.autostart=no
  multipass launch --name primary -c 4 -m 4G --mount ${env:ESSD}:\:/mnt/e_host --mount C:\:/mnt/c_host
  multipass exec primary bash /mnt/c_host/Users/$env:USERNAME/git/dotfiles_windows/wsl.sh
  multipass stop
}

# Misc
trakts autostart enable
firefox -CreateProfile letyshops
firefox -CreateProfile alwaysonproxy

# TODO: fill the issue, onespot should use path to music (in case folder is relocated to onedrive) from env, not hardcode ~/music
New-Item -ItemType Junction -Path "$HOME\Music" -Target $musicPath

# Shortcuts
Import-Module -Name $documentsPath\PowerShell\Modules\PSAdvancedShortcut
New-Shortcut -Name 'Firefox - LetyShops profile' -Path $startMenuPath -Target "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -Arguments "-P letyshops"
New-Shortcut -Name 'Firefox - AlwaysOnProxy profile' -Path $startMenuPath -Target "$env:ProgramFiles\Mozilla Firefox\firefox.exe" -Arguments "-P alwaysonproxy"

# Start Visual Studio Code at logon
# https://www.medo64.com/2021/09/add-application-to-auto-start-from-powershell/
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "VSCode" /d "`"$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe`"" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Everything" /d "`"$env:ProgramFiles\Everything\Everything.exe`"" /f

# Restoring classic context menu https://www.outsidethebox.ms/22361/#_842
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

# WSL2 installation
wsl --install --no-launch -d Ubuntu-24.04
# Update WSL2 to latest pre-release
gsudo { wsl --update --pre-release }

# https://github.com/SpotX-Official/SpotX
iex "& { $(iwr -useb 'https://spotx-official.github.io/run.ps1') } -sp-over -sp-uninstall -confirm_uninstall_ms_spoti -new_theme -topsearchbar -canvasHome -podcasts_on -block_update_on -lyrics_stat spotify -cache_limit 5000"

# https://remontka.pro/wake-timers-windows/
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0

# WinSetView is used to make Windows Explorer sort by date modified (from filesystem metadata) rather than sorting by EXIF metadata (which is VERY slow even on NVMe when you have 1000+ photos or videos in folder): https://superuser.com/questions/487647/sorting-by-date-very-slow https://superuser.com/questions/238825/sort-files-by-date-modified-but-folders-always-before-files-in-windows-explorer https://superuser.com/questions/738978/how-to-prevent-windows-explorer-from-slowly-reading-file-content-to-create-metad
# https://aka.ms/AAnqwpr https://aka.ms/AAnriyc https://aka.ms/AAnr44v
C:\Program` Files` `(x86`)\WinSetView\WinSetView.ps1 $PSScriptRoot\explorer-preset.ini
