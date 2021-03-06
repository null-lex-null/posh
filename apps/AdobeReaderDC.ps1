$reader = [uri]'https://admdownload.adobe.com/bin/live/readerdc_en_xa_crd_install.exe'
$reader | Out-Null
$filename = $reader.Segments | Select-Object -Last 1
$path = $env:temp + '\' + $filename
(New-Object Net.WebClient).DownloadFile("$reader.absoluteuri", "$path")
Unblock-File -LiteralPath $path
Start-Process -FilePath "$path" -Verb RunAs -ArgumentList "/sAll /rs /msi EULA_ACCEPT=YES" -Wait