$url = [uri]"http://definitionupdates.microsoft.com/download/definitionupdates/safetyscanner/amd64/msert.exe"
$folder = $env:TEMP
$filename = $url.Segments | Select-Object -Last 1
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
Start-Process $target -ArgumentList "/Q /F:Y" -Wait -Verb RunAs