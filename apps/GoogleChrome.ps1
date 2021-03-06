$url = [uri]'https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B366A39C8-5256-6C5C-1E3A-94E9C525D218%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEB/dl/chrome/install/GoogleChromeEnterpriseBundle64.zip'
try {
    (New-Object Net.WebClient).DownloadFile("$url", "$env:temp\GoogleChromeEnterpriseBundle64.zip")
    Unblock-File -LiteralPath "$env:temp\GoogleChromeEnterpriseBundle64.zip"
    IF (!(Test-Path -LiteralPath "$env:temp\ChromeInstall")) { New-Item -Name ChromeInstall -Path "$env:temp" -ItemType Directory }
    Expand-Archive -LiteralPath "$env:temp\GoogleChromeEnterpriseBundle64.zip" -DestinationPath "$env:temp\ChromeInstall\" -Force
    Start-Process -FilePath "C:\Windows\System32\msiexec.exe" -Verb RunAs -ArgumentList "/I $env:temp\ChromeInstall\Installers\GoogleChromeStandaloneEnterprise64.msi /qn /quiet /norestart" -Wait
}
catch {
    $_ 
}
