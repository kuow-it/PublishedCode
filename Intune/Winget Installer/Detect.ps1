$AppDetectionCode = Get-AppPackage 
If($AppDetectionCode[-1].PackageFamilyName.Contains('8wekyb3d8bbwe')){
Write-Output 'winget successfully installed'
Exit 0
}else{
Write-Output 'winget not installed'
Exit 1
}