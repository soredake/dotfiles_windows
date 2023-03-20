(Get-AppxProvisionedPackage -Online -LogLevel Warnings | Where-Object -Property DisplayName -EQ Microsoft.DesktopAppInstaller).InstallLocation -replace '%SYSTEMDRIVE%', $env:SystemDrive | Add-AppxPackage -Register -DisableDevelopmentMode