$DisplayGroups = @('Core Networking', 'COM+ Network Access', 'COM+ Remote Administration', 'Core Networking Diagnostics', 'DFS Management', 'Distributed Transaction Coordinator', 'File and Printer Sharing', 'Netlogon Service','Network Discovery','Remote Desktop','Remote Event Log Management','Remote Event Monitor','Remote Scheduled Tasks Management','Remote Service Management','RPC','TPM Virtual Smart Card Management','Virtual Machine Monitoring','Windows Defender Firewall Remote Managemen','Windows Management Instrumentation','Windows Remote Management - Compatibility Mode','Windows Remote Management','Windows Search')

foreach ($Group in $DisplayGroups) {
   $GetFWR =  Get-NetFirewallProfile -Name Domain | Get-NetFirewallRule -PolicyStore ActiveStore | Where-Object {($_.DisplayName -Match "$Group" -and $_.Enabled -eq "False")} 
   foreach ($FWR in $GetFWR) {
       Set-NetFirewallRule -DisplayName $($FWR.DisplayName) -Enabled 'True' -Verbose
   }
}