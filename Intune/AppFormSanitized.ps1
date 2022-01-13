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
$form.Text = 'Winget App Packager'
$form.Size = New-Object System.Drawing.Size(510,700)
$form.StartPosition = 'CenterScreen'

#Create the Save button
$uploadButton = New-Object System.Windows.Forms.Button
$uploadButton.Location = New-Object System.Drawing.Point(150,620)
$uploadButton.Size = New-Object System.Drawing.Size(100,23)
$uploadButton.Text = 'Upload to Intune'

#Create the How To
$howtoButton = New-Object System.Windows.Forms.Button
$howtoButton.Location = New-Object System.Drawing.Point(10,620)
$howtoButton.Size = New-Object System.Drawing.Size(100,23)
$howtoButton.Text = 'Instructions'

#Create the cancel button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(300,620)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton

#SearchGroupBox
$searchgroupBox = New-Object System.Windows.Forms.GroupBox
$searchgroupBox.Location = '5,5' 
$searchgroupBox.size = '485,50'
$searchgroupBox.text = "Search for Winget App"
$searchgroupBox.Visible = $true

#Create the Search button
$searchButton = New-Object System.Windows.Forms.Button
$searchButton.Location = New-Object System.Drawing.Point(360,20)
$searchButton.Size = New-Object System.Drawing.Size(120,23)
$searchButton.Text = 'Search'

#Label StaffName
$appIDLabel = New-Object System.Windows.Forms.Label
$appIDLabel.Location = New-Object System.Drawing.Point(10,20)
$appIDLabel.Size = New-Object System.Drawing.Size(70,20)
$appIDLabel.Text = 'App ID'

#Staff name input text box
$appIDtextBox = New-Object System.Windows.Forms.TextBox
$appIDtextBox.Location = New-Object System.Drawing.Point(90,20)
$appIDtextBox.Size = New-Object System.Drawing.Size(250,20)

$searchgroupBox.Controls.AddRange(@($searchButton,$appIDtextBox,$appIDLabel))

#detailsgroupBox

$detailsgroupBox = New-Object System.Windows.Forms.GroupBox
$detailsgroupBox.Location = '5,60' 
$detailsgroupBox.size = '485,175'
$detailsgroupBox.text = "App Details"
$detailsgroupBox.Visible = $true
    
#App Version Label
$appNameLabel = New-Object System.Windows.Forms.Label
$appNameLabel.Location = New-Object System.Drawing.Point(10,20)
$appNameLabel.Size = New-Object System.Drawing.Size(70,20)
$appNameLabel.Text = 'Name'
    
#App version text box
$appNametextBox = New-Object System.Windows.Forms.TextBox
$appNametextBox.Location = New-Object System.Drawing.Point(90,20)
$appNametextBox.Size = New-Object System.Drawing.Size(250,20)

#Information URL Label
$infourlLabel = New-Object System.Windows.Forms.Label
$infourlLabel.Location = New-Object System.Drawing.Point(10,45)
$infourlLabel.Size = New-Object System.Drawing.Size(70,20)
$infourlLabel.Text = 'Info URL'
    
#Information URL Text Box
$infourltextBox = New-Object System.Windows.Forms.TextBox
$infourltextBox.Location = New-Object System.Drawing.Point(90,45)
$infourltextBox.Size = New-Object System.Drawing.Size(250,20)

#Privacy URL Label
$privacyurlLabel = New-Object System.Windows.Forms.Label
$privacyurlLabel.Location = New-Object System.Drawing.Point(10,70)
$privacyurlLabel.Size = New-Object System.Drawing.Size(70,20)
$privacyurlLabel.Text = 'Privacy URL'
    
#PrivacyURL Text Box
$privacyurltextBox = New-Object System.Windows.Forms.TextBox
$privacyurltextBox.Location = New-Object System.Drawing.Point(90,70)
$privacyurltextBox.Size = New-Object System.Drawing.Size(250,20)

#Publisher Label
$publisherLabel = New-Object System.Windows.Forms.Label
$publisherLabel.Location = New-Object System.Drawing.Point(10,95)
$publisherLabel.Size = New-Object System.Drawing.Size(70,20)
$publisherLabel.Text = 'Developer'
    
