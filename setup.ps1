# https://superuser.com/a/1293383
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # code here...
}
else {
    Start-Process -FilePath "powershell" -ArgumentList "$('-File ""')$(Get-Location)$('\')$($MyInvocation.MyCommand.Name)$('""')" -Verb runAs
}

# https://docs.chocolatey.org/en-us/choco/setup#install-with-powershell.exe
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install -y firefox steam-cleaner steam-client 7zip.install chocolateygui keepassxc powertoys telegram.install ds4windows origin qbittorrent discord.install goggalaxy autoruns dxwnd pcsx2.install choco-cleaner epicgameslauncher viber adoptopenjdk edgedeflector jdownloader vscode python nodejs yarn git hackfont microsoft-windows-terminal msys2 visualstudio2019buildtools google-backup-and-sync nomacs mpv.install tor-browser windirstat
choco install -y retroarch --params "'/DesktopShortcut'"
choco install -y rpcs3 --pre
choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:15:00'"

# https://richardballard.co.uk/ssh-keys-on-windows-10/
Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service

schtasks /create /tn "switch language with right ctrl" /sc onlogon /rl highest /tr "C:\Users\user\lswitch.exe 163"

# git for windows uses wrong ssh binary which leads to errors like `Permission Denied (publickey)` because it don't use windows ssh-agent
# https://github.com/PowerShell/Win32-OpenSSH/wiki/Setting-up-a-Git-server-on-Windows-using-Git-for-Windows-and-Win32_OpenSSH#on-client
# https://github.com/PowerShell/Win32-OpenSSH/issues/1136#issuecomment-382074202
setx GIT_SSH_COMMAND "C:\\Windows\\System32\\OpenSSH\\ssh.exe -T"

# need to launch this in non-priviledged script aferwards
C:\tools\msys64\mingw64.exe pacman.exe -S --noconfirm zsh fish python diffutils
yarn set version berry
