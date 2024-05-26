# https://github.com/microsoft/PowerToys/issues/32595
taskkill /im PowerToys.exe
Start-Sleep -Seconds 10
Start-Process -FilePath "C:\Program Files\PowerToys\PowerToys.exe" -WindowStyle Hidden -Verb RunAs