#Publisher Text Box
$developertextBox = New-Object System.Windows.Forms.TextBox
$developertextBox.Location = New-Object System.Drawing.Point(90,95)
$developertextBox.Size = New-Object System.Drawing.Size(250,20)

#Description Label
$descriptionLabel = New-Object System.Windows.Forms.Label
$descriptionLabel.Location = New-Object System.Drawing.Point(10,120)
$descriptionLabel.Size = New-Object System.Drawing.Size(70,20)
$descriptionLabel.Text = 'Description'
    
#Description Text Box
$desciptiontextBox = New-Object System.Windows.Forms.TextBox
$desciptiontextBox.Location = New-Object System.Drawing.Point(90,120)
$desciptiontextBox.Size = New-Object System.Drawing.Size(250,20)

#Icon Label
$iconLabel = New-Object System.Windows.Forms.Label
$iconLabel.Location = New-Object System.Drawing.Point(10,145)
$iconLabel.Size = New-Object System.Drawing.Size(70,20)
$iconLabel.Text = 'Icon'
    
#Icon Text Box
$icontextBox = New-Object System.Windows.Forms.TextBox
$icontextBox.Location = New-Object System.Drawing.Point(90,145)
$icontextBox.Size = New-Object System.Drawing.Size(250,20)

#Create the Search button
$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Location = New-Object System.Drawing.Point(360,145)
$browseButton.Size = New-Object System.Drawing.Size(120,23)
$browseButton.Text = 'Browse'

$detailsgroupBox.Controls.AddRange(@($browseButton,$iconLabel,$icontextBox,$infourltextBox,$desciptiontextBox,$descriptionLabel,$appNameLabel,$appNametextBox,$infourlLabel,$privacyurlLabel,$privacyurltextBox,$publisherLabel,$developertextBox))
    
#InstallGroupBox
$installgroupBox = New-Object System.Windows.Forms.GroupBox
$installgroupBox.Location = '5,240' 
$installgroupBox.size = '485,230'
$installgroupBox.text = "Installer Information"
$installgroupBox.Visible = $true

#Install Script Label
$installscriptLabel = New-Object System.Windows.Forms.Label
$installscriptLabel.Location = New-Object System.Drawing.Point(10,20)
$installscriptLabel.Size = New-Object System.Drawing.Size(100,20)
$installscriptLabel.Text = 'Install Script'
    
#Install Script Text Box
$installscripttextBox = New-Object System.Windows.Forms.TextBox
$installscripttextBox.Location = New-Object System.Drawing.Point(120,20)
$installscripttextBox.Multiline = $true
$installscripttextBox.ScrollBars = "Vertical"
$installscripttextBox.Size = New-Object System.Drawing.Size(355,60)

#Uninstall Script Label
$uninstallscriptLabel = New-Object System.Windows.Forms.Label
$uninstallscriptLabel.Location = New-Object System.Drawing.Point(10,90)
$uninstallscriptLabel.Size = New-Object System.Drawing.Size(100,20)
$uninstallscriptLabel.Text = 'Uninstall Script'
    
#Uninstall Script Text Box
$uninstalltextBox = New-Object System.Windows.Forms.TextBox
$uninstalltextBox.Location = New-Object System.Drawing.Point(120,90)
$uninstalltextBox.Multiline = $true
$uninstalltextBox.ScrollBars = "Vertical"
$uninstalltextBox.Size = New-Object System.Drawing.Size(355,60)

#Detection Script Label
$detectionscriptLabel = New-Object System.Windows.Forms.Label
$detectionscriptLabel.Location = New-Object System.Drawing.Point(10,180)
$detectionscriptLabel.Size = New-Object System.Drawing.Size(100,20)
$detectionscriptLabel.Text = 'Detection Script'
    
#Detection Script Text Box
$detectionscripttextBox = New-Object System.Windows.Forms.TextBox
$detectionscripttextBox.Location = New-Object System.Drawing.Point(120,160)
$detectionscripttextBox.Multiline = $true
$detectionscripttextBox.ScrollBars = "Vertical"
$detectionscripttextBox.Size = New-Object System.Drawing.Size(355,60)

