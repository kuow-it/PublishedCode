$PrintServ = Read-Host "Please provide the FQDN for the print server"
$AppIcon = Read-Host "Please provide the file path for the printer icon"
$destPath = "C:Temp\Intune Packages\Printers"
$TenantName = Read-Host "Please provide the tennant name for Intune"
$Printers = Get-Printer -ComputerName $PrintServ
if (Test-Path $destPath) {

}Else{
    New-Item -Path "C:\Temp\Intune Packages\Printers" -ItemType directory -Force
}

#Connect to Intune

Connect-MSIntuneGraph -TenantName $TenantName

Foreach ($printer in $Printers) {
$PrinterName = $printer.name

$destPath="C:\Temp\Intune Packages\Printers\$PrinterName"

#Check to see if the folder for the package already exists
if (Test-Path $destPath) {

    }Else{
        New-Item -Path "C:\Temp\Intune Packages\Printers\$PrinterName" -ItemType directory -Force
}
$PrinterDetection ='$PrinterDetection'
#Create the install, uninstall, and detection scripts
$InstallScript = "Add-Printer -ConnectionName '\\$printserv\$PrinterName'"
$DetectionScript= "$PrinterDetection = Get-Printer -Name '\\$printserv\$PrinterName'
If($PrinterDetection.Name -eq '\\$printserv\$PrinterName'){
Write-Output '$PrinterName successfully installed'
Exit 0
}else{
Write-Output '$PrinterName not installed'
Exit 1
}"
$UninstallScript = "Remove-Printer -Name'$PrinterName'"
$InstallScript | Out-File -FilePath "$destPath\Install.ps1"
$DetectionScript | Out-File -FilePath "$destPath\Detection.ps1" -Encoding utf8
$UninstallScript | Out-File -FilePath "$destPath\Uninstall.ps1"

#Create the app package

New-IntuneWin32AppPackage -SourceFolder $destPath -SetupFile Install.ps1 -OutputFolder $destPath -Verbose

# Create detection rule using the powershell script
$DetectionRule = New-IntuneWin32AppDetectionRuleScript -ScriptFile "$destPath\Detection.ps1" -EnforceSignatureCheck $false -RunAs32Bit $false

# Create custom requirement rule
$RequirementRule = New-IntuneWin32AppRequirementRule -Architecture All -MinimumSupportedOperatingSystem 1903

# Convert image file to icon
$Icon = New-IntuneWin32AppIcon -FilePath $AppIcon



#Add printer app to Intune
$InstallCommandLine = "PowerShell.exe -ExecutionPolicy Bypass -windowstyle hidden -Command .\Install.ps1"
$UninstallCommandLine = "PowerShell.exe -ExecutionPolicy Bypass -windowstyle hidden -Command .\Uninstall.ps1"
Add-IntuneWin32App -FilePath "$destPath\Install.intunewin" -DisplayName $PrinterName -Description "Add the $PrinterName printer." -Publisher $printserv -InstallExperience system -RestartBehavior suppress -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Icon $Icon -Verbose
#
}

