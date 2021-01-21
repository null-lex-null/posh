#-join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
#Below Works WAAAAY better, because it includes characters. 
$minLength = 9 ## characters
$maxLength = 12 ## characters
$length = Get-Random -Minimum $minLength -Maximum $maxLength
$nonAlphaChars = 5
add-type -AssemblyName System.Web
$pass = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)