# TODO: report that installer does not closes running instances
taskkill /im code.exe

# Wait for vscode to shutdown
Start-Sleep -Seconds 30
