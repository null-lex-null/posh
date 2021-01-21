$folder = "$env:temp"
$baseurl = 'https://github.com/PowerShell/PowerShell'
$progressPreference = 'silentlyContinue'
$msi = (Invoke-WebRequest "$baseurl").links | Select-Object { $_.href } | findstr "msi"
$progressPreference = 'Continue'
[uri]$url = $msi[0]
$filename = $url.Segments[6]
$target = Join-Path $folder $filename 

try {
    $progressPreference = 'silentlyContinue'
    $response = Invoke-WebRequest -Uri "$URL" -OutFile $target -ErrorAction Stop
    $progressPreference = 'Continue'
    # This will only execute if the Invoke-WebRequest is successful.
    $StatusCode = $Response.StatusCode
}
catch {
    $StatusCode = $_.Exception.Response.StatusCode.value__
}
$StatusCode