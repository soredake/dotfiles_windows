if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# https://github.com/Atlas-OS/Atlas/commit/068de83bc24bb12654a6bcdde91b36d2aa52d991

# bcdedit commands
bcdedit /set hypervisorlaunchtype auto
bcdedit /set vm yes
bcdedit /set vsmlaunchtype Auto
bcdedit /set loadoptions ""

# disable hyper-v with DISM
DISM /Online /Enable-Feature:Microsoft-Hyper-V-All /NoRestart
DISM /Online /Enable-Feature:VirtualMachinePlatform /NoRestart

# apply registry changes
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Windows.DeviceGuard::VirtualizationBasedSecuritye
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "RequirePlatformSecurityFeatures" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HypervisorEnforcedCodeIntegrity" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "LsaCfgFlags" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "ConfigureSystemGuardLaunch" /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /f

# taken from here https://github.com/Atlas-OS/Atlas/blob/3e6db61b6bb5a4831b9e2ab0922876aad5a7fe05/src/Executables/Atlas/3.%20Configuration/1.%20General%20Configuration/Hyper-V%20and%20VBS/Disable%20Hyper-V%20and%20VBS%20(default).cmd
# Removed in https://github.com/Atlas-OS/Atlas/commit/6e07de7e99bc4ccf48986d17aa27533882ecc74d
# Disable drivers and services
$services = @(
  "bttflt",
  "gcs",
  "gencounter",
  "hvhost",
  "hvservice",
  "hvsocketcontrol",
  "passthruparser",
  "pvhdparser",
  "spaceparser",
  "storflt",
  "vhdparser",
  "Vid",
  "vkrnlintvsc",
  "vkrnlintvsp",
  "vmbus",
  "vmbusr",
  "vmcompute",
  "vmgid",
  "vmicguestinterface",
  "vmicheartbeat",
  "vmickvpexchange",
  "vmicrdv",
  "vmicshutdown",
  "vmictimesync",
  "vmicvmsession",
  "vmicvss",
  "vpci"
)

foreach ($service in $services) {
  & $PSScriptRoot\setSvc.cmd $service 2
}

# Disable system devices
& $PSScriptRoot\toggleDev.cmd /e "*Hyper-V*"
