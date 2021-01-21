$gateway = "$ENV:COMPUTERNAME" # Machine where Windows Admin Center is installed
$gatewayObject = Get-ADComputer -Identity $gateway
Get-ADComputer -Filter { OperatingSystem -Like '*Windows*' } | Set-ADComputer -PrincipalsAllowedToDelegateToAccount $gatewayObject