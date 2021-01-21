#Trying to make a quasi-universal application script. This is one of the many iterations
$ApplicationName = '#ApplicationNameHere'
$32Bit = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\' 
$64Bit = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'
$InstalledSoftware = Get-ChildItem $32Bit, $64Bit | Get-ItemProperty | Where-Object { $_.DisplayName -Match $ApplicationName -or $_.Comments -Match $ApplicationName }
IF ($InstalledSoftware.Count -gt 1) { $InstalledSoftware = $InstalledSoftware[0] }
$Quiet = $InstalledSoftware.QuietUninstallString
$UninstallString = $InstalledSoftware.UninstallString
IF ($Quiet) {
    cmd /c  $Quiet
}
IF ($UninstallString -match 'MSIEXEC.exe /I') { Write-Output $UninstallString -replace "MSIEXEC.exe /I", "MSIEXEC.EXE /X" }
IF ($UninstallString -match 'MSIEXEC.exe /X') { Start-Process "$env:comspec" -ArgumentList "/c $UninstallString /quiet /qn /noreboot" }
IF ($UninstallString -match '.exe') {    
    try {
        Start-Process "CMD" -ArgumentList "/c $UninstallString /S" -Verb RunAs -Wait
    }    
    catch {
        Write-Host $_
    }
    try {
        Start-Process "CMD" -ArgumentList "/c $UninstallString" -Verb RunAs -Wait
    }    
    catch {
        Write-Host $_
    }
    finally {
        $InstalledSoftware = Get-ChildItem $32Bit, $64Bit | Get-ItemProperty | Where-Object DisplayName -Match $ApplicationName;
        Write-Host "$($InstalledSoftware.count) Instances of $ApplicationName have been found!"
    }
}
