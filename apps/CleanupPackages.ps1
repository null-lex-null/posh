#I Wouldn't Run this, just testing to see if I can create something to reset packages back to 'normal' in any environment. 

$packages = Get-PackageProvider
foreach ($package in $packages) {
    $Latest = Get-InstalledModule -Name $package.name; Get-InstalledModule -Name $package.name -AllVersions | Where-Object { $_.Version -ne $Latest.Version } | Uninstall-Module
}

$packages = (Get-Package -Name "PSWindowsUpdate")
foreach ($package in $packagesrs) {
    Get-Package -Name $package.name -AllVersions | Where-Object { $_.Version -ne $package.Version } | Uninstall-Package 
    
}
$Latest = Get-PackageProvider; Get-InstalledModule (modulename) -AllVersions | Where-Object { $_.Version -ne $Latest.Version } | Unregister-PackageSource -Provider-WhatIf


$packages = Get-Package
foreach ($package in $packages) {
    $Latest = Get-InstalledModule -Name $package.name; Get-InstalledModule -Name $package.name -AllVersions | Where-Object { $_.Version -cne $Latest.Version } | Uninstall-Module -WhatIf
}
$Latest = Get-InstalledModule -Name PSWindowsUpdate; Get-InstalledModule -Name PSWindowsUpdate -AllVersions | Where-Object { $_.Version -cne $Latest.Version } | Uninstall-Module -WhatIf