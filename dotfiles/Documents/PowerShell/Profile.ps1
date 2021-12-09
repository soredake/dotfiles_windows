Import-Module posh-git
Import-Module npm-completion
Import-Module yarn-completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/automatically-updating-modules
# https://www.activestate.com/resources/quick-reads/how-to-update-all-python-packages/
function updateall { Get-InstalledModule | Update-Module; pip freeze | %{$_.split('==')[0]} | %{pip install --upgrade $_}; C:\tools\msys64\mingw64.exe pacman.exe -Syu --noconfirm; sudo wsl --update }
