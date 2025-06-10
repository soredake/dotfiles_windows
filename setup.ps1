# Install powershell modules early to avoid https://github.com/badrelmers/RefrEnv/issues/9
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name posh-git

# Adding scoop buckets
'extras', 'nirsoft' | % { scoop bucket add $_ }

# Running Sophia Script
gsudo powershell {
  . $env:LOCALAPPDATA\Microsoft\WinGet\Packages\*SophiaScript*\*\Import-TabCompletion.ps1
  Sophia -Functions "DNSoverHTTPS -Enable -PrimaryDNS 8.8.8.8 -SecondaryDNS 8.8.4.4", "TempTask -Register"
}

# Installing my scoop packages
# https://github.com/ScoopInstaller/Scoop/issues/2035 https://github.com/ScoopInstaller/Scoop/issues/5852 software that cannot be moved to scoop because scoop cleanup cannot close running programs: syncthingtray
# NOTE: move tor-browser to winget once https://gitlab.torproject.org/tpo/applications/tor-browser-build/-/issues/41138 is fixed
scoop install topgrade onthespot nircmd

# https://github.com/arecarn/dploy/issues/8
New-Item -Path $env:APPDATA\trakt-scrobbler, $env:APPDATA\mpv\scripts -ItemType Directory -Force | Out-Null

# winget settings
gsudo {
  # Link winget settings to fix download speed https://github.com/microsoft/winget-cli/issues/2124
  New-Item -ItemType HardLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Target "$($args[0])\winget-settings.json"
} -args "$PSScriptRoot"

# NOTE: sudo script-blocks can take only 3008 characters https://github.com/gerardog/gsudo/issues/364

# Installing software
gsudo {
  # run-hidden/nircmd is needed because of this https://github.com/PowerShell/PowerShell/issues/3028
  # https://github.com/microsoft/winget-cli/issues/549
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements WingetPathUpdater
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements --exact powertoys --scope machine
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements --exact Telegram.TelegramDesktop UnifiedIntents.UnifiedRemote astral-sh.uv w4po.ExplorerTabUtility sandboxie-classic Mozilla.Firefox JanDeDobbeleer.OhMyPosh lycheeverse.lychee itch.io erengy.Taiga nomacs komac lswitch python3.12 Rem0o.FanControl epicgameslauncher wireguard Chocolatey.Chocolatey Valve.Steam Ryochan7.DS4Windows AppWork.JDownloader google-drive GOG.Galaxy dupeguru wiztree hamachi eaapp protonvpn msedgeredirect afterburner rivatuner bcuninstaller voidtools.Everything.Alpha RamenSoftware.Windhawk qBittorrent.qBittorrent HermannSchinagl.LinkShellExtension Plex.Plex volumelock plexmediaserver Syncplay.Syncplay stax76.run-hidden MartiCliment.UniGetUI nodejs-lts yt-dlp-nightly advaith.CurrencyConverterPowerToys Microsoft.Office ente-auth Bitwarden.Bitwarden Mega.MEGASync Dropbox.Dropbox Cloudflare.Warp 9NCBCSZSJRSB 9nvjqjbdkn97 9nc73mjwhsww XPDC2RH70K22MN 9pmz94127m4g XP8JRF5SXV03ZM XPDP2QW12DFSFK XPDNX7G06BLH2G xpfm5p5kdwf0jp 9p2b8mcsvpln 9NGHP3DX8HDX

  # Winget-AutoUpdate installation
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements Romanitho.Winget-AutoUpdate --override "/qb STARTMENUSHORTCUT=1 USERCONTEXT=1 NOTIFICATIONLEVEL=None UPDATESINTERVAL=BiDaily UPDATESATTIME=11AM"

  # Add uv bin dir to PATH
  uv tool update-shell

  # Refreshing PATH env
  . "$HOME/refrenv.ps1"

  # Installing python tools packages
  'git+https://github.com/iamkroot/trakt-scrobbler.git', 'git+https://github.com/arecarn/dploy.git' | % { uv tool install $_ }

  # Chocolatey stuff
  # https://github.com/mpv-player/mpv/pull/15912
  choco install -y syncthingtray choco-cleaner aimp mpvio.install
  # https://github.com/microsoft/winget-cli/issues/166
  choco install -y --pin nerd-fonts-hack tor-browser

  # WSL2 installation
  wsl --install --no-launch
}

# Refreshing PATH env
. "$HOME/refrenv.ps1"

