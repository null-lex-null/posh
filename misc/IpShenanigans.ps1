#Requires -Version 7
#ForParallelReasons
#This only works on /24 network because I didn't feel like reinventing the wheel as there are better solutions for this, I just wanted to test parallism and performance scanning a network. 
$logfile = Join-Path -Path "$env:HOMESHARE" -ChildPath '\Desktop\NetworkScan.txt'
Start-Transcript -Path $logfile
Measure-Command {
    $WarningPreference = 'SilentlyContinue'
    $ErrorActionPreference	= 'SilentlyContinue'
    
    Invoke-Command -ScriptBlock {
        $ipaddress = Get-NetIPAddress -AddressFamily IPv4 | Select-Object PrefixOrigin, IPv4Address, PrefixLength | Where-Object { $_.PrefixOrigin -eq 'DHCP' }
        IF ($ipaddress.PrefixLength -eq '24') { 
            1..254 | ForEach-Object -parallel {
                $ipaddress = Get-NetIPAddress -AddressFamily IPv4 | Select-Object PrefixOrigin, IPv4Address, PrefixLength | Where-Object { $_.PrefixOrigin -eq 'DHCP' }
                $LANStart = ((($ipaddress.IPv4Address).Split('.') | Select-Object -First 3) -join '.')
                $IP = $LANStart + '.' + "$_"
                $TestNC = Test-NetConnection -ComputerName "$ip" -InformationLevel "Detailed" 
                IF ($TestNC.PingSucceeded -eq 'True') {
                    $hostname = (Resolve-DnsName "$ip").NameHost
                    IF ($hostname) { Write-Host "$($hostname) is Online" -ForegroundColor DarkGreen -BackgroundColor Black }
                    ELSE { Write-Host "$LANStart.$_ is Online" -ForegroundColor DarkGreen -BackgroundColor Black }
                
                    $commonports = @('20', '21', '22', '25', '53', '67', '80', '88', '123', '135', '139', '389', '443', '445', '464', '636', '3389')
                    foreach ($port in $commonports) {
                        $TestPC = Test-NetConnection -ComputerName "$ip" -Port $port
                        if ($TestPC.TcpTestSucceeded) { 
                            IF ($hostname) { Write-Host "$($hostname):$port Open" -ForegroundColor DarkRed -BackgroundColor Black }
                            ELSE { Write-Host "$($ip):$port Open" -ForegroundColor DarkRed -BackgroundColor Black }
                        }
                    }
         

            
                }
            } -ThrottleLimit 50
     
        }
    }
}
Stop-Transcript