IF (!(Get-PSDrive -Name Uninstall64 -ErrorAction SilentlyContinue)) { New-PSDrive -Name Uninstall64 -PSProvider Registry -Root HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall }
IF (!(Get-PSDrive -Name Uninstall32 -ErrorAction SilentlyContinue)) { New-PSDrive -Name Uninstall32 -PSProvider Registry -Root HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall }
$UninstallableApplications = Get-ChildItem -Path @("Uninstall64:","Uninstall32:")
#ReplaceApplicatioNameBelow
$ApplicationName = '#ReplaceApplicatioNameBelow'

$myapp = $UninstallableApplications | Where-Object -FilterScript {
  $_.GetValue("DisplayName") -match $ApplicationName
}


$UninstallString = ($myapp).GetValue("UninstallString")
$QuietUninstallString = ($myapp).GetValue("QuietUninstallString")

IF($QuietUninstallString){  
  Start-Process "CMD" -ArgumentList "/c $uninstall /S" -Verb RunAs -Wait -EA 0
}


IF ($UninstallString -match "MSIEXEC.exe /x") {
  IF ($UninstallString -match "MSIEXEC.exe /I") { Write-Output $UninstallString -replace "MSIEXEC.exe /I", "MSIEXEC.EXE /X" }
  Start-Process "$UninstallString.split($)[0]" -ArgumentList "$UninstallString.split()[1] /qn /norestart" -Verb RunAs -Wait -EA 0
}

IF ($UninstallString -match '.exe') {
  $uninstall = Write-Output $UninstallString;
  Start-Process "CMD" -ArgumentList "/c $uninstall /S" -Verb RunAs -Wait -EA 0
  Start-Process "CMD" -ArgumentList "/c $uninstall" -Verb RunAs -Wait -EA 0
}

