#Start-Sleep -Seconds 15
taskkill /T /f /im run.exe
taskkill /T /f /im plex.exe
# NOTE: Plex For Windows cannot started minimized
# NOTE: Plex For Windows needs to be started as admin to avoid UAC prompt https://www.reddit.com/r/PleX/comments/q8un5s/is_there_any_way_to_stop_plex_from_trying_to/
Start-Process -FilePath "$env:ProgramFiles\Plex\Plex\Plex.exe" -Verb RunAs
Start-Sleep -Seconds 5
nircmd win min process Plex.exe
pwsh C:\Users\user\git\dotfiles_windows\scripts\restore-focus-to-previous-active-window.ps1
Start-Sleep -Seconds 15
Start-Process -FilePath $HOME\scoop\apps\plex-mpv-shim\current\run.exe -WorkingDirectory $HOME\scoop\apps\plex-mpv-shim\current
