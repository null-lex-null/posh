#Derived from https://docs.microsoft.com/en-us/powershell/scripting/samples/working-with-software-installations?view=powershell-7
#Trying to make a quasi-universal application script. This is one of the many iterations
$ApplicationName = Read-Host -Prompt "Application to be Uninstalled"
IF (!(Get-PSDrive -Name Uninstall -ErrorAction SilentlyContinue)) { New-PSDrive -Name Uninstall -PSProvider Registry -Root HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall }

$UninstallableApplications = Get-ChildItem -Path Uninstall:

$myApp = $UninstallableApplications | Where-Object -FilterScript {
  $_.GetValue("DisplayName") -match "$ApplicationName" 
}
Write-Output("$myApp")
$Quiet = $myapp | ForEach-Object { $_.GetValue("QuietUninstallString") } 
$UninstallString = $myapp | ForEach-Object { $_.GetValue("UninstallString") }

IF ($Quiet) {
  Start-Process "CMD" -ArgumentList "/c $Quiet" -Verb RunAs -Wait;
  
}
IF ($UninstallString) {
  IF ($UninstallString -match 'MSIEXEC.exe /I') { Write-Output $UninstallString -replace "MSIEXEC.exe /I", "MSIEXEC.EXE /X" }
  IF ($UninstallString -match 'MSIEXEC.exe /X') { Start-Process "$env:comspec" -ArgumentList "/c $UninstallString /quiet /qn /noreboot" }
  IF ($UninstallString -match '.exe') {
  
    try {
      Start-Process "$env:comspec" -ArgumentList "/c $UninstallString /Silent" -Verb RunAs -Wait
    }    
    catch {
      Write-Host "An error occurred while trying to uninstall silently:"
      Write-Host $_
    }
    finally {
      Get-PSDrive -Name Uninstall | Remove-PSDrive
    }
  }

}