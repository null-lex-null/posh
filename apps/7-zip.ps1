[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
$fqdn = 'https://www.7-zip.org/'
$uri = [uri]"$fqdn"
try {
    $file = (Invoke-WebRequest -Uri $uri.AbsoluteUri -UseBasicParsing).links.href | Select-String -SimpleMatch 'x64.exe' | Select-Object -First 1
    $fileurl = $fqdn + $file
    $fileurl = [uri]"$fileurl"
    $filename = $fileurl.Segments | Select-Object -Last 1
    $path = "$env:temp" + '\' + "$filename"
    (New-Object Net.WebClient).DownloadFile("$fileurl", "$path")
    IF (Test-Path -LiteralPath $path) { Start-Process "$path" -Verb RunAs -ArgumentList "/S" -Wait }  
}
catch {
    $_
}
