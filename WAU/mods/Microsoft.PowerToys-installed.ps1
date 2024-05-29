# https://github.com/microsoft/PowerToys/issues/32595
taskkill /f /im PowerToys.exe
Start-Sleep -Seconds 10
Start-Process -FilePath "$env:ProgramFiles\PowerToys\PowerToys.exe" -WindowStyle Hidden -Verb RunAs
