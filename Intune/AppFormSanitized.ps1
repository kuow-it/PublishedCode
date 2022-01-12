<#
Modules required
IntuneWin32App
AzureAD
Credit to https://www.petervanderwoude.nl and https://call4cloud.nl/ whose scripts I tweaked for the app upload
Credit to https://github.com/rothgecw for figuring out how to run winget with the system account
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = 'App Packager'
$form.Size = New-Object System.Drawing.Size(400,400)
$form.StartPosition = 'CenterScreen'

#Create the Add to Intune button
$IntuneButton = New-Object System.Windows.Forms.Button
$IntuneButton.Location = New-Object System.Drawing.Point(40,310)
$IntuneButton.Size = New-Object System.Drawing.Size(120,23)
$IntuneButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$IntuneButton.Text = 'Add to app Intune'



#Create the cancel button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(270,310)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton

#Create the browse button
$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Location = New-Object System.Drawing.Point(10,270)
$browseButton.Size = New-Object System.Drawing.Size(75,23)
$browseButton.Text = 'Browse'

#Label WinGet input field
$WinGetlabel = New-Object System.Windows.Forms.Label
$WinGetlabel.Location = New-Object System.Drawing.Point(10,20)
$WinGetlabel.Size = New-Object System.Drawing.Size(280,20)
$WinGetlabel.Text = 'WinGet App Id'

#Winget name input text box
$WinGettextBox = New-Object System.Windows.Forms.TextBox
$WinGettextBox.Location = New-Object System.Drawing.Point(10,40)
$WinGettextBox.Size = New-Object System.Drawing.Size(260,20)

#Label Display Name input field
$DisplayNamelabel = New-Object System.Windows.Forms.Label
$DisplayNamelabel.Location = New-Object System.Drawing.Point(10,70)
$DisplayNamelabel.Size = New-Object System.Drawing.Size(280,20)
$DisplayNamelabel.Text = 'Display Name'

#Label Display Name input text box
$DisplayNametextBox = New-Object System.Windows.Forms.TextBox
$DisplayNametextBox.Location = New-Object System.Drawing.Point(10,90)
$DisplayNametextBox.Size = New-Object System.Drawing.Size(260,20)

#Label Description input field
$Descriptionlabel = New-Object System.Windows.Forms.Label
$Descriptionlabel.Location = New-Object System.Drawing.Point(10,120)
$Descriptionlabel.Size = New-Object System.Drawing.Size(280,20)
$Descriptionlabel.Text = 'Description'

#Label Description input text box
$DescriptiontextBox = New-Object System.Windows.Forms.TextBox
$DescriptiontextBox.Location = New-Object System.Drawing.Point(10,140)
$DescriptiontextBox.Size = New-Object System.Drawing.Size(260,20)

#Label Publisher input field
$Publisherlabel = New-Object System.Windows.Forms.Label
$Publisherlabel.Location = New-Object System.Drawing.Point(10,170)
$Publisherlabel.Size = New-Object System.Drawing.Size(280,20)
$Publisherlabel.Text = 'Publisher'

#Label Publisher input text box
$PublishertextBox = New-Object System.Windows.Forms.TextBox
$PublishertextBox.Location = New-Object System.Drawing.Point(10,190)
$PublishertextBox.Size = New-Object System.Drawing.Size(260,20)

#Photo Upload Name
$txtFileName = New-Object System.Windows.Forms.TextBox
$txtFileName.Location = New-Object System.Drawing.Point(10,240)
$txtFileName.Size = New-Object System.Drawing.Size(260,20)

#Photo Upload 
$ChooseFileLabel = New-Object System.Windows.Forms.Label
$ChooseFileLabel.Location = New-Object System.Drawing.Point(10,220)
$ChooseFileLabel.Size = New-Object System.Drawing.Size(280,20)
$ChooseFileLabel.Text = 'Choose Logo Image'

#Adding the textbox,buttons to the forms for displaying
$form.controls.AddRange(@($ChooseFileLabel,$txtFileName,$PublishertextBox,$Publisherlabel,$DescriptiontextBox,$Descriptionlabel,$DisplayNametextBox,$DisplayNamelabel,$WinGettextBox,$WinGetlabel,$IntuneButton,$cancelButton,$browseButton))
 
