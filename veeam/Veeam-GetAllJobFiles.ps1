Add-PSSnapIn VeeamPSSnapIn
$jobs = @(Get-VBRJob -Name *)

for ($i = 0; $i -lt $jobs.length; $i++) {
    $backup = Get-VBRBackup -Name $jobs[$i].name
    $file = Write-Output $jobs[$i].name
    [string]$filename = Write-Output("$file" + ".txt")
    Get-VBRBackupFile -Backup $backup | Select-Object Path | Sort-Object -Property Path -Descending | Format-Table -AutoSize | Out-File -FilePath "C:\Users\$env:username\desktop\$filename" -Append
}