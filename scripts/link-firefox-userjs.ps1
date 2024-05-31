$env:FirefoxDefaultProfile = (Get-Content $env:APPDATA\Mozilla\Firefox\profiles.ini | Select-String -Pattern 'Default=1' -Context 1 | ForEach-Object { $_.Context.PreContext[0] } | Select-String '(Profiles).*').Matches.Value
$env:FirefoxDefaultProfilePath = "${env:APPDATA}\Mozilla\Firefox\$env:FirefoxDefaultProfile"

Remove-Item -Path $env:FirefoxDefaultProfilePath\user.js
sudo { New-Item -ItemType SymbolicLink -Path $env:FirefoxDefaultProfilePath\user.js -Target $HOME\git\dotfiles_windows\user.js }
