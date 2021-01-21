$User = "$($ENV:userdomain)\user$"
$PWord = ConvertTo-SecureString -String 'c}J#mk0I5En5' -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
$argz = @"
/QUIET /VERBOSELOG /COMPONENTS VDA /CONTROLLERS 'vda.controller1.site.com vda.controller2.site.com' /ENABLE_HDX_PORTS /ENABLE_REAL_TIME_TRANSPORT /ENABLE_HDX_UDP_PORTS
"@
Start-Process -FilePath "$env:systemroot\temp\x64\XenDesktop Setup\XenDesktopVDASetup.exe" -ArgumentList "$argz" -verb RunAs -Wait
