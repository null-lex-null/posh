$url = 'https://slack.com/ssb/download-win64-msi'
$path = (Join-Path -Path "$env:temp" -ChildPath "slack-standalone.msi")
(New-Object System.Net.WebClient).DownloadFile($url, $path)
IF(Test-Path -Path $path){
    Unblock-File -Path $path;
    Start-Process "msiexec.exe" -ArgumentList "/i ""$path"" /qn /norestart /L*V ""$env:temp\SlackInstall.Log""" -Wait -Verb RunAs
}