#https://stackoverflow.com/questions/59106655/compare-object-remove-item-need-to-change-output-from-compare-object-in-order-to
$Path = "#CHANGELOCATION"
$MKV = Get-ChildItem -Path $($Path) -Filter '*.mkv' -Recurse
$MKV.count
$AVI = Get-ChildItem -Path $($Path) -Filter '*.avi' -Recurse
$AVI.count
$MP4 = Get-ChildItem -Path $($Path) -Filter '*.mp4' -Recurse
$mp4.count
$comparisonFileList = Compare-Object -ReferenceObject $MKV -DifferenceObject $MP4 -Property BaseName -PassThru -IncludeEqual -ExcludeDifferent
foreach ($comparisonFile in $comparisonFileList) {
  $comparisonFile
  Remove-Item -Path $comparisonFile.FullName -Force -Verbose -Confirm:$False
}
$comparisonFileList = $null
$comparisonFileList = Compare-Object -ReferenceObject $AVI -DifferenceObject $MP4 -Property BaseName -PassThru -IncludeEqual -ExcludeDifferent
foreach ($comparisonFile in $comparisonFileList) {
  Remove-Item -Path $comparisonFile.FullName -Force -Verbose -Confirm:$False
}