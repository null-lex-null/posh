$Drives = (Get-PSDrive -PSProvider FileSystem).Root
foreach ($drive in $drives) {
    try {
        Invoke-Command -ScriptBlock { Get-ChildItem "$drive" -Recurse | Where-Object { $_.attributes -match "compressed" } | ForEach-Object { cmd /c "compact /u /a /i ""$($_.fullname)""" } }
    }
    catch {
        $_
    }
}