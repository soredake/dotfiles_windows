function reloadenv {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User") 
} # https://stackoverflow.com/a/31845512 https://github.com/microsoft/winget-cli/issues/222
