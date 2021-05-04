# https://superuser.com/a/1293383
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # code here...
}
else {
    Start-Process -FilePath "powershell" -ArgumentList "$('-File ""')$(Get-Location)$('\')$($MyInvocation.MyCommand.Name)$('""')" -Verb runAs
}

# https://richardballard.co.uk/ssh-keys-on-windows-10/
Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service
