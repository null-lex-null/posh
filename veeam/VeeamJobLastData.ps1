Add-PSSnapin "VeeamPSSnapIn" -ErrorAction SilentlyContinue
$jobz = (Get-VBRJob) 
foreach ($job in $jobz) {
IF($job.jobtype -eq 'Backup'){

   $data = [ordered]@{
      JobName    = $job.name
      LastSessionResult  = $job.findlastsession().result
      LastPointCreationTime = $job.FindLastBackup().LastPointCreationTime
      LatestScheduledRun = $job.LatestRunLocal
      VMsInJob = $job.GetObjectsInJob() | select Name,ApproxSizeString,IsIncluded
      Repository = $job.FindTargetRepository().Name
   }
   $data | Format-Table -AutoSize -Wrap

}
}