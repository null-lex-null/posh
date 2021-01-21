$Antivirus = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct
$Filtered = $Antivirus | Where-Object { $_.displayName -notin ('Webroot SecureAnywhere', 'Windows Defender') }
$Services = Get-Service | ? {$_.DisplayName -match "$Filtered.DisplayName[0]"}