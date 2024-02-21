# PictureExifOptimizer

# Requirements

- [ExifTool](https://exiftool.org/)

# Directory

```
C:.
│  exiftool.exe
│
├─1-1_movie_escaping
│      exiftool.exe
│
├─1-2_create_date_setting
│      exiftool.exe
│
└─5_original_files
```

# Workflow of Product

## Ops 1: Ready.

### 事前準備

```powershell
cd C:\Users\%username%\Downloads

mkdir picture_backup & mkdir picture_backup\1-2_create_date_setting & mkdir picture_backup\5_original_files
cd picture_backup

```

### 自分のスマホで撮ったファイル（①）とそれ以外（②）に分ける

- ①は、「`C:\Users\${username}\Downloads\picture_backup`」に入れる。

### ②のオペレーション

- ②は、「`C:\Users\${username}\Downloads\picture_backup\1-2_create_date_setting`」に入れる。

```
start powershell
```

- mp4ファイルなどを退避させる。（③になる）

```powershell
Move-Item -Path *.mp4 -Destination .\1-1_movie_escaping
```

- ②に対してSetting createDate from my FileCreateDate.

```powershell
cd 1-2_create_date_setting; $username = (Get-ChildItem Env:\USERNAME).Value; $toCreateDateDir = "1-2_create_date_setting"; $folderDir = "C:\Users\${username}\Downloads\picture_backup\${toCreateDateDir}"; $proc = Start-Process -FilePath "${folderDir}\exiftool" -ArgumentList "-CreateDate<FileCreateDate","-d","%Y:%m:%d:%H:%M:%S",$folderDir -NoNewWindow -PassThru -wait; Write-Host $proc.ExitCode;
```

- ③に対してSetting createDate from my FileModifyDate.

```powershell
cd ..; cd 1-1_movie_escaping; $username = (Get-ChildItem Env:\USERNAME).Value; $toCreateDateDir = "1-1_movie_escaping"; $folderDir = "C:\Users\${username}\Downloads\picture_backup\${toCreateDateDir}"; $proc = Start-Process -FilePath "${folderDir}\exiftool" -ArgumentList "-CreateDate<FileModifyDate","-d","%Y:%m:%d:%H:%M:%S",$folderDir -NoNewWindow -PassThru -wait; Write-Host $proc.ExitCode;
```

## Ops 2: Renaming file from its Exif createDate.

### ③のmp4はこのコマンドで戻せる。

```powershell
Move-Item -Path .\*.mp4 -Destination ..;
```

### ①の画像ファイルと③の動画ファイルを、Renaming file from its Exif createDate.

```powershell
cd ..
$username = (Get-ChildItem Env:\USERNAME).Value; $folderDir = "C:\Users\${username}\Downloads\picture_backup"; $proc = Start-Process -FilePath "${folderDir}\exiftool" -ArgumentList "-FileName<CreateDate","-d","%Y%m%d%H%M%S.%%e",$folderDir -NoNewWindow -PassThru -wait; Write-Host $proc.ExitCode;
cd .\1-2_create_date_setting

```

### ②のjpegを「`C:\Users\${username}\Downloads\picture_backup`」に移動する。

```powershell
Move-Item -Path *.jpg -Destination ..;
```

### ②のwebpを「`C:\Users\${username}\Downloads\picture_backup`」に移動する。

```powershell
Move-Item -Path *.webp -Destination ..;
cd ..

```

### 数字重複エラーでリネーム出来なかったやつに対して自動採番リネームを行う。

```powershell
**$number = 1
$date_formatted = Get-Date -Format "yyyyMMddHH"
$date_formatted = Get-Date -Format "yyyyMMddH"
$year_this = Get-Date -UFormat "%Y"
$year_last = Get-Date (Get-Date).AddYears(-1) -UFormat "%Y"
$iscorrect = $false
while($iscorrect -eq $false){
  $date_formatted = Read-Host "Input prefix of pictures (yyyyMMddHH)"
	if($date_formatted.length -eq 10 -and $date_formatted -like "${year_this}*" -or $date_formatted -like "${year_last}*"){
		$iscorrect = $true
	}
}
Get-ChildItem -Path . -File | ForEach-Object {
  if($_ -notlike "${year_this}*" -and $_ -notlike "${year_last}*" -and $_ -notlike "*.exe" -and $_ -isnot [System.IO.DirectoryInfo]){
		Write-Host $_.GetType() "true" $_.Name
		$number_zeropadded = "{0:0000}" -f $number
		$ext = [System.IO.Path]::GetExtension($_)
		$newName = "${date_formatted}${number_zeropadded}${ext}"
		Write-Host $newName
		Rename-Item -Path ".\${_}" -NewName $newName
		$number++
  }else{
		Write-Host $_.GetType() "false" $_.Name
	}
}**

```

## Ops 3: Converting JPEG to WEBP.

### ①と②のjpegと③が合流したな。

- 全部webpにする。
- 全部「`C:\Users\${username}\Downloads\picture_backup`」に入れる。

## Ops 4: Copying Exif info from other file.

### ①と②と③が合流したな。

- 全部、Copying Exif info from other file.（DOSで実行する）

```powershell
START /WAIT powershell -Command "Get-ChildItem *.webp | ForEach-Object {$jpg = $_.BaseName + \".jpg\"; if (Test-Path $jpg) {$webpFilePath = $_.FullName; Start-Process -FilePath exiftool.exe -ArgumentList \"-tagsFromFile\",$jpg,\"-exif:all\",$webpFilePath -NoNewWindow -Wait}}"
```

## Ops 5: Escapng original files.

- コピー元のoriginalファイルを「`C:\Users\${username}\Downloads\picture_backup\original_files`」移動する。

```powershell
Move-Item -Path .\*_original -Destination .\5_original_files;
Move-Item -Path .\*.jpg -Destination .\5_original_files;
Move-Item -Path .\*.png -Destination .\5_original_files;

```

## Ops 6: Upload to Google Photos !!

- 全部、Googleフォトにアップロードして終わり。アルバムに振り分ける。

### 予備のコマンド

```powershell
exiftool -s .\img.webp
```

#Change Log

| Date | Topics |
| :--- | :---: |
| 2024-02-20 | Initial commit. |
| |  |
