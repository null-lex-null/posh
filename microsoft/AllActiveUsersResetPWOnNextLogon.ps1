$Users = Get-ADUser -Filter '*' | Select-Object Enabled, SamAccountName 
foreach ($user in $users) {
    if ($user.Enabled -eq 'TRUE') {
        Set-ADUser -Identity $user.SamAccountName -ChangePasswordAtLogon $true
    }
}
