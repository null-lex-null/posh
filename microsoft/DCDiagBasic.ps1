try {
$dcdiag = Get-ChildItem -Path (Join-path $env:windir -ChildPath 'SYSTEM32') -Filter 'dcdiag.exe' -Recurse
IF($dcdiag){
$start = cmd /c "$env:windir\system32\dcdiag.exe /c /test:DNS /DNSBasic"
$start
$fail = $start | Select-String -SimpleMatch "failed test"
if($fail){Write-host "Total Failures $($fail.count):" -BackgroundColor Black -ForegroundColor Yellow;
Write-host "$fail" -BackgroundColor Black -ForegroundColor Red
}
}
}
catch {
$_
}

