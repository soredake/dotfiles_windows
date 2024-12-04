# https://github.com/topgrade-rs/topgrade/issues/991
# https://luke.geek.nz/2021/06/18/remove-old-powershell-modules-versions-using-powershell/
function Remove-OldModule {
  [CmdletBinding(SupportsShouldProcess)]
  param ()

  $Latest = Get-InstalledModule

  foreach ($module in $Latest) {
    $oldVersions = Get-InstalledModule -Name $module.Name -AllVersions | Where-Object { $_.Version -ne $module.Version }

    foreach ($oldVersion in $oldVersions) {
      if ($PSCmdlet.ShouldProcess("Module: $($module.Name) Version: $($oldVersion.Version)", "Uninstall")) {
        Uninstall-Module -Name $module.Name -RequiredVersion $oldVersion.Version -Verbose
      }
    }
  }
}

# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/automatically-updating-modules https://github.com/PowerShell/PSResourceGet/issues/521 https://github.com/PowerShell/PSResourceGet/issues/495
Get-InstalledModule | Update-Module
# Clean old module versions
Remove-OldModule

trakts stop
# 'powershell' https://github.com/topgrade-rs/topgrade/issues/972
topgrade --no-retry --cleanup --yes --only 'node' 'scoop' 'wsl_update' 'pipx' 'chocolatey' 'pip3'
trakts start --restart
psc update *
# scoop cannot upgrade topgrade while it was running
# TODO: move topgrade to winget to fix this once this https://github.com/topgrade-rs/topgrade/issues/958 is fixed
scoop update topgrade

# TODO: this is NOT fixed https://github.com/abgox/PSCompletions/issues/56
# psc config enable_completions_update 0
# psc config enable_module_update 0
