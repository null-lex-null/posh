$test = Test-NetConnection 192.168.100.1 http
IF (($test).TcpTestSucceeded -eq $True) {
    $arris = [uri]"http://192.168.100.1/cmconnectionstatus.html"
    $today = (Get-Date -Format MMddyyyy)
    try {
        $response = Invoke-WebRequest -Uri "$arris" -UseBasicParsing -ErrorAction Stop
        # This will only execute if the Invoke-WebRequest is successful.
        $StatusCode = $Response.StatusCode
    }
    catch {
        $StatusCode = $_.Exception.Response.StatusCode.value__
    }
    IF ($StatusCode -notmatch "40?", "50?") {
        $progressPreference = 'silentlyContinue'
        $url = "http://192.168.100.1/cmconnectionstatus.html"   
        $r = Invoke-WebRequest $url
        ($r.AllElements | Where-Object { $_.class -match 'simpleTable' }).innerText | Out-File -FilePath "$($env:temp)\ArrisConnectionStatusLog-$($today).txt" 
        $progressPreference = 'Continue'
    }
}