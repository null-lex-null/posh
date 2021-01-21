Add-PSSnapin VeeamPSSnapIn
Get-VBRCloudTenant | Select-Object Name,LastResult,LastActive | Group-Object -Property LastResult | Sort-Object -Property LastResult
Get-VBRCloudTenant | Select-Object Name,LastResult,LastActive | Where-Object -Property LastResult -NE 'Success'
Get-VBRCloudTenant | Select-Object Name,Enabled,LastActive,LastResult,Id,Description | Sort-Object -Property Name -Descending | Format-List Name,Enabled,LastActive,LastResult,Id,Description