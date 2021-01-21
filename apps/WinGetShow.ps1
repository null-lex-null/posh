#Checks to see if winget is installed anywhere on the System Drive. Its usually under a user profile, so IF you have permission, this SHOULD work ;)
$winget = Get-ChildItem -Path $env:SystemDrive -Filter 'winget.exe' -Recurse -EA 0
#$winget = $winget[0].FullName
#Start-Process $winget -ArgumentList "source update" -PassThru -NoNewWindow -Wait -EA 0
if ($winget) { Invoke-Command -ScriptBlock { cmd /c winget show | CLIP } }
$apps = @(Get-Clipboard)
$apps = $apps -replace '\s\s+', ","
Write-Output ($apps) | Out-File $env:userprofile\desktop\WinGetApps.csv
$wingetvar = @(Import-Csv $env:userprofile\Desktop\WinGetApps.csv -Header Name, Id, Version;)
#$wingetvar is the variable that you can use to query name,id's and versions programatically
$wingetvar | Export-Csv -Path $env:userprofile\Desktop\WinGetApps.csv