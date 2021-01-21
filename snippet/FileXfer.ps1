$source = "#CHANGEME"
$destination = "#CHANGEME"
(Get-ChildItem -Path $source -Recurse).Count
Get-ChildItem -Path $source | Copy-Item -Destination $destination -Recurse -Verbose -Force -PassThru -ErrorAction SilentlyContinue
(Get-ChildItem -Path $destination -Recurse).Count