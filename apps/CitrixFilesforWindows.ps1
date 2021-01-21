$folder = "$env:temp"
$baseurl = 'https://www.citrix.com/downloads/citrix-content-collaboration/product-software/citrix-files-for-windows.html'
$progressPreference = 'silentlyContinue'
$msi = (Invoke-WebRequest "$baseurl").links | Select-Object { $_.rel } | Where-Object { $_ -match '.msi' }
$progressPreference = 'Continue'
[uri]$url = Write-Output("https:$($msi.' $_.rel ')")
$filename = $url.Segments[3]
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
Unblock-File -Path $target -EA 0

$MSIArguments = @(
    "/i"
    "$target"
    "/qn"
    "/norestart"
)
Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Verb RunAs -Wait