 $UPMPATH = (get-smbshare -Name 'UPM*').Path
  
 Get-ChildItem '$UPMPATH\*\*\UPM_Profile\.oasis\logs\*' -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object { ($_.CreationTime -lt $(Get-Date).AddDays( - 7))} |
        Remove-Item -force -recurse -ErrorAction SilentlyContinue -Verbose


        ## Cleans up each users temp folder
    if (Test-Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Temp\") {
        Remove-Item -Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Temp\*" -Force -Recurse -Verbose -ErrorAction SilentlyContinue
    } else {
            Write-Host "$UPMPATH\*\Win2016v6\UPM_Profile\AppData\Local\Temp\ does not exist, there is nothing to cleanup.                  " -NoNewline -ForegroundColor DarkGray
            Write-Host "[WARNING]" -ForegroundColor DarkYellow -BackgroundColor Black
    }


       ## Cleans up all users windows error reporting
    if (Test-Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\WER\") {
        Remove-Item -Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\WER\*" -Force -Recurse -Verbose -ErrorAction SilentlyContinue
    } else {
            Write-Host "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\WER\ does not exist, there is nothing to cleanup.            " -NoNewline -ForegroundColor DarkGray
            Write-Host "[WARNING]" -ForegroundColor DarkYellow -BackgroundColor Black
    }

     ## Cleans up users temporary internet files
    if (Test-Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\Temporary Internet Files\") {
        Remove-Item -Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Force -Recurse -Verbose -ErrorAction SilentlyContinue
    } else {
            Write-Host "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\Temporary Internet Files\ does not exist.              " -NoNewline -ForegroundColor DarkGray
            Write-Host "[WARNING]" -ForegroundColor DarkYellow -BackgroundColor Black
    }

      ## Cleans up Internet Explorer cache
    if (Test-Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\IECompatCache\") {
        Remove-Item -Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\IECompatCache\*" -Force -Recurse -Verbose -ErrorAction SilentlyContinue
    } else {
            Write-Host "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\IECompatCache\ does not exist.                         " -NoNewline -ForegroundColor DarkGray
            Write-Host "[WARNING]" -ForegroundColor DarkYellow -BackgroundColor Black
    }

     ## Cleans up Internet Explorer cache
    if (Test-Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\IECompatUaCache\") {
        Remove-Item -Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\IECompatUaCache\*" -Force -Recurse -Verbose -ErrorAction SilentlyContinue
    } else {
            Write-Host "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\IECompatUaCache\ does not exist.                       " -NoNewline -ForegroundColor DarkGray
            Write-Host "[WARNING]" -ForegroundColor DarkYellow -BackgroundColor Black
    }

     ## Cleans up Internet Explorer download history
    if (Test-Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\IEDownloadHistory\") {
        Remove-Item -Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\IEDownloadHistory\*" -Force -Recurse -Verbose -ErrorAction SilentlyContinue
    } else {
            Write-Host "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\IEDownloadHistory\ does not exist.                     " -NoNewline -ForegroundColor DarkGray
            Write-Host "[WARNING]" -ForegroundColor DarkYellow -BackgroundColor Black
    }

     ## Cleans up Internet Cache
    if (Test-Path "$UPMPATH\*\Win2012R2v4\UPM_Profile\AppData\Local\Microsoft\Windows\INetCache\") {
        Remove-Item -Path "$UPMPATH\*\Win2012R2v4\UPM_Profile\AppData\Local\Microsoft\Windows\INetCache\*" -Force -Recurse -Verbose -ErrorAction SilentlyContinue
    } else {
            Write-Host "$UPMPATH\*\Win2012R2v4\UPM_Profile\AppData\Local\Microsoft\Windows\INetCache\ does not exist.                             " -NoNewline -ForegroundColor DarkGray
            Write-Host "[WARNING]" -ForegroundColor DarkYellow -BackgroundColor Black
    }

     ## Cleans up Internet Cookies
    if (Test-Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\INetCookies\") {
        Remove-Item -Path "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\INetCookies\*" -Force -Recurse -Verbose -ErrorAction SilentlyContinue
    } else {
            Write-Host "$UPMPATH\*\*\UPM_Profile\AppData\Local\Microsoft\Windows\INetCookies\ does not exist.                           " -NoNewline -ForegroundColor DarkGray
            Write-Host "[WARNING]" -ForegroundColor DarkYellow -BackgroundColor Black
    }