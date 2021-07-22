Invoke-Command -ScriptBlock {
    $repos = Get-VBRBackupRepository | Select-Object -Property *
    IF ($repos.count -gt '1') {
        foreach ($repo in $repos) {
            Write-Host "$($repo.Name):$($repo.Options.MaxTaskCount)"        
        }
    
    }
    IF ($repos.count -eq '1') {
        Write-Host "$($repos.Name):$($repos.Options.MaxTaskCount)"
    }
}