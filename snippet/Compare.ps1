$jobs = @(Get-ChildItem -Path "C:\Users\$env:username\desktop\jobs\")
$repo = Get-ChildItem -Path "C:\Users\$env:username\desktop\repo\"
$location = ("C:\Users\$env:username\desktop\target\" + 'TheDifference.txt')

foreach ($job in $jobs) {
    $compare = Compare-Object (Get-Content $job.FullName) (Get-Content $repo[0].FullName) -ExcludeDifferent | Format-List
    if ($compare) {
        Write-Out("$compare") | Out-File $Location -Append
    
    }
}
