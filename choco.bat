rem https://docs.chocolatey.org/en-us/choco/setup#install-with-cmd.exe
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
choco install -y firefox steam-cleaner steam-client 7zip.install chocolateygui keepassxc powertoys telegram.install ds4windows origin qbittorrent discord.install goggalaxy autoruns dxwnd pcsx2.install choco-cleaner epicgameslauncher viber adoptopenjdk
choco install -y edgedeflector jdownloader vscode python nodejs yarn git hackfont microsoft-windows-terminal msys2 visualstudio2019buildtools google-backup-and-sync nomacs mpv.install tor-browser
choco install -y rpcs3 --pre
choco install -y choco-upgrade-all-at --params "'/WEEKLY:yes /DAY:SUN /TIME:15:00'"

rem choco install -y protonvpn warp
