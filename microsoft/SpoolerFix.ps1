#This script checks to see if there are files present in th print queue and then stops the print queue if there are, and deletes them and restarts the queue. Will add error handling to this maybe to add a time
#setting to this, so if file age is <10 minutes then delete, since SOME print jobs can take a minute depending on what they are doing etc...
$spooler = 'C:\Windows\System32\spool\PRINTERS'
$spfiles = Get-ChildItem -Path $spooler -Recurse
$status = Get-Service -Name 'Spooler'
if ($spfiles -and { $status -eq 'Running' }) {
    Stop-Service -Name 'Spooler';
    $spfiles | Remove-Item -Recurse -Force;
    Start-Service -Name 'Spooler'
    
}
