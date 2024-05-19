$env:defaultProfile = (Get-Content $env:APPDATA\Mozilla\Firefox\profiles.ini | Select-String -Pattern 'Default=1' -Context 1 | ForEach-Object { $_.Context.PreContext[0] } | Select-String '(Profiles).*').Matches.Value
$env:FFPROFILEPATH = "${env:APPDATA}\Mozilla\Firefox\$env:defaultProfile"

rclone sync -P $env:FFPROFILEPATH\bookmarkbackups "$HOME\Мой диск\документы\backups\firefox_bookmarks"
