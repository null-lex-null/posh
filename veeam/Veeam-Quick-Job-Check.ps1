Add-PSSnapIn "VeeamPSSnapIn" -ErrorAction SilentlyContinue
$jobz = (Get-VBRJob)
foreach ($job in $jobz) 
{
Write-Host ($job.name)($job.findlastsession().result)($job.findlastsession().endtime)($job.findlastsession().getdetails()) -Separator ";"
}
