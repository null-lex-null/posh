$SysEvent = Get-Eventlog -Logname system -Newest 2000 
$SysError = $SysEvent | Where {$_.entryType -Match "Error" -or $_.entryType -Match "Critical"}
$SysError | Sort-Object EventID -Unique | Format-Table EventID, Source, Message -auto