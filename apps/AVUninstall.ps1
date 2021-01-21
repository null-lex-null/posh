$folder = "$env:temp"
$url = [uri]'https://download.eset.com/com/eset/tools/installers/av_remover/latest/avremover_nt64_enu.exe'
$filename = $url.Segments | select -last 1
$filepath = Join-Path $folder $filename

try {
    $progressPreference = 'silentlyContinue'
    $response = Invoke-WebRequest -Uri "$URL" -OutFile $filepath -ErrorAction Stop
    $progressPreference = 'Continue'
    # This will only execute if the Invoke-WebRequest is successful.
    $StatusCode = $Response.StatusCode
}
catch {
    $StatusCode = $_.Exception.Response.StatusCode.value__
}
$StatusCode
try {
  IF(Test-Path -Path $filepath){Start-Process "$ENV:COMSPEC" -ArgumentList "/C $filepath --silent --accepteula " -Verb RunAs -wait}
}
catch {
    $_
}

$AV = (Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct | Select-Object -property displayName | Where-Object -Property DisplayName -notin ('Webroot SecureAnywhere','Windows Defender')).DisplayName

IF (!(Get-PSDrive -Name Uninstall64 -ErrorAction SilentlyContinue)) { New-PSDrive -Name Uninstall64 -PSProvider Registry -Root HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall }
IF (!(Get-PSDrive -Name Uninstall32 -ErrorAction SilentlyContinue)) { New-PSDrive -Name Uninstall32 -PSProvider Registry -Root HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall }
$UninstallableApplications = Get-ChildItem -Path @("Uninstall64:","Uninstall32:")
$myapp = $UninstallableApplications | Where-Object -FilterScript {
    $_.GetValue("DisplayName") -match "$AV[0]"
  }
  $myapp



$svcs = GCI -path "HKLM:\SYSTEM\CurrentControlSet\Services" | Select -property * | ? {$_.Name -match 'Norton'}