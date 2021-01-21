$uri = [uri]'https://github.com/Open-Shell/Open-Shell-Menu/releases'
$request = Invoke-WebRequest -Uri $uri -UseBasicParsing
$findlatest = ($request).links.href | Select-String -SimpleMatch 'OpenShellSetup' | Select-Object -First 1
$download = [uri]('https://github.com' + $findlatest)
$file = $download.segments | Select-Object -Last 1
$path = Join-Path -Path "$env:temp" -ChildPath "$file"
Invoke-WebRequest -Uri $download.AbsoluteUri -UseBasicParsing -OutFile $path
Start-Process "$path" -ArgumentList "/qn ADDLOCAL=ClassicExplorer" -Wait -Verb RunAs