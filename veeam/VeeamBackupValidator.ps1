$VBV = Get-ChildItem -Path 'C:\Program Files\Veeam\Backup and Replication\Backup' -Filter 'Veeam.Backup.Validator.exe'
Add-PSSnapin VeeamPSSnapIn
$JobNames = (Get-VBRJob -Name *)
FOREACH ($job in $jobnames) {
    $Name = ($Job).Name
    Write-Host Job: $Name
    Start-Process $VBV.FullName -ArgumentList "/Backup:$Name /report:$($env:temp)\VeeamReport-$Name-$(Get-Date -Format MM.dd.yyyy).html /date:$(Get-Date -Format MM.dd.yyyy)" -Verb RunAs -Wait 
}

