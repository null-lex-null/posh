#Checks common reg entries provided for Microsoft for various circumstances, and removes them to default.
#https://support.microsoft.com/en-us/help/929852/guidance-for-configuring-ipv6-in-windows-for-advanced-users
$IPV6 = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters -Name DisabledComponents -ErrorAction 0
IF ($IPV6) { Remove-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters -Name DisabledComponents -ErrorAction 0 }
