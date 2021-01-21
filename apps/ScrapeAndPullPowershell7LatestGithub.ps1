[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
$uri = [uri]"https://github.com/PowerShell/PowerShell"
$msi = (Invoke-WebRequest "$uri" -UseBasicParsing).links.href | Select-String -SimpleMatch 'msi'
$msi = $msi | Sort-Object -Descending | Select-String -NotMatch 'preview'
$msi = $msi | Select-String -SimpleMatch 'x64' | Select-Object -First 1
$msi = [string]$msi
$msi = [uri]$msi
$filename = $msi.Segments | Select-Object -Last 1
$target = (Join-Path -Path $env:temp -ChildPath $filename)
Invoke-WebRequest -Uri $msi -OutFile $target -UseBasicParsing
Unblock-File $target
$MSIArguments = @(
    "/i"
    "$target"
    "/qn"
    "/norestart"
)
Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Verb RunAs -Wait