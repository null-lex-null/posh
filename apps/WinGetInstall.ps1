[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
$find = Get-ChildItem -Path "$env:localappdata" -Filter 'winget.exe' -Recurse -EA 0 | Select-Object -First 1
IF ($find.Count -eq '0') {
    $baseuri = [uri]'https://github.com/microsoft/winget-cli/releases'
    $urllist = (Invoke-WebRequest -UseBasicParsing -Uri $baseuri).links.href | Select-String -SimpleMatch 'appxbundle'
    $downloadurl = 'https://github.com' + $urllist[2]
    $downloadurl = [uri]$downloadurl
    $filename = $downloadurl.Segments | Select-Object -Last 1
    $path = Join-Path -Path $env:TEMP -ChildPath $filename
    Invoke-WebRequest -Uri $downloadurl -OutFile $path
    Unblock-File -Path "$path"
    Add-AppxPackage -Path $path
}
$data = @"
"source": {
    "autoUpdateIntervalInMinutes": 3
},
"visual": {
    "progressBar": "rainbow"
},
"experimentalFeatures": {
    "experimentalMSStore": true
},
"@
IF (!(Test-Path -Path "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json")) { Set-Content -Path "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Value "$data" }
$wingetexe = $find.FullName
try {
    #Update Winget Source
    Start-Process -FilePath "$wingetexe" -ArgumentList 'source update' -PassThru -Wait -NoNewWindow;
    #Shows apps available to install and exports to CSV on desktop. Not perfect, but OK for now
    cmd /c "$($wingetexe) show | clip"
    $apps = @(Get-Clipboard)
    $apps = $apps -replace '\s\s+', ","
    Write-Output ($apps) | Out-File $env:temp\WinGetApps.csv
    $wingetvar = @(Import-Csv $env:temp\WinGetApps.csv -Header Name, Id, Version; )
    $wingetvar | Export-Csv -Path $env:userprofile\Desktop\WinGetApps.csv
}
catch {
    $_
}