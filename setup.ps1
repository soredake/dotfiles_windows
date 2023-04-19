. $env:r\function.ps1
# https://docs.microsoft.com/en-us/windows/application-management/provisioned-apps-windows-client-os https://pureinfotech.com/view-installed-apps-powershell-windows-10/
$debloat = 'Clipchamp.Clipchamp_yxz26nhyzhsrt', 'MicrosoftTeams_8wekyb3d8bbwe', 'Microsoft.Todos_8wekyb3d8bbwe', 'Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe', 'Microsoft.Getstarted_8wekyb3d8bbwe', 'Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe', 'Microsoft.ZuneMusic_8wekyb3d8bbwe', 'Microsoft.WindowsCamera_8wekyb3d8bbwe', 'Microsoft.ZuneVideo_8wekyb3d8bbwe', 'Microsoft.WindowsMaps_8wekyb3d8bbwe', 'Microsoft.Windows.Photos_8wekyb3d8bbwe', 'Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe', 'Microsoft.People_8wekyb3d8bbwe', 'Microsoft.BingWeather_8wekyb3d8bbwe', 'Microsoft.BingNews_8wekyb3d8bbwe', 'AdvancedMicroDevicesInc-2.AMDLink_0a9344xs7nr4m', 'Microsoft.GetHelp_8wekyb3d8bbwe', 'Microsoft.549981C3F5F10_8wekyb3d8bbwe', "BlueStacks X", 'microsoft.windowscommunicationsapps_8wekyb3d8bbwe', "windows web experience pack"
foreach ($package in $debloat) { sudo winget uninstall -h $package } # TODO: wait for new release to arrive https://github.com/microsoft/winget-cli/pull/2861
sudo Disable-ScheduledTask "Achievement Watcher Upgrade Daily" # https://github.com/Xav83/chocolatey-packages/pull/24
$winget = 'XP8K0HKJFRXGCK', '9NFH4HJG2Z9H', '9NCBCSZSJRSB', '9NZVDKPMR9RD', 'XPDC2RH70K22MN', 'BlueStack.BlueStacks', '9PMZ94127M4G', 'Microsoft.VisualStudioCode', 'Python.Python.3', 'lycheeverse.lychee', 'XP99J3KP4XZ4VV', '9N3SQK8PDS8G' # nanazip https://github.com/M2Team/NanaZip/issues/86
foreach ($p in $winget) { winget install --no-upgrade -h --accept-package-agreements --accept-source-agreements $p } # TODO: wait for new release to arrive https://github.com/microsoft/winget-cli/pull/2861
winget install -h -e --id TomWatson.BreakTimer -v 1.1.0 # https://github.com/tom-james-watson/breaktimer-app/issues/185
if (!$env:vm) {
  # set static ip https://stackoverflow.com/a/53991926
  $env:interfaceIndex = (Get-NetRoute | Where-Object -FilterScript { $_.DestinationPrefix -eq "0.0.0.0/0" } | Get-NetAdapter).InterfaceIndex
  sudo "New-NetIPAddress -InterfaceIndex $env:interfaceIndex -IPAddress 192.168.0.145 -AddressFamily IPv4 -PrefixLength 24 -DefaultGateway 192.168.0.1; Get-NetAdapter -Physical | Get-NetIPInterface -AddressFamily IPv4 | Set-DnsClientServerAddress -ServerAddresses 1.1.1.1, 1.0.0.1"
}
Remove-Item -Recurse -Path ~\Downloads\Sophia*
Invoke-RestMethod script.sophi.app -useb | Invoke-Expression
sudo ~\Downloads\Sophia*\Sophia.ps1 -Function CreateRestorePoint, "TaskbarSearch -SearchIcon", "CastToDeviceContext -Hide", "ControlPanelView -LargeIcons", "FileTransferDialog -Detailed", "HiddenItems -Enable", "FileExtensions -Show", "TaskbarChat -Hide", "ShortcutsSuffix -Disable", "UnpinTaskbarShortcuts -Shortcuts Edge, Store", "OneDrive -Uninstall", "DNSoverHTTPS -Enable -PrimaryDNS 1.1.1.1 -SecondaryDNS 1.0.0.1", "ThumbnailCacheRemoval -Disable"
sudo choco install -y --pin syncthingtray ea-app jdownloader viber vigembus 64gram achievement-watcher steam-rom-manager itch powertoys googledrive parsec goggalaxy hamachi protonvpn steam tor-browser hidhide --params "/NoStart" # TODO: https://github.com/mkevenaar/chocolatey-packages/issues/188, syncthingtray is pinned until https://gitlab.com/yan12125/chocolatey-packages/-/issues/2 is fixed
sudo choco install -y --pin --pre pcsx2-dev rpcs3 --params "/Desktop /UseAVX2 /DesktopIcon"
sudo choco install -y ryujinx postman virtualbox multipass ytdownloader taiga dupeguru keepassxc ffmpeg responsively insomnia 7tt 7zip.install doublecmd wiztree nomacs nodejs.install ppsspp retroarch steascree.install ds4windows choco-cleaner rclone.portable msiafterburner yt-dlp nerdfont-hack tor git.install --params "/DesktopShortcut /NoShellHereIntegration /NoOpenSSH /RTSSDesktopShortcut";
sudo choco install -y syncplay --pre --version 1.7.0; sudo choco -y install mpvnet.portable --pre; sudo choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:19:00'"
reloadenv
Invoke-RestMethod get.scoop.sh | Invoke-Expression
scoop bucket add extras
scoop bucket add games
scoop install cheat-engine yuzu-pineapple
pip install pipx
pipx ensurepath
$pip = @("internetarchive", "git+https://github.com/arecarn/dploy.git", "tubeup")
# TODO: request ability to install multiple-venvs with one command https://github.com/pypa/pipx/issues/88
foreach ($p in $pip) { pipx install $p }
Install-PackageProvider -Name NuGet -Scope CurrentUser -Confirm:$false -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name posh-git, npm-completion, Terminal-Icons, PSAdvancedShortcut
npm install --global html-validate gulp-cli create-react-app
curl -L --create-dirs --remote-name-all --output-dir $env:APPDATA\mpv.net\scripts "https://github.com/ekisu/mpv-webm/releases/download/latest/webm.lua" "https://codeberg.org/jouni/mpv_sponsorblock_minimal/raw/branch/master/sponsorblock_minimal.lua" "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/tree-profiles.lua" "https://raw.githubusercontent.com/fbriere/mpv-scripts/master/scripts/brace-expand.lua" "https://raw.githubusercontent.com/zenwarr/mpv-config/master/scripts/russian-layout-bindings.lua"
Invoke-WebRequest -Uri "https://haali.net/winutils/lswitch.exe" -OutFile $HOME/lswitch.exe # TODO: add to winget/scoop/choco
sudo 'Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$HOME\lswitch.exe" -Argument "163") -TaskName "switch language with right ctrl" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit 0 -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)) -Trigger (New-ScheduledTaskTrigger -AtLogon)'
sudo Start-ScheduledTask -TaskName "switch language with right ctrl"
Invoke-WebRequest -Uri "https://github.com/Romanitho/Winget-AutoUpdate/archive/refs/heads/main.zip" -OutFile "$env:TEMP/Winget-AutoUpdate.zip"
Expand-Archive "$env:TEMP/Winget-AutoUpdate.zip" -DestinationPath "$env:TEMP"
sudo "$env:TEMP/Winget-AutoUpdate-main/Winget-AutoUpdate-Install.ps1" -NotificationLevel None -UpdatesInterval Weekly -DoNotUpdate -UpdatesAtTime 11AM
sudo Invoke-WebRequest -Uri "https://gist.github.com/soredake/f0c63deeaf104e30135a28c3238a6008/raw" -OutFile C:\ProgramData\Winget-AutoUpdate\excluded_apps.txt
# link dotfiles
sudo 'Remove-Item -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json; New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Target $HOME\git\dotfiles_windows\dotfiles\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'
# New-Item -Path $env:APPDATA\mpv.net\script-opts -ItemType Directory
sudo dploy stow dotfiles $HOME
# shortcuts
Import-Module -Name $HOME\Documents\PowerShell\Modules\PSAdvancedShortcut
New-Shortcut -Name 'Disconnect gamepad' -Path $HOME\Desktop -Target "$env:ChocolateyInstall\bin\DS4Windows.exe" -Arguments "-command Disconnect" -IconPath '$env:ChocolateyInstall\lib\ds4windows\tools\DS4Windows\DS4Windows.exe'
New-Shortcut -Name 'Cheat Engine' -Path $HOME\Desktop -Target "$HOME\scoop\apps\cheat-engine\current\cheatengine-x86_64.exe" # https://github.com/ScoopInstaller/Scoop/issues/4212
New-Shortcut -Name 'BreakTimer - disable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments disable
New-Shortcut -Name 'BreakTimer - enable' -Path $HOME\Desktop -Target "$env:LOCALAPPDATA\Programs\breaktimer\BreakTimer.exe" -Arguments enable
New-Shortcut -Name 'SteaScree' -Path $HOME\Desktop -Target "C:\Program Files (x86)\SteaScree\SteaScree.exe" # https://github.com/chtof/chocolatey-packages/pull/92
New-Shortcut -Name 'yuzu Early Access' -Path $HOME\Desktop -Target "$HOME\scoop\apps\yuzu-pineapple\current\yuzu.exe"
# Tasks
sudo New-Service -Name "tor" -BinaryPathName '"C:\ProgramData\chocolatey\lib\tor\tools\Tor\tor.exe --nt-service -f C:\Users\User\AppData\Local\tor\torrc"' # # https://gitlab.torproject.org/tpo/core/tor/-/issues/17145
Register-ScheduledTask -Principal (New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest) -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument '--title "AMD cleanup task" pwsh -c amdcleanup') -TaskName "AMD cleanup task" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Friday -At 11:00)
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument "--title Backup pwsh -c backup") -TaskName "Backup everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -At 12:00 -DaysOfWeek 3)
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe" -Argument '--title "Update everything" pwsh -c upgradeall') -TaskName "Upgrade everything" -Settings (New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable) -Trigger (New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 11:00)
sudo choco feature enable -n=useRememberedArgumentsForUpgrades -n=removePackageInformationOnUninstall
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0 # https://remontka.pro/wake-timers-windows/
# https://admx.help/?Category=Windows_8.1_2012R2&Policy=Microsoft.Policies.WindowsLogon::DisableStartupSound https://aka.ms/AAh46ae
sudo Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableStartupSound' -Value 1 -Force
# disable slide-away lock screen, https://superuser.com/a/1659652/1506333 https://www.techrepublic.com/article/how-to-disable-the-lock-screen-in-windows-11-an-update/ https://aka.ms/AAh3io0
sudo reg add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization' /v 'NoLockScreen' /t REG_DWORD /d 1 /f
# https://winitpro.ru/index.php/2021/12/16/udalit-chat-microsoft-teams-v-windows/ https://www.outsidethebox.ms/21375/ https://aka.ms/AAh4nac
sudo --ti reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t REG_DWORD /d 0 /f
# https://answers.microsoft.com/en-us/xbox/forum/all/xbox-game-bar-fps/4a773b5b-a6aa-4586-b402-a2b8e336b428 https://support.xbox.com/en-US/help/friends-social-activity/share-socialize/xbox-game-bar-performance https://aka.ms/AAh2b88 https://aka.ms/AAh23gr
sudo net localgroup "Пользователи журналов производительности" User /add
# stop qbittorrent/ethernet from waking my pc https://superuser.com/a/1629820/1506333
sudo powercfg /devicedisablewake "Intel(R) I211 Gigabit Network Connection"
# vbs disable script
sudo .\vbs-disable.ps1
# https://winaero.com/change-icon-cache-size-windows-10/
sudo Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'Max` Cached` Icons' -Type 'String' -Value 65535 -Force
# hide pwsh update notification, delete this if this https://github.com/microsoft/PowerToys/issues/10231 is fixed
setx POWERSHELL_UPDATECHECK Off
# cleanup
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\Achievement Watcher.lnk", "$HOME\Desktop\Google Docs.lnk", "$HOME\Desktop\Google Sheets.lnk", "$HOME\Desktop\Google Slides.lnk", "$HOME\Desktop\PPSSPP (32-Bit).lnk" # https://github.com/Xav83/chocolatey-packages/pull/24 https://github.com/kzdixon/chocolatey-packages/pull/2 https://github.com/mkevenaar/chocolatey-packages/pull/195а
# multipass setup
if (!$env:vm) {
  sudo multipass set local.driver=virtualbox
  multipass set local.privileged-mounts=yes
  multipass set client.gui.autostart=no
  multipass launch --name primary --mount E:\:/mnt/e_host --mount C:\:/mnt/c_host
  multipass exec primary bash /mnt/c_host/Users/user/git/dotfiles_windows/wsl.sh
}
# TODO: reconnect with git repo

# firefox user.js
if (!$env:vm) {
  $env:defaultProfile = (Get-Content $env:APPDATA\Mozilla\Firefox\profiles.ini | Select-String -Pattern 'Default=1' -Context 1 | ForEach-Object { $_.Context.PreContext[0] } | Select-String '(Profiles).*').Matches.Value
  if ($env:defaultProfile) {
    $env:FFPROFILEPATH = "${env:APPDATA}\Mozilla\Firefox\$env:defaultProfile"
    Remove-Item -Path $env:FFPROFILEPATH\user.js; sudo New-Item -ItemType SymbolicLink -Path $env:FFPROFILEPATH\user.js -Target $HOME\git\dotfiles_windows\user.js
  }
}
