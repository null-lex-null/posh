#Requires -RunAsAdministrator
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
Write-Host "Checking Powershell Version" -BackgroundColor White -ForegroundColor DarkGreen
$version = (Get-Host).version.major | Out-String
if ($version -lt '5') { Write-Host "You should update your powershellz"; Exit }
$GetSource = Get-PackageSource -Name PSGallery
Write-Host "Checking to see if Nuget is registered, if not, registering" -BackgroundColor White -ForegroundColor DarkGreen
$list = Get-PackageProvider -Name 'Nuget'
IF (!$list) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Register-PackageSource -Name NuGet -Location https://www.nuget.org/api/v2 -ProviderName NuGet -Trusted
}
IF (($version -lt 5) -and (!$GetSource)) {
    Register-PSRepository -Name PSGallery -SourceLocation 'https://www.powershellgallery.com/api/v2/' -InstallationPolicy Trusted
}

IF (!$GetSource) {
    Register-PSRepository -Default -InstallationPolicy Trusted
}


$GM = Get-InstalledModule
if ($GM.name -notcontains 'PowerShellGet') {
    Install-Module PowerShellGet -MinimumVersion 2.2.4 -SkipPublisherCheck -Force -Verbose -AllowClobber
}
if ($GM.name -notcontains 'PSWindowsUpdate') {
    Install-Module PSWindowsUpdate -Force -Verbose
}
Write-Host "Checking OS version, and if Windows 10, will check for Windows Store App updates" -BackgroundColor White -ForegroundColor DarkGreen
IF ((Get-ComputerInfo).WindowsProductName -match 'Windows 10') { Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod }
Write-Host "Checking for Office 365 Updates if detected" -BackgroundColor White -ForegroundColor DarkGreen
IF (Test-Path -Path "$ENV:ProgramFiles\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe") { Start-Process -FilePath "$ENV:ProgramFiles\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe" -ArgumentList "/update user updatepromptuser=true forceappshutdown=true displaylevel=true" -NoNewWindow -Wait }
Write-Host "Getting installed modules, then updating them..." -BackgroundColor White -ForegroundColor DarkGreen
Get-InstalledModule | ForEach-Object {Update-Module -Name $_.Name -Confirm:$false -Verbose -Force}
Import-Module PSWindowsUpdate
Get-WUList -AcceptAll -AutoReboot -Install -MicrosoftUpdate -Confirm:$false
Get-WUHistory -Last 10 -Confirm:$false | Format-Table -AutoSize -Wrap
