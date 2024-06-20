# Installer cannot close git processes running on another user, this should be fixed when there will be fully per-user installer https://github.com/git-for-windows/git/issues/4758
taskkill /T /f /im git.exe
