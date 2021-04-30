try {
    $drives = (Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq "3" }).DeviceId
    foreach ($drive in $drives) {
        cmd /c "fsutil dirty query $drive"
    }
}
catch {
    $_  
}