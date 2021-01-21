$ErrorActionPreference = 'SilentlyContinue'
$startups = @('HKLM:\Software\Microsoft\Windows\CurrentVersion\Run', 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run', 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce', 'HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce')
foreach ($item in $startups) {
    $var = $null;
    $var = Get-Item -Path $item
    $keys = $var | Select-Object -ExpandProperty Property;
    foreach ($key in $keys) {
        IF (($key -notmatch 'VM') -and ($key -notmatch 'Defender') -and ($key -notmatch 'Citrix') -and ($key -notmatch 'Webroot') -and ($key -notmatch 'Sentinel')) { Remove-ItemProperty -Path $item -Name $key }
   
    }
    
}
$startup = "C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
Get-Item $startup -Exclude '*.ini' | Remove-Item -Recurse -Force -Verbose