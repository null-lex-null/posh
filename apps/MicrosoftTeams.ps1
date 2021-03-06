$uri = [uri]'https://docs.microsoft.com/en-us/microsoftteams/msi-deployment'
try {
    $Response = Invoke-WebRequest -Uri "$uri" -UseBasicParsing -ErrorAction Stop
    # This will only execute if the Invoke-WebRequest is successful.
    $StatusCode = $Response.StatusCode


}
catch {
    $StatusCode = $_.Exception.Response.StatusCode.value__
}
IF ($StatusCode -eq '200') {
    $request = (Invoke-WebRequest -UseBasicParsing -Uri $uri).links
    $x64 = ($request).href | Select-String -SimpleMatch 'arch=x64' | Select-Object -First 1
    $x64 = $x64 -replace 'amp;', ''
    Write-Host "Downloading from URL: $x64" -ForegroundColor 'Yellow' -BackgroundColor 'Black'
    $path = "$env:temp\Teams_windows_x64.msi"
    #if you like faster downloads and no UI needed, use the next 2 lines, else hash them out and unhash the other download variable if you like progress bars
    $download = New-Object System.Net.WebClient
    $download.DownloadFile("$x64", "$path")
    Unblock-File -Path "$path"
    #$download = iwr -UseBasicParsing -Uri $x64 -OutFile "$path"
    #These test paths are for checking if a user uninstalled Teams, cuz if they did, you need to remove the paths below in order to reinstall it, so yea, might be needed. 
    IF (Test-Path -Path $env:localappdata\Microsoft\Teams\) { Get-ChildItem -Path "$env:localappdata\Microsoft\Teams\" -Recurse | Remove-Item -Recurse -Force }
    IF (Test-Path -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Office\Teams) { Get-ItemProperty -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Office\Teams -Name PreventInstallationFromMSI | Remove-Item -Recurse -Force -EA 0 }
    IF (Test-Path $path) { (Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $($path) OPTIONS=""noAutoStart=true"" ALLUSERS=1" -Wait -PassThru -Verb RunAs).ExitCode }
}
