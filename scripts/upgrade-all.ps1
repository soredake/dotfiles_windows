# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/automatically-updating-modules https://github.com/PowerShell/PSResourceGet/issues/521 https://github.com/PowerShell/PSResourceGet/issues/495
Get-InstalledModule | Update-Module

trakts stop
# 'powershell' https://github.com/topgrade-rs/topgrade/issues/972
topgrade --no-retry --cleanup --yes --only 'node' 'scoop' 'chocolatey' 'uv'
trakts start --restart
# scoop cannot upgrade topgrade while it was running
# TODO: move topgrade to winget to fix this once this https://github.com/topgrade-rs/topgrade/issues/958 https://github.com/topgrade-rs/topgrade/pull/1042 is fixed
scoop update topgrade
