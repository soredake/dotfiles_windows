$env:defaultProfile = (Get-Content $env:APPDATA\Mozilla\Firefox\profiles.ini | Select-String -Pattern 'Default=1' -Context 1 | ForEach-Object { $_.Context.PreContext[0] } | Select-String '(Profiles).*').Matches.Value
$env:FFPROFILEPATH = "${env:APPDATA}\Mozilla\Firefox\$env:defaultProfile"
Remove-Item -Path $env:FFPROFILEPATH\user.js
sudo New-Item -ItemType SymbolicLink -Path $env:FFPROFILEPATH\user.js -Target $HOME\git\dotfiles_windows\user.js
