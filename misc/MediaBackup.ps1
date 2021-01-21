[array]$media = @("N:\","T:\","M:\")

$music = "N:\"
$tv = "T:\"
$movies = "M:\"
$backup1 = "B:\Movies"
$backup2 = "B:\TV"
$backup3 = "B:\Music"
(Get-ChildItem -Path $movies -Recurse).Count
Get-ChildItem -Path $movies | Copy-Item -Destination $backup1 -Recurse -Force -PassThru
Write-Host $($movies.FullName)
Get-ChildItem -Path $tv | Copy-Item -Destination $backup2 -Recurse -Force -PassThru
Write-Host $($tv.FullName)
Get-ChildItem -Path $music | Copy-Item -Destination $backup3 -Recurse -Force -PassThru
Write-Host $($music.FullName)
(Get-ChildItem -Path $backup -Recurse).Count


$Source = Get-ChildItem -Path C:\SourceFolder -Recurse | Select -ExpandProperty FullName
$Destination = 'C:\DestinationFolder'
foreach ($Item in @($Source)){
    #starting job for every item in source list
    Start-Job -ScriptBlock {
        param($Item,$Destination) #passing parameters for copy-item 
            #doing copy-item
            Copy-Item -Path $Item -Destination $Destination -Recurse  -Force
    } -ArgumentList $Item,$Destination #passing parameters for copy-item 
}