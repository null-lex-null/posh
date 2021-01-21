#List GPOs and their permissions that are set. One via a report and one via simple txt file and exports files into temp directory subfolder
$gpo = (Get-GPO -All)
if(!(Test-Path -Path $env:temp\GPOs)){
    New-Item -Path $env:temp\GPOs -Force -ItemType Directory
}

foreach ($gp in $gpo) {
    Write-Output "Group Policy: $($gp.DisplayName)" | Out-File -FilePath $env:temp\GPOs\$($gp.Displayname)-Permission.txt
    Get-GPO -Guid $gp.id.guid | Get-GPPermission -All | Out-File -FilePath $env:temp\GPOs\$($gp.Displayname)-Permission.txt -Append
    $gp.GenerateReport(1) | Out-File -FilePath $env:temp\GPOs\$($gp.Displayname).html
    Backup-GPO -Guid $gp.Id -Path "$env:temp\GPOs"
}
Compress-Archive -Path "$env:temp\GPOs\*" -DestinationPath "$env:temp\GPOs.zip"