cd ..
$username = (Get-ChildItem Env:\USERNAME).Value; $folderDir = "C:\Users\${username}\Downloads\picture_backup"; $proc = Start-Process -FilePath "${folderDir}\exiftool" -ArgumentList "-FileName<CreateDate","-d","%Y%m%d%H%M%S.%%e",$folderDir -NoNewWindow -PassThru -wait; Write-Host $proc.ExitCode;
cd .\1-2_create_date_setting
