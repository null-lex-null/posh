$result1 = Get-FolderSize -BasePath D:\Shares\ | Where-Object 'Size(GB)' -GT 2.00
$result1 | Format-Table -Property FolderName, Size(GB), FullPath -AutoSize | Out-String -Width 4096 | Out-File -FilePath $env:temp\result1.txt
$folderarray = $result1.FullPath  
foreach ($folder in $folderarray) {

  $array = Get-FolderSize -BasePath $folder | Where-Object 'Size(GB)' -GT 2.00  
  $array | Format-Table -Property FolderName, Size(GB), FullPath -AutoSize | Out-String -Width 4096 | Out-File -Append $env:temp\result1.txt
    
}
