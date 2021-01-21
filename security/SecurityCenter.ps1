$Antivirus = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct
$Filtered = $Antivirus | Where-Object { $_.displayName -notin ('Webroot SecureAnywhere', 'Windows Defender') }

$Filtered | ForEach-Object {
    try {
        Get-CimInstance -ClassName Win32_Product -Filter "name like $Filtered.DisplayName" | Invoke-CimMethod -MethodName Uninstall
    }
    catch {
        Write-Output "FAILED: $($.exception.message)"
    }
}



#ThisBelowCommandDoesTheSameAsTheAbove...I try too hard sometimes :/
$AV = (Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct | Select-Object -property displayName | Where-Object -Property DisplayName -notin ('Webroot SecureAnywhere','Windows Defender')).DisplayName

$UninstallString = GCI ("HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall","HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall") 

$uninstall32 = gci "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match $AV } | select UninstallString
$uninstall64 = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "$" } | select UninstallString

if ($uninstall64) {
$uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall64 = $uninstall64.Trim()
Write "Uninstalling..."
start-process "msiexec.exe" -arg "/X $uninstall64 /qb" -Wait}
if ($uninstall32) {
$uninstall32 = $uninstall32.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
$uninstall32 = $uninstall32.Trim()
Write "Uninstalling..."
start-process "msiexec.exe" -arg "/X $uninstall32 /qb" -Wait}