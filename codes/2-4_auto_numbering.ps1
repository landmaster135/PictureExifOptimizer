$number = 1
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
}
