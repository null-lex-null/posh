$check = Get-Module -Name MSOnline
IF (!($check)) { Install-Module -Name MSOnline -Force -Verbose }
$credential = Get-Credential
Connect-MsolService -Credential $credential
$UPNS = Get-MsolUser | Select-Object UserPrincipalName
foreach ($UPN in $UPNS) {
    Set-MsolUserPassword -UserPrincipalName $UPN.UserPrincipalName -NewPassword 'Tofu1337#' -ForceChangePassword $true
}