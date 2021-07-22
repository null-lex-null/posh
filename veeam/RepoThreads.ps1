$repos = Get-VBRBackupRepository | select-object -property *
IF ($repos.count -gt '1') {
    foreach ($repo in $repos) {
        Write-Host "$($repo.Name)"
        Write-Host "Max Task Count: $($repo.Options.MaxTaskCount)"        
    }
    
}
ELSE {
    Write-Host "$($repos.Name)"
    Write-Host "Max Task Count: $($repos.Options.MaxTaskCount)" 
}

