$ErrorActionPreference = 'SilentlyContinue'
$source = "#CHANGESOURCE"
$destination = "#CHANGEDESTINATION"
$exclude = Get-ChildItem -Path $destination -Recurse -Force
(Get-ChildItem -Path $source -Recurse).Count
Get-ChildItem -Path $source | Copy-Item -Destination $destination -Recurse -Verbose -Force -Exclude $exclude -PassThru
(Get-ChildItem -Path $destination -Recurse).Count