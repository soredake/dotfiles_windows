$env:FirefoxDefaultProfile = (Get-Content $env:APPDATA\Mozilla\Firefox\profiles.ini | Select-String -Pattern 'Default=1' -Context 1 | ForEach-Object { $_.Context.PreContext[0] } | Select-String '(Profiles).*').Matches.Value
$env:FirefoxDefaultProfilePath = "${env:APPDATA}\Mozilla\Firefox\$env:FirefoxDefaultProfile"

rclone sync -P $env:FirefoxDefaultProfilePath\bookmarkbackups "$HOME\Мой диск\документы\backups\firefox_bookmarks"
