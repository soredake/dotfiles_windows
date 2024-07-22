# https://aka.ms/AAh4e0n https://aka.ms/AAftbsj https://aka.ms/AAd9j9k https://aka.ms/AAoal1u
# https://www.outsidethebox.ms/22048/
# Suggest ways to get the most out of Windows…: WhatsNewInWindows -Disable
# Show the Windows welcome experience…: WindowsWelcomeExperience -Hide
# Get tips and suggestions when using Windows…: WindowsTips -Disable
sudo -w -n --close {
  # Downloading Sophia Script
  Remove-Item -Path "$HOME\Downloads\Sophia*" -Recurse -Force
  Invoke-WebRequest script.sophia.team -useb | Invoke-Expression
  pwsh ~\Downloads\Sophia*\Sophia.ps1 -Function "CreateRestorePoint", "TaskbarSearch -Hide", "ControlPanelView -LargeIcons", "FileTransferDialog -Detailed", "ShortcutsSuffix -Disable", "UnpinTaskbarShortcuts -Shortcuts Edge, Store", "DNSoverHTTPS -Enable -PrimaryDNS 1.1.1.1 -SecondaryDNS 1.0.0.1", "Hibernation -Disable", "ThumbnailCacheRemoval -Disable", "SaveRestartableApps -Enable", "WhatsNewInWindows -Disable", "UpdateMicrosoftProducts -Enable", "InputMethod -English"
}
