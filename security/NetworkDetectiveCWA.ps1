#The @ symbols are for variable usage in Connectwise Automate
# deprecated this later on, by searching for 'Domain Admin' $usr = "$($ENV:USERDNSDOMAIN)\$($ENV:USERNAME)"
#$usr = "@usr@"   #use this variable after real world testing to pull whatever i want from automate
#$pwd = "@pwd@" this is being deprecated in this script right meow
#$sqlresult = "%sqlresult%" #This is needed to auto pull user if ran from Automate. Not used in PoSH at all. 
$dir = "$($ENV:TEMP)\NetworkDetective\"
$filename = "$($ENV:TEMP)\NetworkDetective\NetworkDetectiveDataCollector.exe"
$outdir = "$($ENV:TEMP)\NetworkDetective\Reports\"
$outbase = "NetworkDetective-$env:computername"
$nddc = "$($ENV:TEMP)\NetworkDetective\nddc.exe"
$ndp = "$($ENV:TEMP)\NetworkDetective\Scan.ndp"
#EXAMPLE = "10.16.16.0-10.16.16.255,10.16.2.0-10.16.2.255"
$iprange = "#IPRANGE"
$url = "https://s3.amazonaws.com/networkdetective/download/NetworkDetectiveDataCollector.exe"
$ClientName = "#NAMEHERE"


#DirectoryChecks
if (!(Test-Path $dir)) { new-item $dir -ItemType Directory }
if (!(Test-Path $outdir)) { new-item $outdir -ItemType Directory }

#New-Item -path "$dir" -ItemType Directory -Force
#New-Item -path "$outdir" -ItemType Directory -Force

Invoke-WebRequest -Uri "$url" -OutFile "$filename"
$extract = cmd.exe /c "$filename -auto $dir"
Stop-Process -Name RunNetworkDetective

#EncryptPassword
$encrypted = cmd.exe /c "$nddc -encrypt $pwd"

$block = @"
# NDC START
-eventlogs
-sql
-internet
-net
-speedchecks
-dhcp
-credsuser
$usr
-credsepwd2
$encrypted
-addc
$ENV:COMPUTERNAME
-ad
-ipranges
$iprange
-threads
20
-snmp
public
-snmptimeout
10
-outbase
$outbase
-outdir
$outdir
-logfile
ndfRun.log
-silent
# NDC END

# SDC START
-internet
-testports
-testurls
-wifi
-policies
-screensaver
-usb
-nozip
-sdfbase
$outbase
-sdfdir
$outdir
# SDC END

# GUI START
-scantype
ldc,sdc,sdcnet
# GUI END
"@

#Saving snippet below in case variables break the security check above.
#-sdfbase
#$ENV:COMPUTERNAME-000C29704AAD
#-sdfdir
#C:\Users\Administrator\Desktop
# SDC END

$savefile = Set-Content -Path $ndp "$block"
$runit = cmd.exe /c "$nddc -file $ndp"
