#$Result = "[SQL-HEADER];HostName;SQLInstance;SQLHostName;Edition;Version"

$list = Get-ChildItem -Path 'HKLM:\Software\Microsoft\Microsoft SQL Server\Instance Names' | Select-Object Property
IF ($list.property.count -gt 1) {
    for ($i = 0; $i -lt $list.property.Count; $i++) {
        $instances = Get-ChildItem -Path 'HKLM:\Software\Microsoft\Microsoft SQL Server\' | Where-Object { ($_ -match $list.property[$i]) } 
        Write-Host $Instances.name | Where-Object { $_ -match "MSSQL??.'$($list.property)'" }
    }

}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      


$instances = Get-ChildItem -Path 'HKLM:\Software\Microsoft\Microsoft SQL Server\' | Where-Object { ($_ -match $list.property) -and ($_ -match 'MSSQL') } 
Write-host $Instances.name | ? {$_ -match "MSSQL??.'$($list.property)'"}

foreach ($instance in $instances) {
    $newreg = $instance.Name -replace "HKEY_LOCAL_MACHINE", "HKLM:";
    $newreg = $newreg + '\Setup';
    $short = $instance.name.Split('\') | Select-Object -Last 1
   
    $edition = (Get-ItemProperty -Path $newreg -Name Edition).Edition 
    $version = (Get-ItemProperty -Path $newreg -Name Version).Version  
    
    IF ($version -contains "14*") { $versionname = "SQL Server 2017"; }
    IF ($version -contains "13*") { $versionname = "SQL Server 2016"; }
    IF ($version -contains "12*") { $versionname = "SQL Server 2014"; }
    IF ($version -contains "11*") { $versionname = "SQL Server 2012"; }
    IF ($version -contains "10.5*") { $versionname = "SQL Server 2008 R2"; }
    IF ($version -contains "10.4*") { $versionname = "SQL Server 2008"; }
    IF ($version -contains "10.3*") { $versionname = "SQL Server 2008"; }
    IF ($version -contains "10.2*") { $versionname = "SQL Server 2008"; }
    IF ($version -contains "10.1*") { $versionname = "SQL Server 2008"; }
    IF ($version -contains "10.0*") { $versionname = "SQL Server 2008"; }
    IF ($version -contains "9*") { $versionname = "SQL Server 2005"; }
    IF ($version -contains "8*") { $versionname = "SQL Server 2000"; }
    
    Write-Host "$ENV:COMPUTERNAME;" "$short;" "$edition;" "$versionname"
}

