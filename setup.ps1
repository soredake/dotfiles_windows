# Install powershell modules early to avoid https://github.com/badrelmers/RefrEnv/issues/9
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name posh-git

# Running Sophia Script
gsudo powershell {
  . $env:LOCALAPPDATA\Microsoft\WinGet\Packages\*SophiaScript*\*\Import-TabCompletion.ps1
  Sophia -Functions "DNSoverHTTPS -Enable -PrimaryDNS 8.8.8.8 -SecondaryDNS 8.8.4.4"
}

# Installing my scoop packages
# https://github.com/ScoopInstaller/Scoop/issues/2035 https://github.com/ScoopInstaller/Scoop/issues/5852 software that cannot be moved to scoop because scoop cleanup cannot close running programs: syncthingtray
'extras' | % { scoop bucket add $_ }
scoop install onthespot

# https://github.com/arecarn/dploy/issues/8
New-Item -Path $env:APPDATA\trakt-scrobbler, $env:APPDATA\mpv\scripts -ItemType Directory -Force | Out-Null

# NOTE: sudo script-blocks can take only 3008 characters https://github.com/gerardog/gsudo/issues/364

# Installing software
gsudo {
  # https://github.com/microsoft/winget-cli/issues/549
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements WingetPathUpdater
  winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements --exact Google.PlayGames.Beta 7zip.7zip UnifiedIntents.UnifiedRemote sandboxie-classic Mozilla.Firefox Rem0o.FanControl wireguard Chocolatey.Chocolatey Valve.Steam Ryochan7.DS4Windows AppWork.JDownloader google-drive GOG.Galaxy wiztree eaapp protonvpn msedgeredirect afterburner rivatuner bcuninstaller voidtools.Everything.Alpha RamenSoftware.Windhawk qBittorrent.qBittorrent HermannSchinagl.LinkShellExtension volumelock Syncplay.Syncplay nodejs-lts advaith.CurrencyConverterPowerToys Microsoft.Office ente-auth Cloudflare.Warp xpfftq032ptphf xp99vr1bpsbqj2 xp9cdqw6ml4nqn xpfm11z0w10r7g xp8jrf5sxv03zm xpdp2qw12dfsfk xpdnx7g06blh2g xpddt99j9gkb5c

  # Chocolatey stuff
  # https://github.com/mpv-player/mpv/pull/15912
  choco install -y mpvio.install
  # https://github.com/microsoft/winget-cli/issues/166
  choco install -y --pin nerd-fonts-hack aimp

  # WSL2 installation
  wsl --install --no-launch
  wsl --manage Ubuntu --set-sparse true --allow-unsafe
}

# Installing software
winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements --exact BillStewart.SyncthingWindowsSetup
LocalSend.LocalSend topgrade-rs.topgrade python3.12 astral-sh.uv Telegram.TelegramDesktop lycheeverse.lychee komac yt-dlp-nightly w4po.ExplorerTabUtility itch.io erengy.Taiga nomacs dupeguru Bitwarden.Bitwarden Mega.MEGASync 9n8g7tscl18r xp8k0hkjfrxgck 9ncbcszsjrsb 9nvjqjbdkn97 9nc73mjwhsww xpdc2rh70k22mn 9pmz94127m4g xpfm5p5kdwf0jp 9nghp3dx8hdx 9nk4t08dhq80 xp89dcgq3k6vld

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

  # https://bitwarden.com/help/ssh-agent/#configure-bitwarden-ssh-agent
  Set-Service ssh-agent -StartupType Disabled
}

# Dotfiles preparations
# https://github.com/microsoft/terminal/issues/2933 https://github.com/microsoft/terminal/issues/14730 https://github.com/microsoft/terminal/issues/17455
Remove-Item -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json; New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $HOME\git\dotfiles_windows\dotfiles\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
# Linking dotfiles
gsudo dploy stow $HOME\git\dotfiles_windows\dotfiles $HOME

# Tasks & services
gsudo {
  # Workaround for https://github.com/erengy/taiga/issues/1120 and https://github.com/erengy/taiga/issues/1161
  # https://github.com/nicolonsky/IntuneDriveMapping/issues/58
  Unregister-ScheduledTask -TaskName "Restart Taiga every day" -Confirm:$false
  Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute (where.exe conhost.exe) -Argument "--headless $env:ProgramFiles\PowerShell\7\pwsh.exe -File $HOME\git\dotfiles_windows\scripts\restart-taiga.ps1") -TaskName "Restart Taiga every day" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Daily -At 09:00)

  # Upgrade everything with topgrade task
  Unregister-ScheduledTask -TaskName "Upgrade everything" -Confirm:$false
  Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute (where.exe pwsh.exe) -Argument "-WindowStyle Minimized $HOME\git\dotfiles_windows\scripts\upgrade-all.ps1") -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 12:00)
}

npm install --global @microsoft/inshellisense

# mpv plugins installation
curl -L --remote-name-all --output-dir $env:APPDATA\mpv\scripts "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/zenwarr/mpv-config/master/scripts/russian-layout-bindings.lua" "https://github.com/CogentRedTester/mpv-sub-select/raw/master/sub-select.lua" "https://raw.githubusercontent.com/d87/mpv-persist-properties/master/persist-properties.lua"
curl -L "https://github.com/tsl0922/mpv-menu-plugin/releases/download/2.4.1/menu.zip" -o "$HOME\Downloads\mpv-menu-plugin.zip"
7z e "$HOME\Downloads\mpv-menu-plugin.zip" -o"$env:APPDATA\mpv\scripts" -y

# Misc
trakts autostart enable
