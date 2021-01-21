$URL = "#URLGOESHERE"
$msifile = "$env:temp\ConnectWiseControl.ClientSetup.msi"
$download = Invoke-WebRequest -Uri $URL -OutFile $msifile
$MSIArguments = @(
    "/i"
    "$msifile"
    "/qn"
    "/norestart"
)
Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Verb RunAs -Wait -NoNewWindow
