$URL = [uri]'https://anywhere.webrootcloudav.com/zerol/wsasme.exe'
$folder = "$env:temp"
$serialnumber = Read-Host -Prompt "Please paste serial number with no spaces"
$filename = "Get-Host"
$target = $folder + $filename + '.exe'
$WRSA = Get-Process -Name WRSA
$WRSVC =  Get-Service -Name WRSVC
if((!$WRSA -and !$WRSVC) -or !$WRSVC){
    Invoke-WebRequest -Uri $url -OutFile $target
    $test = Test-Path -Path $target
    if($test){Start-Process $($target) -ArgumentList "/silent /exeshowaddremove" -Verb RunAs -Wait}
}