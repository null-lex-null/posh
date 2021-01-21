#Requires -RunAsAdministrator
$Root = "\\xgp\shares\XGPRF"
$ClientRDSGroup = "$env:USERDOMAIN\RemoteUsers"
$Paths = Get-ChildItem $Root | Select-Object -Property Name, FullName

#Global Per User/Folder Security Accounts 
#("Username","AccessLevel","InheritanceFlags","PropogationFlags","AccessControlType")
$DomainAdminAR = New-Object system.security.accesscontrol.filesystemaccessrule("$env:USERDOMAIN\Domain Admins", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$SystemAR = New-Object system.security.accesscontrol.filesystemaccessrule("SYSTEM", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$CreatorOwnerAR = New-Object system.security.accesscontrol.filesystemaccessrule("CREATOR OWNER", "FullControl", "ContainerInherit, ObjectInherit", "InheritOnly", "Allow")
$BuiltinAdminAR = New-Object system.security.accesscontrol.filesystemaccessrule("BUILTIN\Administrators", "FullControl", "None", "None", "Allow")
$WACAR = New-Object system.security.accesscontrol.filesystemaccessrule("$env:USERDOMAIN\Windows Admin Center Administrators", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")

#$HostingServerAdminAR = New-Object system.security.accesscontrol.filesystemaccessrule("$env:USERDOMAIN\HostingServerAdmin","FullControl","ContainerInherit, ObjectInherit","None","Allow")
$HostingClientRDSGroup = New-Object system.security.accesscontrol.filesystemaccessrule("$ClientRDSGroup", "AppendData, Read, Synchronize", "None", "None", "Allow")

foreach ($Folder in $Paths) {

    Write-Host "Generating ACL for $($folder.FullName) ... "
    #For error handling purposes - not all folders will map to a user of the exact same name, this makes them easier to handle when viewing the output.
    

    $ACL = New-Object System.Security.AccessControl.DirectorySecurity
    #Creates a blank ACL object to add access rules into, also blanks out the ACL for each iteration of the loop.
    $objUser = New-Object System.Security.Principal.NTAccount("$env:USERDOMAIN\" + $folder.name)

    #Added this in case you throw redirected folders into the same folder as redirected profiles. There might be .V4 and .V5 as well. 
    IF ($folder.name -match '.V6') {
        $folder.name = $folder.name -replace '.V6', '';
        $objUser = New-Object System.Security.Principal.NTAccount("$env:USERDOMAIN\" + $folder.name)
    }
    

    #Creating the right type of User Object to feed into our ACL, and populating it with the user whose folder we're currently on.

    $UserAR = New-Object system.security.accesscontrol.filesystemaccessrule( $objuser , "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
    #Access Rule for the user whose folder we're dealing with during this iteration.

    $acl.SetOwner($objUser)
    $acl.SetAccessRuleProtection($true, $false)
    #Change the inheritance/propagation settings of the folder we're dealing with

    $acl.SetAccessRule($UserAR)
    $acl.SetAccessRule($DomainAdminAR)
    $acl.SetAccessRule($SystemAR)
    $acl.SetAccessRule($CreatorOwnerAR)
    $acl.SetAccessRule($BuiltInAdminAR)
    $acl.SetAccessRule($WACAR)
    $acl.SetAccessRule($HostingClientRDSGroup)

    Write-Host "Changing ACL on $($folder.FullName) to:"
    $acl | Format-List
    #For error handling purposes - not all folders will map to a user of the exact same name, this makes them easier to handle when viewing the output.

    Set-Acl -Path $Folder.Fullname -AclObject $acl

   
   

}