cmd /c "cmdkey.exe /list"
$targets = cmd /c "cmdkey.exe /list" | Select-String -SimpleMatch "Target" 
$targets = $targets -replace 'Target: ', ''
foreach ($target in $targets) {
    cmd /c "cmdkey.exe /delete:$target"
}
Write-Host "Anything below this is still on the system"
cmd /c "cmdkey.exe /list"