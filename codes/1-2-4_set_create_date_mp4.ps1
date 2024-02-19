cd ..; cd 1-1_movie_escaping; $username = (Get-ChildItem Env:\USERNAME).Value; $toCreateDateDir = "1-1_movie_escaping"; $folderDir = "C:\Users\${username}\Downloads\picture_backup\${toCreateDateDir}"; $proc = Start-Process -FilePath "${folderDir}\exiftool" -ArgumentList "-CreateDate<FileModifyDate","-d","%Y:%m:%d:%H:%M:%S",$folderDir -NoNewWindow -PassThru -wait; Write-Host $proc.ExitCode;