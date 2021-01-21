#Requires -RunAsAdministrator
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
#Use the below if the above commands don't work, might fix later to include oldish versions of Windows/PoSH
#Invoke-Command -ScriptBlock { cmd /c dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart }
#Invoke-Command -ScriptBlock { cmd /c dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart }
#Downloads WinGet Preview from github
$folder = "$env:temp"
$base = 'https://github.com'
$url = '/microsoft/winget-cli/releases'
$baseurl = Write-Output ("$base" + "$url")
$baseurl = [uri]"$baseurl"
$msi = (Invoke-WebRequest "$baseurl" -UseBasicParsing).links -match "download" | Select-Object href -Skip 1 -First 1
$string = $msi.href | Out-String
[uri]$newurl = ($base + $string)
#$count = $newurl.segments.count
$filename = $newurl.Segments | Select-Object -Last 1
$target = Join-Path $folder $filename 
try {
    $progressPreference = 'silentlyContinue'
    $response = Invoke-WebRequest -Uri $newurl.absoluteuri -OutFile $target -ErrorAction Stop
    $progressPreference = 'Continue'
    # This will only execute if the Invoke-WebRequest is successful.
    $StatusCode = $Response.StatusCode
}
catch {
    $StatusCode = $_.Exception.Response.StatusCode.value__
}
$StatusCode

Unblock-File -Path "$target"
Add-AppxPackage -Path $target
Write-Host "WinGet SHOULD be installed now" -BackgroundColor Black -ForegroundColor Green
try {
    Write-Host "Trying to update as Administrator" -BackgroundColor Black -ForegroundColor Green
    Start-Process "winget.exe" -ArgumentList "source update" -Verb RunAs -Wait -EA 0
}
catch {
    Write-Output $_Exception.Message
}
Start-Process "winget" -ArgumentList "install -q Ubuntu -h" -Wait -NoNewWindow
#Lists WSL Versions
Start-Process "wsl" -Wait -EA 0
wsl -l -v
$progressPreference = 'silentlyContinue'
$kernelupdate = [uri]"https://docs.microsoft.com/en-us/windows/wsl/wsl2-kernel"
$kernellinks = ((Invoke-WebRequest -Uri $kernelupdate).links).href
$progressPreference = 'Continue'
$link = $kernellinks | Select-String -SimpleMatch "wsl_update_x64.msi" | Out-String
$link = [uri]"$link"
$filename = $link.segments[2]
$progressPreference = 'silentlyContinue'
Invoke-WebRequest -Uri $link -OutFile $($env:temp)\$($filename)
$progressPreference = 'Continue'
Start-Process "$env:ComSpec" -ArgumentList "/C $($env:temp)\$($filename) /qn /noreboot" -Verb RunAs -Wait
Start-Process "wsl" -ArgumentList "--set-default-version 2" -Verb RunAs -Wait -EA 0
wsl -l -v