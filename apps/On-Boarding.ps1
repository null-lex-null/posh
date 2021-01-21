$ErrorActionPreference = 'SilentlyContinue'

#Antivirus
$Antivirus = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct
$Filtered = $Antivirus | Where-Object { $_.displayName -notin ('Webroot SecureAnywhere', 'Windows Defender') }
Write-Host "Antivirus products found: $($filtered):Attempting to remove them in a pretty forceful way, but automated, so everything...is...fine"
$Filtered | ForEach-Object {
    try {
        Get-CimInstance -ClassName Win32_Product -Filter "name like $Filtered.DisplayName" | Invoke-CimMethod -MethodName Uninstall
    }
    catch {
        Write-Output "FAILED: $($.exception.message)"
    }
}

#Update Windows Store Apps
Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | 
    Invoke-CimMethod -MethodName UpdateScanMethod

#Update MSFT Office
IF(Test-Path -Path "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"){Start-Process -FilePath "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe" -ArgumentList "/update user updatepromptuser=true forceappshutdown=true displaylevel=true" -NoNewWindow}



#Removed any IPv6 shenanigans that might exist
$IPV6 = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters -Name DisabledComponents -ErrorAction 0
IF ($IPV6) { Remove-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters -Name DisabledComponents -ErrorAction 0 }

#Start-Ups - This area checks for autoruns in the registry that you probably dont want. Remove the -Whatif to actually remove them and customize any other -excludes that you might want. 
$startups = @('HKLM:\Software\Microsoft\Windows\CurrentVersion\Run', 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run', 'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce', 'HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce')
foreach ($item in $startups) {
    $var = $null;
    $var = Get-Item -Path $item
    $keys = $var | Select-Object -ExpandProperty Property;
    foreach ($key in $keys) {
        IF (($key -notmatch 'VM') -and ($key -notmatch 'Defender') -and ($key -notmatch 'Citrix') -and ($key -notmatch 'Webroot') -and ($key -notmatch 'Sentinel')) { Remove-ItemProperty -Path $item -Name $key -WhatIf }
   
    }
    
}

#DomainFirewall Opens up firewall ports needed for various windows services. 

$DisplayGroups = @('Core Networking', 'COM+ Network Access', 'COM+ Remote Administration', 'Core Networking Diagnostics', 'DFS Management', 'Distributed Transaction Coordinator', 'File and Printer Sharing', 'Netlogon Service','Network Discovery','Remote Desktop','Remote Event Log Management','Remote Event Monitor','Remote Scheduled Tasks Management','Remote Service Management','RPC','TPM Virtual Smart Card Management','Virtual Machine Monitoring','Windows Defender Firewall Remote Managemen','Windows Management Instrumentation','Windows Remote Management - Compatibility Mode','Windows Remote Management','Windows Search')

foreach ($Group in $DisplayGroups) {
   $GetFWR =  Get-NetFirewallProfile -Name Domain | Get-NetFirewallRule -PolicyStore ActiveStore | Where-Object {($_.DisplayName -Match "$Group" -and $_.Enabled -eq "False")} 
   foreach ($FWR in $GetFWR) {
       Set-NetFirewallRule -DisplayName $($FWR.DisplayName) -Enabled 'True' -Verbose
   }
}

#Sets .net's TLS version to 1.2 so it can communicate, assuming you haven't updated your ciphers in a while. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
$version = (Get-Host).version | Out-String
$GetSource = Get-PackageSource -Name PSGallery
$list = Get-PackageProvider -ListAvailable
IF ($list.Name.Contains(!"NuGet")) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
}
IF (($version -lt 5) -and (!$GetSource)) {
    Register-PSRepository -Name PSGallery -SourceLocation 'https://www.powershellgallery.com/api/v2/' -InstallationPolicy Trusted
}
ELSE {
    IF (!$GetSource) {
        Register-PSRepository -Default -InstallationPolicy Trusted
    }
}
$NuGet = Get-PackageSource -Name Nuget -ErrorAction Continue
IF (!$Nuget) { Register-PackageSource -Name Nuget -Location "http://www.nuget.org/api/v2" -Trusted }
Install-Module PowerShellGet -MinimumVersion 2.2.4 -SkipPublisherCheck -Force -Verbose -AllowClobber
#WinGET Pulls from GitHub the latest version and installs it. Windows 10 only!

$find = Get-ChildItem -Path "$env:localappdata" -Filter 'winget.exe' -Recurse -EA 0 | Select-Object -First 1
IF ($find.Count -eq '0') {
    $baseuri = [uri]'https://github.com/microsoft/winget-cli/releases'
    $urllist = (Invoke-WebRequest -UseBasicParsing -Uri $baseuri).links.href | Select-String -SimpleMatch 'appxbundle'
    $downloadurl = 'https://github.com' + $urllist[2]
    $downloadurl = [uri]$downloadurl
    $filename = $downloadurl.Segments | Select-Object -Last 1
    $path = Join-Path -Path $env:TEMP -ChildPath $filename
    Invoke-WebRequest -Uri $downloadurl -OutFile $path
    Unblock-File -Path "$path"
    Add-AppxPackage  -Path $path
}
$data = @"
"source": {
    "autoUpdateIntervalInMinutes": 3
},
"visual": {
    "progressBar": "rainbow"
},
"experimentalFeatures": {
    "experimentalMSStore": true
},
"@
IF (!(Test-Path -Path "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json")) { Set-Content -Path "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Value "$data" }
$wingetexe = $find.FullName
try {
    Start-Process -FilePath "$wingetexe" -ArgumentList 'source update' -PassThru -Wait -NoNewWindow;
    
    Start-Process -FilePath "$wingetexe" -ArgumentList 'show' -PassThru -Wait -NoNewWindow;
}
catch {
    $_
}
  

#AppIDs are the literal application name with the --exact flag needed to install. Must be exact, MSFT is picky with things, and even when things make sense, this is a BETA product. 
$AppIDs = @("FilesUWP", "Chrome", "Intel® Driver & Support Assistant", "Microsoft Edge", "Microsoft Visual C++ 2015-2019 Redistributable (x64)", "Visual Studio Code", "Windows Admin Center", "Windows Terminal", "Notepad++", "Rufus", "7zip", "VLC media player","Adobe Acrobat Reader DC","Adobe Flash Player 32 PPAPI","Brave Browser","Corsair iCUE","Git","Git Extensions","Extreme Tuning Utility ","Azure CLI","MicrosoftGitCredentialManagerforWindows","PowerToys","BlueScreenView","JavaRuntimeEnvironment","PuTTY","RevoUninstaller","DupeGuru")

#Collect HW Info for Various Packages to Install
$ComputerCheck = (Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer
$GetGFX = (Get-CimInstance -ClassName Win32_VideoController).VideoProcessor
$Dell = 'Dell.DellUpdate'
$Lenovo = @('Lenovo.MigrationAssistant', 'Lenovo.SystemUpdate')
$NVidia = @('Nvidia.GeForceExperience', 'Nvidia.GeForceNow')
if ($computercheck -match "Dell") { $AppIDs = $AppIDs + $Dell }
if ($computercheck -match "Lenovo") { $AppIDs = $AppIDs + $Lenovo }
if ($GetGFX -match "NVIDIA") { $AppIDs = $AppIDs + $NVidia }


try {
    FOREACH($appID in $AppIDs){
Start-Process "winget.exe" -ArgumentList "install ""$AppID"" -e -h -o ""$env:temp\wingetinstall.log""" -Verb RunAs -Wait -Verbose
    }
    }

catch {
    Write-Output $_Exception.Message

}
finally {
Write-Host "This script is done meow..."
}