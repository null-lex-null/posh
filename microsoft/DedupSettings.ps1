Set-DedupSchedule -Name BackgroundOptimization -Enabled $false -ErrorAction SilentlyContinue
Set-DedupSchedule -Name PriorityOptimization -Enabled $false -ErrorAction SilentlyContinue
Get-DedupSchedule -Type Optimization | ForEach-Object { Remove-DedupSchedule -InputObject $_ } -ErrorAction SilentlyContinue
Get-DedupSchedule -Type GarbageCollection | ForEach-Object { Remove-DedupSchedule -InputObject $_ } -ErrorAction SilentlyContinue
Get-DedupSchedule -Type Scrubbing | ForEach-Object { Remove-DedupSchedule -InputObject $_ } -ErrorAction SilentlyContinue
New-DedupSchedule -Name "MWFOptimization" -Type Optimization -DurationHours 6 -Memory 100 -Cores 50 -Priority High -Days @(1, 3, 5) -Start (Get-Date "2016-08-08 05:00:00")
New-DedupSchedule -Name "ErrdayGarbageCollection" -Type GarbageCollection -DurationHours 2 -Memory 100 -Cores 50 -Priority High -Days @(0, 1, 2, 3, 4, 5, 6) -Start (Get-Date "2016-08-13 12:00:00")
New-DedupSchedule -Name "WeeklyIntegrityScrubbing" -Type Scrubbing -DurationHours 6 -Memory 100 -Cores 50 -Priority High -Days @(6, 0) -Start (Get-Date "2016-08-14 05:00:00")