$installgroupBox.Controls.AddRange(@($detectionscripttextBox,$detectionscriptLabel,$uninstalltextBox,$uninstallscriptLabel,$installscripttextBox,$installscriptLabel))

$errorlabelbox = New-Object System.Windows.Forms.ListBox
$errorlabelbox.Location = New-Object System.Drawing.Point(5,475)
$errorlabelbox.Size = New-Object System.Drawing.Size(485,145)
$errorlabelbox.Height = 145

#Add groups to form
$form.controls.AddRange(@($howtoButton,$searchgroupBox,$detailsgroupBox,$installgroupBox,$SaveButton,$cancelButton,$errorlabelbox,$uploadButton))

$howtoButton.Add_Click({
    $howtoform = New-Object System.Windows.Forms.Form
    $howtoform.Text = 'App Packager Instructions'
    $howtoform.Size = New-Object System.Drawing.Size(500,400)
    $howtoform.StartPosition = 'CenterScreen'

    #Create the cancel button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(225,320)
    $okButton.Size = New-Object System.Drawing.Size(50,23)
    $okButton.Text = 'Okay'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    
    #Label StaffName
    $howlabel = New-Object System.Windows.Forms.Label
    $howlabel.Location = New-Object System.Drawing.Point(10,20)
    $howlabel.Size = New-Object System.Drawing.Size(490,300)
    $howlabel.Text = " Change the `$TenantName variable to your own tenant name. The form uses the first half of the tenant name as the app publisher, and fills in the winget app publisher as the developer.
If you'd like to change this you can change the `$AppPublisher and `$AppDeveloper variables.

To use the winget app packager type the full winget ID of the app you'd like to package into the App ID field and click search. 

The form will auto populate all the fields from the winget show function. All fields must have something in them for the form to work. 

If the app doesn't provide a privacy or info url I'd suggest just putting NA. The form will autopopulate the script fields with the scripts I've developed. You can change them but they might stop working.

Once you've verified all information you can click 'Upload to Intune'."

    
    $howtoform.controls.AddRange(@($okButton,$howlabel))
    $howtoform.Topmost = $true
    
    $searchresult = $howtoform.ShowDialog()
    
    
    if ($searchresult -eq [System.Windows.Forms.DialogResult]::OK){
    
        
    }
    $howtoform.Refresh()
    })

#BrowseButton Click Event
$browseButton.Add_Click({
    Add-Type -AssemblyName System.windows.forms | Out-Null
    $OpenDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
    $OpenDialog.initialDirectory = $initialDirectory
    #$OpenDialog.filter = '*.png|.png|*.jpg|*.jpeg'
    $OpenDialog.ShowDialog() | Out-Null
    $filePath = $OpenDialog.filename
    $icontextBox.Text = $filePath 
    $form.Refresh()
    })    

#UploadButton click event

$uploadButton.Add_Click({
   #$WinGetAppId = $appIDtextBox.Text
   #$WinGetAppSplit = $WinGetAppId.Replace('.','*')
    $TenantName = "TENANTNAME"
    $AppPublisher = $TenantName.Split('.')[0].ToUpper()
    $AppDisplayName = $appNametextBox.Text
    $AppDescription = $desciptiontextBox.Text
    $AppDeveloper = $developertextBox.Text
    $InstallScript = $installscripttextBox.Text
    $DetectionScript= $detectionscripttextBox.Text
    $UninstallScript = $uninstalltextBox.Text
    $privacyurl = $privacyurltextBox.Text
    $infourl = $privacyurltextBox.Text

    $destPath="C:\Temp\Intune Packages\$AppDisplayName"

#Check to see if the folder for the package already exists
    if (Test-Path $destPath) {

    }Else{
        New-Item -Path "C:\Temp\Intune Packages\$AppDisplayName" -ItemType directory -Force
}

#Create the install, uninstall, and detection scripts
$InstallScript | Out-File -FilePath "$destPath\Install.ps1"
$DetectionScript | Out-File -FilePath "$destPath\Detection.ps1" -Encoding utf8
$UninstallScript | Out-File -FilePath "$destPath\Uninstall.ps1" 
Copy-Item -Path $icontextBox.Text -Destination $destPath

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
$Icon = New-IntuneWin32AppIcon -FilePath $icontextBox.Text

#Connect to Intune

Connect-MSIntuneGraph -TenantName $TenantName

#Add winget app to Intune
$InstallCommandLine = "PowerShell.exe -ExecutionPolicy Bypass -windowstyle hidden -Command .\Install.ps1"
$UninstallCommandLine = "PowerShell.exe -ExecutionPolicy Bypass -windowstyle hidden -Command .\Uninstall.ps1"
$Win32App = Add-IntuneWin32App -FilePath "$destPath\Install.intunewin" -DisplayName $AppDisplayName -Description $AppDescription -Developer $AppDeveloper -Publisher $AppPublisher -InstallExperience system -RestartBehavior suppress -DetectionRule $DetectionRule -RequirementRule $RequirementRule -PrivacyURL $privacyurl -InformationURL $infourl -InstallCommandLine $InstallCommandLine -UninstallCommandLine $UninstallCommandLine -Icon $Icon -Verbose

Add-IntuneWin32AppAssignmentAllUsers -ID $Win32App.id -Intent "available" -Notification "hideAll"
})

