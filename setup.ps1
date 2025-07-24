# Install powershell modules early to avoid https://github.com/badrelmers/RefrEnv/issues/9
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name posh-git

# Running Sophia Script
gsudo powershell {
  . $env:LOCALAPPDATA\Microsoft\WinGet\Packages\*SophiaScript*\*\Import-TabCompletion.ps1
  Sophia -Functions "TempTask -Register"
}

# Installing my scoop packages
'extras' | % { scoop bucket add $_ }
scoop bucket add holes "https://github.com/instinctualjealousy/holes"
scoop install onthespot persistent-windows

# https://github.com/arecarn/dploy/issues/8
New-Item -Path $env:APPDATA\trakt-scrobbler, $env:APPDATA\mpv\scripts -ItemType Directory -Force | Out-Null

# NOTE: gsudo script-blocks can take only 3008 characters https://github.com/gerardog/gsudo/issues/364

# Installing software
gsudo {
  # https://github.com/microsoft/winget-cli/issues/549
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements WingetPathUpdater
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements --exact OpenRGB.OpenRGB Google.PlayGames.Beta 7zip.7zip UnifiedIntents.UnifiedRemote sandboxie-classic Mozilla.Firefox Rem0o.FanControl wireguard Chocolatey.Chocolatey Valve.Steam Ryochan7.DS4Windows AppWork.JDownloader google-drive GOG.Galaxy wiztree eaapp protonvpn msedgeredirect afterburner rivatuner bcuninstaller voidtools.Everything.Alpha RamenSoftware.Windhawk qBittorrent.qBittorrent HermannSchinagl.LinkShellExtension volumelock Syncplay.Syncplay advaith.CurrencyConverterPowerToys Microsoft.Office ente-auth Cloudflare.Warp xpfftq032ptphf xp99vr1bpsbqj2 xp9cdqw6ml4nqn xpfm11z0w10r7g xp8jrf5sxv03zm xpdp2qw12dfsfk xpdnx7g06blh2g

  # Chocolatey stuff
  # https://github.com/mpv-player/mpv/pull/15912
  choco install -y mpvio.install

  # https://github.com/kangyu-california/PersistentWindows
  ~\scoop\apps\persistent-windows\current\auto_start_pw_aux.ps1
}

# Installing Hack font
oh-my-posh font install hack

# Installing software
winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements --exact BillStewart.SyncthingWindowsSetup LocalSend.LocalSend topgrade-rs.topgrade python3.12 astral-sh.uv Telegram.TelegramDesktop lycheeverse.lychee yt-dlp-nightly w4po.ExplorerTabUtility itch.io erengy.Taiga nomacs.nomacs dupeguru Bitwarden.Bitwarden 9n8g7tscl18r xp8k0hkjfrxgck 9ncbcszsjrsb 9nvjqjbdkn97 9nc73mjwhsww xpdc2rh70k22mn 9pmz94127m4g xpfm5p5kdwf0jp xp89dcgq3k6vld 9p4clt2rj1rs 9mz1snwt0n5d

# Add uv bin dir to PATH
uv tool update-shell

# Refreshing PATH env
. "$HOME/refrenv.ps1"

# Installing python tools packages
'git+https://github.com/iamkroot/trakt-scrobbler.git', 'git+https://github.com/arecarn/dploy.git' | % { uv tool install $_ }

# Interactive tor browser installation
# NOTE: install silently when https://gitlab.torproject.org/tpo/applications/tor-browser-build/-/issues/41138 is implemented
winget install --no-upgrade --interactive --accept-package-agreements --accept-source-agreements --exact TorProject.TorBrowser

# https://github.com/microsoft/winget-pkgs/issues/106091 https://github.com/microsoft/vscode/issues/134470
# https://github.com/microsoft/vscode/blob/9d43b0751c91c909eee74ea96f765b1765487d7f/build/win32/code.iss#L81-L88
winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements vscode --custom "/mergetasks='!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath'"

# https://github.com/tom-james-watson/breaktimer-app/issues/185
winget install --no-upgrade -h -e --id TomWatson.BreakTimer -v 1.1.0

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
}

# Dotfiles preparations
# https://github.com/microsoft/terminal/issues/2933 https://github.com/microsoft/terminal/issues/14730 https://github.com/microsoft/terminal/issues/17455
Remove-Item -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json; New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $HOME\git\dotfiles_windows\dotfiles\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
# Linking dotfiles
gsudo dploy stow $HOME\git\dotfiles_windows\dotfiles $HOME

# Tasks & services
gsudo {
  # Upgrade everything with topgrade task
  Unregister-ScheduledTask -TaskName "Upgrade everything" -Confirm:$false
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe pwsh.exe) -Argument "-WindowStyle Minimized $HOME\git\dotfiles_windows\scripts\upgrade-all.ps1") -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 12:00)

  # Run `Temp` task every week, https://github.com/M2Team/NanaZip/issues/297 https://github.com/M2Team/NanaZip/issues/473 https://github.com/M2Team/NanaZip/issues/676
  Set-ScheduledTask -TaskName "Sophia\Temp" -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 9:00AM)

  # https://github.com/kangyu-california/PersistentWindows/issues/388
  Set-ScheduledTask -TaskName "StartPersistentWindows$env:USERNAME" -Action (New-ScheduledTaskAction -Execute (Get-ScheduledTask -TaskName "StartPersistentWindows$env:USERNAME").Actions[0].Execute -Argument ((Get-ScheduledTask -TaskName "StartPersistentWindows$env:USERNAME").Actions[0].Arguments + " -auto_restore_new_window_to_last_capture=0"))
}


# mpv plugins installation
curl -L --remote-name-all --output-dir $env:APPDATA\mpv\scripts "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/zenwarr/mpv-config/master/scripts/russian-layout-bindings.lua" "https://github.com/CogentRedTester/mpv-sub-select/raw/master/sub-select.lua" "https://raw.githubusercontent.com/d87/mpv-persist-properties/master/persist-properties.lua"
curl -L "https://github.com/tsl0922/mpv-menu-plugin/releases/download/2.4.1/menu.zip" -o "$HOME\Downloads\mpv-menu-plugin.zip"
7z e "$HOME\Downloads\mpv-menu-plugin.zip" -o"$env:APPDATA\mpv\scripts" -y

# Misc
trakts autostart enable

# Stop ethernet/qbittorrent from waking my pc https://superuser.com/a/1629820/1506333
# https://github.com/qbittorrent/qBittorrent/issues/21709
# This also disables the network card's LED while the PC is in sleep, which I want
gsudo {
  $ifIndexes = (Get-NetRoute | Where-Object -Property DestinationPrefix -EQ "0.0.0.0/0").ifIndex
  $CurrentNetworkAdapterName = (Get-NetAdapter | Where-Object { $ifIndexes -contains $_.ifIndex -and $_.Name -like "Ethernet*" } | Select-Object -ExpandProperty InterfaceDescription)
  powercfg /devicedisablewake $CurrentNetworkAdapterName
}
