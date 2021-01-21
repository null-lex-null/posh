$statusURL = "#https://URLGOESHERE.COM:8834/session"
$checkup = Invoke-WebRequest -URI $statusURL -Method Get -Headers @{"X-SecurityCenter"=$($loginToken)};
$user = "#USERNAMEGOESHERE"
$password = "#PASSWORDGOESHERE"
Invoke-RestMethod -Uri $statusURL -Method POST -Body (@{"username"="$user"; "password"="$password"}) -SessionVariable "Session" -SkipCertificateCheck