#Winget Searchbutton Click Event

$searchButton.Add_Click({
$AppSearchID = $appIDtextBox.Text
$wingetsearchresults = winget show $AppSearchID | Out-String
$AppGibberishRemover = $wingetsearchresults.Replace('Found', 'FoundName:')
$AppGibberishRemover2 = $AppGibberishRemover -split 'Found',2
$notgibberish = $AppGibberishRemover2[1]
$wingetlines = $notgibberish.Split([Environment]::NewLine)

$AppSearchInfo = New-Object PSObject 
foreach($wingetline in $wingetlines){
$errorlabelbox.Items.Add($wingetline)
$AppPropertyName, $AppPropertyContent = $wingetline -split ':',2
$AppSearchInfo | Add-Member $AppPropertyName $AppPropertyContent

}
$appNametextBox.Text = $AppSearchInfo.Name.Split('[')[0]
$infourltextBox.Text = $AppSearchInfo.'Publisher Url'
$privacyurltextBox.Text = $AppSearchInfo.'Privacy Url'
$developertextBox.Text = $AppSearchInfo.Publisher
$desciptiontextBox.Text = $AppSearchInfo.Description
$WinGetAppId = $appIDtextBox.Text
$WinGetAppSplit = $WinGetAppId.Replace('.','*')
$AppDisplayName = $appNametextBox.Text
$installscripttextBox.Text = "`$WingetSystemPath = Get-ChildItem -Path 'C:\Program Files\WindowsApps' -Filter 'Microsoft.DesktopAppInstaller_*x64*' | Sort-Object -Property 'LastWriteTime' -Descending | Select-Object -First 1 -ExpandProperty 'FullName'
Start-Process -FilePath `$wingetSystemPath\AppInstallerCLI.exe -ArgumentList 'install -h --accept-package-agreements --accept-source-agreements $WinGetAppId'"
$uninstalltextBox.Text = "`$WingetSystemPath = Get-ChildItem -Path 'C:\Program Files\WindowsApps' -Filter 'Microsoft.DesktopAppInstaller_*x64*' | Sort-Object -Property 'LastWriteTime' -Descending | Select-Object -First 1 -ExpandProperty 'FullName'
Start-Process -FilePath `$wingetSystemPath\AppInstallerCLI.exe -ArgumentList 'winget uninstall --silent $AppDisplayName'"
$detectionscripttextBox.Text = "`$InstallerRegKey = Get-ChildItem 'HKLM:\SOFTWARE\Classes\Installer\Products' -Recurse | Get-ItemProperty | Where-Object {`$_ -like '*$WinGetAppSplit*'} 
`$uninstallcheck = Get-ChildItem 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall' -Recurse | Get-ItemProperty | Where-Object {`$_ -like '*$WinGetAppSplit*'}
If( (`$InstallerRegKey.PackageName.Length -gt 0) -or (`$uninstallcheck.DisplayName.Length -gt 0)){
Write-Output '$AppDisplayName installed'
Exit 0
}Else{
Write-Output '$AppDisplayName not installed'
Exit 1
}"
$form.Refresh()
})

$form.Topmost = $true
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK){
    
}

