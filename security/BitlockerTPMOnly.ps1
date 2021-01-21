$TPM = Get-TPM
IF(($TPM.TpmEnabled -eq $true) -and ($TPM.TpmReady -eq $true)){Get-BitLockerVolume ; Enable-BitLocker -MountPoint $ENV:SYSTEMDRIVE -TpmProtector}