#Browse button click event
$browseButton.Add_Click({
Add-Type -AssemblyName System.windows.forms | Out-Null
$OpenDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
$OpenDialog.initialDirectory = $initialDirectory
#$OpenDialog.filter = '*.png|.png|*.jpg|*.jpeg'
$OpenDialog.ShowDialog() | Out-Null
$filePath = $OpenDialog.filename
$txtFileName.Text = $filePath 
$form.Refresh()
})

$form.Topmost = $true

$form.Add_Shown({$WinGettextBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)

{
    $WinGetAppId = $WinGettextBox.Text
    $TenantName = "TENANTNAME"
    $AppDisplayName = $DisplayNametextBox.Text
    $AppDescription = $DescriptiontextBox.Text
    $AppPublisher = $PublishertextBox.Text

    $destPath="C:\Temp\Intune Packages\$AppDisplayName"

#Check to see if the folder for the package already exists
    if (Test-Path $destPath) {

    }Else{
        New-Item -Path "C:\Temp\Intune Packages\$AppDisplayName" -ItemType directory -Force
}

#Create the install, uninstall, and detection scripts
$InstallScript = "`$WingetSystemPath = Get-ChildItem -Path 'C:\Program Files\WindowsApps' -Filter 'Microsoft.DesktopAppInstaller_*x64*' | Sort-Object -Property 'LastWriteTime' -Descending | Select-Object -First 1 -ExpandProperty 'FullName'
Start-Process -FilePath `$wingetSystemPath\AppInstallerCLI.exe -ArgumentList 'install --silent --accept-package-agreements --accept-source-agreements $WinGetAppId'"

$DetectionScript= "`$InstallerRegKey = Get-ChildItem 'HKLM:\SOFTWARE\Classes\Installer\Products' -Recurse | Get-ItemProperty | Where-Object {`$_ -like '*$WingetAppId*'} 
If( `$InstallerRegKey.PackageName.Contains('$WinGetAppId')){
Write-Output '$AppDisplayName installed'
Exit 0
}Else{
Write-Output '$AppDisplayName not installed'
Exit 1
}
"

$UninstallScript = "$WingetSystemPath
Start-Process -FilePath $wingetSystemPath\AppInstallerCLI.exe -ArgumentList 'winget uninstall --silent $AppDisplayName'"
$InstallScript | Out-File -FilePath "$destPath\Install.ps1"
$DetectionScript | Out-File -FilePath "$destPath\Detection.ps1" -Encoding utf8
$UninstallScript | Out-File -FilePath "$destPath\Uninstall.ps1" 
Copy-Item -Path $txtFileName.Text -Destination $destPath

#Download the Microsoft Win32 Content Prep Tool
Import-Module -Name IntuneWin32App -Force
Import-Module -Name AzureAD -Force

#Create the app package
New-IntuneWin32AppPackage -SourceFolder $destPath -SetupFile Install.ps1 -OutputFolder $destPath -Verbose

# Create detection rule using the powershell script
$DetectionRule = New-IntuneWin32AppDetectionRuleScript -ScriptFile "$destPath\Detection.ps1" -EnforceSignatureCheck $false -RunAs32Bit $false

# Create custom requirement rule
$RequirementRule = New-IntuneWin32AppRequirementRule -Architecture All -MinimumSupportedOperatingSystem 1903

# Convert image file to icon
$Icon = New-IntuneWin32AppIcon -FilePath $txtFileName.Text

#Connect to Intune

Connect-MSIntuneGraph -TenantName $TenantName

#Add winget app to Intune
$InstallCommandLine = "PowerShell.exe -ExecutionPolicy Bypass -windowstyle hidden -Command .\Install.ps1"
$UninstallCommandLine = "PowerShell.exe -ExecutionPolicy Bypass -windowstyle hidden -Command .\Uninstall.ps1"
Add-IntuneWin32App -FilePath "$destPath\Install.intunewin" -DisplayName $AppDisplayName -Description $AppDescription -Publisher $AppPublisher -InstallExperience system -RestartBehavior suppress -DetectionRule $DetectionRule -RequirementRule $RequirementRule -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Icon $Icon -Verbose
}
