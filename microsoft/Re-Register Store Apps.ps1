#Re-Register Store Apps
#Requires -RunAsAdministrator
$APPX = Get-ChildItem -Path 'C:\Windows\SystemApps'  -Filter 'AppXManifest.xml' -Recurse -Force
foreach($app in $appx){
    Start-Process "powershell.exe" -ArgumentList "Add-AppxPackage -Register -DisableDevelopmentMode ""$($app.FullName)""" -Wait -NoNewWindow
}