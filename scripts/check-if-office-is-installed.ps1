# Define the registry paths where Office installations are usually registered
$officeRegistryPaths = @(
  "HKLM:\SOFTWARE\Microsoft\Office",
  "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Office"
)

# Initialize a flag to indicate whether Office is found
$officeFound = $false

# Iterate through each registry path and check for subkeys
foreach ($path in $officeRegistryPaths) {
  if (Test-Path $path) {
    $officeVersions = Get-ChildItem -Path $path

    foreach ($version in $officeVersions) {
      # Check if the path has any version subkeys that match the pattern
      if ($version.PSChildName -match '^\d{2,4}\.0$') {
        $officeFound = $true
        break
      }
    }
  }
  # Break out of the loop if Office is found
  if ($officeFound) {
    break
  }
}

# Return the result as a boolean value
return $officeFound
