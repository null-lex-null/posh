$URL = [uri]"https://download5.veeam.com/VeeamBackup&Replication_10.0.1.4854_20200723.iso"
$folder = "$env:temp"
$filename = $url.localpath
$filename = $filename -replace '/','\'
$fullpath = Join-Path $folder $filename
try
    {
        $response = Invoke-WebRequest -Uri "$URL" -ErrorAction Stop
        # This will only execute if the Invoke-WebRequest is successful.
        $StatusCode = $Response.StatusCode
    }
    catch
    {
        $StatusCode = $_.Exception.Response.StatusCode.value__
    }
    $StatusCode