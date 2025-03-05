# Multipass
multipass stop --all
Stop-Service Multipass -Force
taskkill /T /im multipass*

# VirtualBox
$vms = VBoxManage list runningvms | ForEach-Object {
  if ($_ -match '\{(.*)\}') { $matches[1] }
}

foreach ($vm in $vms) {
  VBoxManage controlvm $vm savestate
}

Stop-Service VBoxSDS -Force

taskkill /T /im VirtualBox.exe
taskkill /T /im VBoxSVC.exe
taskkill /T /im VBoxHeadless.exe
taskkill /T /im VirtualBoxVM.exe

# List all drivers with names starting with "Vbox"
$drivers = Get-CimInstance -Query "SELECT * FROM Win32_SystemDriver WHERE Name LIKE 'Vbox%'"

# Display the drivers
$drivers | ForEach-Object {
  Write-Output "Found driver: $($_.Name)"
}

# Unload the drivers
$drivers | ForEach-Object {
  $driverName = $_.Name
  Write-Output "Attempting to stop driver: $driverName"
  sc.exe stop $driverName
}
