# https://luke.geek.nz/2021/06/18/remove-old-powershell-modules-versions-using-powershell/
# TODO: request module cleanup in topgrade
function Remove-OldModules {
  $Latest = Get-InstalledModule
  foreach ($module in $Latest) {
    Write-Verbose -Message "Uninstalling old versions of $($module.Name) [latest is $( $module.Version)]" -Verbose
    Get-InstalledModule -Name $module.Name -AllVersions | Where-Object { $_.Version -ne $module.Version } | Uninstall-Module -Verbose 
  }
}

# NOTE: `wsl` step can run topgrade in WSL
trakts stop
# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/automatically-updating-modules https://github.com/PowerShell/PSResourceGet/issues/521 https://github.com/PowerShell/PSResourceGet/issues/495
Get-InstalledModule | Update-Module
# Clean old module versions
Remove-OldModules
# 'powershell' https://github.com/topgrade-rs/topgrade/issues/972
topgrade --no-retry --cleanup --yes --only 'node' 'scoop' 'wsl_update' 'pipx' 'chocolatey'
trakts start --restart
psc update *
# scoop cannot upgrade topgrade while it was running
# TODO: move topgrade to winget to fix this once this https://github.com/topgrade-rs/topgrade/issues/958 is fixed
scoop update topgrade

# https://github.com/abgox/PSCompletions/issues/56
# psc config enable_completions_update 0
# psc config enable_module_update 0
