    $User = "Domain01\User01"
    $PWord = ConvertTo-SecureString -String "P@sSwOrd" -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord