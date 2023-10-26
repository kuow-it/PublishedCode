#Use this if you need to make bulk changes to any of the scripts that you've packaged. Make sure to add the full winget ID to $wingetIDList
$WingetIDList = @()

$WingetIDList += @("TimKosse.FileZilla.Client")

ForEach ($x in $WingetIDList) {

    $AppSearchID = $x
    $wingetsearchresults = winget show $AppSearchID | Out-String
    $AppGibberishRemover = $wingetsearchresults.Replace('Found', 'FoundName:')
    $AppGibberishRemover2 = $AppGibberishRemover -split 'Found',2
    $notgibberish = $AppGibberishRemover2[1]
    $wingetlines = $notgibberish.Split([Environment]::NewLine)
    
    $AppSearchInfo = New-Object PSObject 
    foreach($wingetline in $wingetlines){
    $AppPropertyName, $AppPropertyContent = $wingetline -split ': ',2
    try {
        $AppSearchInfo | Add-Member $AppPropertyName $AppPropertyContent -ErrorAction Ignore  -WarningAction Ignore
    }
    catch {
        
    }
    
    }

$AppDisplayName = ($AppSearchInfo.Name.Split('[')[0]).Trim()

New-Item -Path "C:\Temp\Intune Packages\$AppDisplayName" -ItemType directory -Force

$destPath="C:\Temp\Intune Packages\$AppDisplayName"

$InstallScript = "`$WingetSystemPath = Get-ChildItem -Path 'C:\Program Files\WindowsApps' -Filter 'Microsoft.DesktopAppInstaller_*x64*' | Sort-Object -Property 'LastWriteTime' -Descending | Select-Object -First 1 -ExpandProperty 'FullName'
Start-Process -FilePath `$WingetSystemPath\winget.exe -ArgumentList 'list --accept-source-agreements' | Out-Null
`$InstalledApp = Start-Process -FilePath `$wingetSystemPath\winget.exe -ArgumentList 'install --scope machine -h --accept-package-agreements --accept-source-agreements $x' -Wait"

$DetectionScript ="`$64BitReg = Get-ChildItem 'HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' -Recurse | Get-ItemProperty | Where-Object {`$_.DisplayName -like '*$AppDisplayName*'}
`$32bitReg = Get-ChildItem 'HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\' -Recurse | Get-ItemProperty | Where-Object {`$_.DisplayName -like '*$AppDisplayName*'}
`$64BitRegName = `$64BitReg.DisplayName
`$32bitRegName = `$32bitReg.DisplayName
If((`$64BitRegName -like '*$AppDisplayName*') -or (`$32BitRegName -like '*$AppDisplayName*')){
Write-Output '$AppDisplayName installed'
Exit 0
}Else{
Write-Output '$AppDisplayName not installed'
Exit 1
}"

      
    $InstallScript | Out-File -FilePath "$destPath\Install.ps1"
    $DetectionScript | Out-File -FilePath "$destPath\Detection.ps1" -Encoding utf8
    New-IntuneWin32AppPackage -SourceFolder $destPath -SetupFile Install.ps1 -OutputFolder $destPath -Verbose
 
}




