[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
$uri = [uri]"https://github.com/PowerShell/PowerShell"
$msi = (Invoke-WebRequest -Uri "$uri" -UseBasicParsing).links.href | select-string -SimpleMatch 'x64.msi' | select-string -NotMatch 'preview' | Sort-Object -Descending | Select-Object -First 1
$msi = [string]$msi
$msi = [uri]$msi
$filename = $msi.Segments | Select-Object -Last 1
$target = (Join-Path -Path $env:temp -ChildPath $filename)
(New-Object Net.WebClient).DownloadFile($($msi.AbsoluteUri), "$target")
Unblock-File $target
$MSIArguments = @(
    "/i"
    "$target"
    "/qn"
    "/norestart"
)
Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Verb RunAs -Wait