# Various settings
gsudo {
  # Disable hypervisor boot
  # https://stackoverflow.com/a/35812945
  # https://github.com/microsoft/WSL/issues/9695
  # https://bytejams.com/help/hvci.html
  # https://learn.microsoft.com/en-us/windows/security/hardware-security/enable-virtualization-based-protection-of-code-integrity?tabs=security
  bcdedit /set hypervisorlaunchtype off

  # topgrade uses `sudo` alias to run choco upgrade
  # https://github.com/topgrade-rs/topgrade/issues/1025 https://github.com/microsoft/sudo/issues/119
  # https://gerardog.github.io/gsudo/docs/gsudo-vs-sudo#what-if-i-install-both
  # https://www.elevenforum.com/t/enable-or-disable-sudo-command-in-windows-11.22329/
  sudo config --enable normal
  # https://github.com/gerardog/gsudo/issues/387 https://github.com/gerardog/gsudo/issues/390 https://github.com/gerardog/gsudo/pull/397
  gsudo config PathPrecedence true
}

# Dotfiles preparations
# https://github.com/microsoft/terminal/issues/2933 https://github.com/microsoft/terminal/issues/14730 https://github.com/microsoft/terminal/issues/17455
Remove-Item -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json; New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $HOME\git\dotfiles_windows\dotfiles\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
# Linking dotfiles
gsudo {
  dploy stow $($args[0])\dotfiles $HOME
  dploy stow $($args[0])\WAU $env:ProgramFiles\Winget-AutoUpdate
} -args "$PSScriptRoot"

# Tasks & services
gsudo {
  # Workaround for https://github.com/erengy/taiga/issues/1120 and https://github.com/erengy/taiga/issues/1161
  Unregister-ScheduledTask -TaskName "Restart Taiga every day" -Confirm:$false
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe run-hidden.exe) -Argument "$env:ProgramFiles\PowerShell\7\pwsh.exe -File $HOME\git\dotfiles_windows\scripts\restart-taiga.ps1") -TaskName "Restart Taiga every day" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00)

  # Task for enabling language change by pressing right ctrl
  Unregister-ScheduledTask -TaskName "switch language with right ctrl" -Confirm:$false
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe lswitch) -Argument "163") -TaskName "switch language with right ctrl" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)) -Trigger (New-ScheduledTaskTrigger -AtLogon)
  Start-ScheduledTask -TaskName "switch language with right ctrl"

  # Upgrade everything with topgrade task
  Unregister-ScheduledTask -TaskName "Upgrade everything" -Confirm:$false
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe nircmd.exe) -Argument "exec min $env:ProgramFiles\PowerShell\7\pwsh.exe $HOME\git\dotfiles_windows\scripts\upgrade-all.ps1") -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 12:00)

  # Run `Temp` task every week, https://github.com/M2Team/NanaZip/issues/297 https://github.com/M2Team/NanaZip/issues/473
  Set-ScheduledTask -TaskName "Sophia\Temp" -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 9:00AM)

  # Run task if scheduled run time is missed
  #Set-ScheduledTask -TaskName choco-cleaner -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable)
}

# https://github.com/tom-james-watson/breaktimer-app/issues/185
winget install --no-upgrade -h -e --id TomWatson.BreakTimer -v 1.1.0

# https://github.com/microsoft/winget-pkgs/issues/106091 https://github.com/microsoft/vscode/issues/134470
# https://github.com/microsoft/vscode/blob/9d43b0751c91c909eee74ea96f765b1765487d7f/build/win32/code.iss#L81-L88
winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements vscode --custom "/mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'"

# Refreshing PATH env
. "$HOME/refrenv.ps1"

npm install --global @microsoft/inshellisense
# mpv plugins installation
curl -L --create-dirs --remote-name-all --output-dir $env:APPDATA\mpv\scripts "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/zenwarr/mpv-config/master/scripts/russian-layout-bindings.lua" "https://github.com/CogentRedTester/mpv-sub-select/raw/master/sub-select.lua" "https://raw.githubusercontent.com/d87/mpv-persist-properties/master/persist-properties.lua"
curl -L "https://github.com/tsl0922/mpv-menu-plugin/releases/download/2.4.1/menu.zip" -o "$HOME\Downloads\mpv-menu-plugin.zip"
7z e "$HOME\Downloads\mpv-menu-plugin.zip" -o"$env:APPDATA\mpv\scripts" -y

# Misc
trakts autostart enable
