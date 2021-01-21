#Derived from:
#https://stackoverflow.com/questions/25869806/how-to-keep-2-folders-in-sync-using-powershell-script/25870879
$source = '\\erebus.chode.local\domain\redir\lex'
$target = '\\xgp.chode.local\domain\redir\lex'


try {
    $diff = Compare-Object -ReferenceObject (Get-ChildItem -Path "$source" -Recurse) -DifferenceObject (Get-ChildItem -Path "$target" -Recurse)

    foreach ($f in $diff) {
        if ($f.SideIndicator -eq "<=") {
            $fullSourceObject = $f.InputObject.FullName
            $fullTargetObject = $f.InputObject.FullName.Replace($source, $target)

            Write-Host "Attempting to copy the following: " $fullSourceObject
            Copy-Item -Path $fullSourceObject -Destination $fullTargetObject
        }


        if ($f.SideIndicator -eq "=>") {
            $fullSourceObject = $f.InputObject.FullName
            $fullTargetObject = $f.InputObject.FullName.Replace($target, $source)

            Write-Host "Attempting to copy the following: " $fullSourceObject
            Copy-Item -Path $fullSourceObject -Destination $fullTargetObject
        }

    }
}      
catch {
    $_
}