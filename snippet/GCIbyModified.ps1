$folder = "C:\Users\$env:USERNAME\Desktop\"
$date = Get-Date -Format MM-dd-yyyy
$ext = '.txt'

$GetDrive = Get-PSDrive | Select-Object -Property * | Where-Object Provider -Match "FileSystem"
$filename = $env:computername + $date + $ext
$name = $GetDrive.Name
$full = $folder + $filename
$roots = $GetDrive.Root

foreach ($root in $roots) {
    $path = Write-Output("$root" + 'Backups\')
    $backup = Test-Path -Path $path


    if ($backup -eq "True") {
        $count = (Get-ChildItem -Path $root -Include @("*.vbk", "*.vib", "*.vbm") -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddMonths(-3) }).Count
        $files = (Get-ChildItem -Path $root -Include @("*.vbk", "*.vib", "*.vbm") -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddMonths(-3) })
        #Unhash the Variable Below to actually delete the files
        #$Delete = (Get-ChildItem -Path F:\Backups -Include @('*.vbk', '*.vib', '*.vbm') -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddMonths(-3) } | Remove-Item -Verbose)
        Write-Output $count | Out-File -FilePath $full -Append
        Write-Output $files | Out-File -FilePath $full -Append
        Write-Output $files.Name | Out-File -FilePath ($folder + $env:computername + 'PathVar' + $ext) -Append    
    }

}