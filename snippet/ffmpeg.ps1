$inProcessPath = "#CHANGELOCATION"
$oldVideos = Get-ChildItem -Include @("*.avi", "*.mkv", "*.m4v") -Exclude @("*sample*", "*4K*", "*UHD*") -Path $inProcessPath -Recurse;
Set-Location -Path "$inProcessPath";

foreach ($oldVideo in $oldVideos) {
    $newVideo = [io.path]::ChangeExtension($oldVideo.FullName, '.mp4')
    $ArgumentList = '-i "{0}" -y -async 1  -c:v h264_amf -c:a aac -q:a 100 -strict -2 -movflags faststart -level 41 "{1}"' -f $oldVideo, $newVideo;
    $ffmpeg = Get-ChildItem -Path "$env:homedrive" -Filter "*ffmpeg.exe*" -Recurse
    if ($ffmpeg) {
        Start-Process -FilePath $ffmpeg.FullName -ArgumentList $ArgumentList -Wait -NoNewWindow;
    }
}

