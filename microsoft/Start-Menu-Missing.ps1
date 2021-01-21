$sfolder = 'C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\'
$sfiles = GCI -path "$sfolder" -Recurse -Filter '*.lnk'
Write-Host "Start-Menu Shortcuts: $($sfiles.count)"
foreach($file in $sfiles){
    Get-Content $file | Select-String -Pattern '%*.*'
}
