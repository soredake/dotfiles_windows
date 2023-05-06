firefox -CreateProfile letyshops
exe = Get-Item "$env:LOCALAPPDATA\Microsoft\WindowsApps\firefox.exe" | Select-Object -ExpandProperty Target
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Firefox - LetyShops profile.lnk")
$Shortcut.TargetPath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\firefox.exe" # TODO: set icon to real exe
$Shortcut.Arguments = "-P letyshops"
$Shortcut.Save()
