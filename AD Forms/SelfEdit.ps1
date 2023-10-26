<#Allows users to edit information on their own AD account such as cell number and extensible attributes. 
Computer just needs to be domain joined and have DC connectivity. AD powershell modules are not required
Permissions must be set as delegated to self in AD for this script to work

Make sure to change any extension attributes that you don't want to use or have edited. 

Current assignment

Extension Attribute     Data
extensionattribute6     Name pronunciation
extensionattribute10    Pronouns
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()


$form = New-Object System.Windows.Forms.Form
$form.Text = 'My Info'
$form.Size = New-Object System.Drawing.Size(730,500)
$form.StartPosition = 'CenterScreen'


$adsi = [adsisearcher]""
$adsi.Filter = "(&(objectCategory=person)(objectClass=user)(SamAccountName=$env:UserName))"
$adsi.PropertiesToLoad.AddRange(@('name','givenname','sn','extensionattribute10','extensionattribute6','title','department','manager','directreports','homephone','mobile','telephonenumber','mail','streetaddress','l','st','postalcode','physicaldeliveryofficename'))
$adsi.PageSize = 10
$UserInfo = $adsi.FindOne().properties
$ManagerCN = ($UserInfo.manager -split ",")[0]
$ManagerName = ($ManagerCN -split "=")[1]

#Create the Save button
$SaveButton = New-Object System.Windows.Forms.Button
$SaveButton.Location = New-Object System.Drawing.Point(150,430)
$SaveButton.Size = New-Object System.Drawing.Size(75,23)
$SaveButton.Text = 'Save'
$SaveButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

#Create the cancel button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(500,430)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton

#SearchGroupBox
$searchgroupBox = New-Object System.Windows.Forms.GroupBox
$searchgroupBox.Location = '5,5' 
$searchgroupBox.size = '350,50'
$searchgroupBox.text = "Display Name"
$searchgroupBox.Visible = $true

#Label StaffName
$StaffNamelabel = New-Object System.Windows.Forms.Label
$StaffNamelabel.Location = New-Object System.Drawing.Point(10,20)
$StaffNamelabel.Size = New-Object System.Drawing.Size(70,20)
$StaffNamelabel.Text = 'Name'

#Staff name input text box
$StaffNametextBox = New-Object System.Windows.Forms.label
$StaffNametextBox.Location = New-Object System.Drawing.Point(90,20)
$StaffNametextBox.Size = New-Object System.Drawing.Size(250,20)
$StaffNametextBox.Text = $UserInfo.name

$searchgroupBox.Controls.AddRange(@($StaffNamelabel,$StaffNametextBox))

#detailsgroupBox
$detailsgroupBox = New-Object System.Windows.Forms.GroupBox
$detailsgroupBox.Location = '5,60' 
$detailsgroupBox.size = '350,180'
$detailsgroupBox.text = "Full Details"
$detailsgroupBox.Visible = $true

#Label first name
$firstNamelabel = New-Object System.Windows.Forms.Label
$firstNamelabel.Location = New-Object System.Drawing.Point(10,20)
$firstNamelabel.Size = New-Object System.Drawing.Size(70,20)
$firstNamelabel.Text = 'First Name'
    
#First name text box
$firstNametextBox = New-Object System.Windows.Forms.TextBox
$firstNametextBox.Location = New-Object System.Drawing.Point(90,20)
$firstNametextBox.Size = New-Object System.Drawing.Size(250,20)
$firstNametextBox.Text = $UserInfo.givenname

#Label last name
$lastNamelabel = New-Object System.Windows.Forms.Label
$lastNamelabel.Location = New-Object System.Drawing.Point(10,45)
$lastNamelabel.Size = New-Object System.Drawing.Size(70,20)
$lastNamelabel.Text = 'Last Name'

    
#Last name text box
$lastNametextBox = New-Object System.Windows.Forms.TextBox
$lastNametextBox.Location = New-Object System.Drawing.Point(90,45)
$lastNametextBox.Size = New-Object System.Drawing.Size(250,20)
$lastNametextBox.Text = $UserInfo.sn

#Label Pronouns
$Pronounslabel = New-Object System.Windows.Forms.Label
$Pronounslabel.Location = New-Object System.Drawing.Point(10,70)
$Pronounslabel.Size = New-Object System.Drawing.Size(70,20)
$Pronounslabel.Text = 'Pronouns'
    
#Pronouns text box
$PronounstextBox = New-Object System.Windows.Forms.TextBox
$PronounstextBox.Location = New-Object System.Drawing.Point(90,70)
$PronounstextBox.Size = New-Object System.Drawing.Size(250,20)
$PronounstextBox.Text = $UserInfo.extensionattribute10

#Label Pronounciation
$Pronunciationlabel = New-Object System.Windows.Forms.Label
$Pronunciationlabel.Location = New-Object System.Drawing.Point(10,95)
$Pronunciationlabel.Size = New-Object System.Drawing.Size(80,20)
$Pronunciationlabel.Text = 'Pronunciation'
    
#Pronounciation Text Box
$PronunciationtextBox = New-Object System.Windows.Forms.TextBox
$PronunciationtextBox.Location = New-Object System.Drawing.Point(90,95)
$PronunciationtextBox.Size = New-Object System.Drawing.Size(250,20)
$PronunciationtextBox.Text = $USerInfo.extensionattribute6

#Label Job Title
$jobtitlelabel = New-Object System.Windows.Forms.Label
$jobtitlelabel.Location = New-Object System.Drawing.Point(10,125)
$jobtitlelabel.Size = New-Object System.Drawing.Size(70,20)
$jobtitlelabel.Text = 'Job Title'
    
#Job title text box
$jobtitletextBox = New-Object System.Windows.Forms.Label
$jobtitletextBox.Location = New-Object System.Drawing.Point(90,125)
$jobtitletextBox.Size = New-Object System.Drawing.Size(250,20)
$jobtitletextBox.Text = $UserInfo.title

#Label Department
$departmentlabel = New-Object System.Windows.Forms.Label
$departmentlabel.Location = New-Object System.Drawing.Point(10,150)
$departmentlabel.Size = New-Object System.Drawing.Size(70,20)
$departmentlabel.Text = 'Department'
    
#Last name text box
$departmenttextBox = New-Object System.Windows.Forms.Label
$departmenttextBox.Location = New-Object System.Drawing.Point(90,150)
$departmenttextBox.Size = New-Object System.Drawing.Size(250,20)
$departmenttextBox.Text = $UserInfo.department

$detailsgroupBox.Controls.AddRange(@($PronounstextBox,$Pronounslabel,$firstNamelabel,$firstNametextBox,$lastNametextBox,$lastNamelabel,$jobtitlelabel,$jobtitletextBox,$departmentlabel,$departmenttextBox,$Pronunciationlabel,$PronunciationtextBox))
    
#ManagerGroupBox
$managergroupBox = New-Object System.Windows.Forms.GroupBox
$managergroupBox.Location = '5,245' 
$managergroupBox.size = '350,50'
$managergroupBox.text = "Manager"
$managergroupBox.Visible = $true

#Label StaffName
$ManagerNamelabel = New-Object System.Windows.Forms.Label
$ManagerNamelabel.Location = New-Object System.Drawing.Point(10,20)
$ManagerNamelabel.Size = New-Object System.Drawing.Size(70,20)
$ManagerNamelabel.Text = "Name"

#Staff name input text box
$ManagerNametextBox = New-Object System.Windows.Forms.Label
$ManagerNametextBox.Location = New-Object System.Drawing.Point(90,20)
$ManagerNametextBox.Size = New-Object System.Drawing.Size(250,20)
$ManagerNametextBox.Text = $ManagerName

$managergroupBox.Controls.AddRange(@($ManagerNamelabel,$ManagerNametextBox))
    
#ManagerGroupBox
$reportsgroupBox = New-Object System.Windows.Forms.GroupBox
$reportsgroupBox.Location = '5,300' 
$reportsgroupBox.size = '350,125'
$reportsgroupBox.text = "Direct Reports"
$reportsgroupBox.Visible = $true


#Direct reports listbox
$directlistBox = New-Object System.Windows.Forms.ListBox
$directlistBox.Location = New-Object System.Drawing.Point(10,20)
$directlistBox.Size = New-Object System.Drawing.Size(330,100)
$directlistBox.Height = 100

$DirectReports = $UserInfo.directreports
if ($DirectReports.Count -gt 0) {
    foreach($directreport in $DirectReports){
        $directreportCN = ($directreport -split ",")[0]

        $DirectReportsName = ($directreportCN -split "=")[1]
$directlistBox.Items.Add($DirectReportsName)
    }  
}


$reportsgroupBox.Controls.AddRange(@($directlistBox))

#contactInformationGroupBox
$contactInformationGroupBox = New-Object System.Windows.Forms.GroupBox
$contactInformationGroupBox.Location = '365,5' 
$contactInformationGroupBox.size = '350,125'
$contactInformationGroupBox.text = "Contact Information"
$contactInformationGroupBox.Visible = $true

#Label Home Phone
$HomePhoneLabel = New-Object System.Windows.Forms.Label
$HomePhoneLabel.Location = New-Object System.Drawing.Point(10,20)
$HomePhoneLabel.Size = New-Object System.Drawing.Size(70,20)
$HomePhoneLabel.Text = 'Home Phone'
    
#Home Phone Text Box
$HomePhoneTextBox = New-Object System.Windows.Forms.TextBox
$HomePhoneTextBox.Location = New-Object System.Drawing.Point(90,20)
$HomePhoneTextBox.Size = New-Object System.Drawing.Size(250,20)
$HomePhoneTextBox.Text = $UserInfo.homephone

#Label last name
$MobilePhoneLabel= New-Object System.Windows.Forms.Label
$MobilePhoneLabel.Location = New-Object System.Drawing.Point(10,45)
$MobilePhoneLabel.Size = New-Object System.Drawing.Size(70,20)
$MobilePhoneLabel.Text = 'Cell Phone'

#Mobile Phone text box
$MobilePhonetextBox = New-Object System.Windows.Forms.TextBox
$MobilePhonetextBox.Location = New-Object System.Drawing.Point(90,45)
$MobilePhonetextBox.Size = New-Object System.Drawing.Size(250,20)
$MobilePhonetextBox.Text = $UserInfo.mobile

#Label DeskPhone
$DeskPhonelabel = New-Object System.Windows.Forms.Label
$DeskPhonelabel.Location = New-Object System.Drawing.Point(10,70)
$DeskPhonelabel.Size = New-Object System.Drawing.Size(70,20)
$DeskPhonelabel.Text = 'Desk Phone'
    
#Deskphone Textbox
$DeskPhoneTextBox = New-Object System.Windows.Forms.Label
$DeskPhoneTextBox.Location = New-Object System.Drawing.Point(90,70)
$DeskPhoneTextBox.Size = New-Object System.Drawing.Size(250,20)
$DeskPhoneTextBox.Text = $UserInfo.telephonenumber

#Label Job Title
$Emaillabel = New-Object System.Windows.Forms.Label
$Emaillabel.Location = New-Object System.Drawing.Point(10,95)
$Emaillabel.Size = New-Object System.Drawing.Size(70,20)
$Emaillabel.Text = 'Email'
    
#Job title text box
$EmailtextBox = New-Object System.Windows.Forms.Label
$EmailtextBox.Location = New-Object System.Drawing.Point(90,95)
$EmailtextBox.Size = New-Object System.Drawing.Size(250,20)
$EmailtextBox.Text = $UserInfo.mail

$contactInformationGroupBox.Controls.AddRange(@($DeskPhonelabel,$DeskPhoneTextBox,$EmailtextBox,$Emaillabel,$HomePhoneLabel,$HomePhoneTextBox,$MobilePhoneLabel,$MobilePhonetextBox))

#WorkAddressGroupBox
$WorkAddressGroupBox = New-Object System.Windows.Forms.GroupBox
$WorkAddressGroupBox.Location = '365,135' 
$WorkAddressGroupBox.size = '350,145'
$WorkAddressGroupBox.text = "Work Address"
$WorkAddressGroupBox.Visible = $true

#Street address Label
$StreetLabel = New-Object System.Windows.Forms.Label
$StreetLabel.Location = New-Object System.Drawing.Point(10,20)
$StreetLabel.Size = New-Object System.Drawing.Size(70,20)
$StreetLabel.Text = 'Street'
    
#street address textbox
$StreetTextBox = New-Object System.Windows.Forms.Label
$StreetTextBox.Location = New-Object System.Drawing.Point(90,20)
$StreetTextBox.Size = New-Object System.Drawing.Size(250,20)
$StreetTextBox.Text = $UserInfo.streetaddress

#City label
$CityLabel = New-Object System.Windows.Forms.Label
$CityLabel.Location = New-Object System.Drawing.Point(10,45)
$CityLabel.Size = New-Object System.Drawing.Size(70,20)
$CityLabel.Text = 'City'

#City Text Box
$CitytextBox = New-Object System.Windows.Forms.Label
$CitytextBox.Location = New-Object System.Drawing.Point(90,45)
$CitytextBox.Size = New-Object System.Drawing.Size(250,20)
$CitytextBox.Text = $UserInfo.l

#State label
$Satelabel = New-Object System.Windows.Forms.Label
$Satelabel.Location = New-Object System.Drawing.Point(10,70)
$Satelabel.Size = New-Object System.Drawing.Size(70,20)
$Satelabel.Text = 'Sate'
    
#State TextBox
$SateTextBox = New-Object System.Windows.Forms.Label
$SateTextBox.Location = New-Object System.Drawing.Point(90,70)
$SateTextBox.Size = New-Object System.Drawing.Size(250,20)
$SateTextBox.Text = $UserInfo.st

#Zip Code Label
$ZipCodelabel = New-Object System.Windows.Forms.Label
$ZipCodelabel.Location = New-Object System.Drawing.Point(10,95)
$ZipCodelabel.Size = New-Object System.Drawing.Size(70,20)
$ZipCodelabel.Text = 'Zip Code'
    
#Zip Code Text Box
$ZipCodeTextBox = New-Object System.Windows.Forms.Label
$ZipCodeTextBox.Location = New-Object System.Drawing.Point(90,95)
$ZipCodeTextBox.Size = New-Object System.Drawing.Size(250,20)
$ZipCodeTextBox.Text = $UserInfo.postalcode[0].ToString()

#Label Job Title
$DeskNumberLabel = New-Object System.Windows.Forms.Label
$DeskNumberLabel.Location = New-Object System.Drawing.Point(10,120)
$DeskNumberLabel.Size = New-Object System.Drawing.Size(70,20)
$DeskNumberLabel.Text = 'Desk'
    
#Job title text box
$DeskNumberTextBox = New-Object System.Windows.Forms.Label
$DeskNumberTextBox.Location = New-Object System.Drawing.Point(90,300)
$DeskNumberTextBox.Size = New-Object System.Drawing.Size(250,20)
$DeskNumberTextBox.Text = $UserInfo.physicaldeliveryofficename[1]

$WorkAddressGroupBox.Controls.AddRange(@($DeskNumberLabel,$ZipCodelabel,$SateTextBox,$Satelabel,$StreetLabel,$StreetTextBox,$CityLabel,$CitytextBox))

#Disclaimer Label
$DisclaimerLabel = New-Object System.Windows.Forms.Label
$DisclaimerLabel.Location = New-Object System.Drawing.Point(365,300)
$DisclaimerLabel.Size = New-Object System.Drawing.Size(350,100)
$DisclaimerLabel.Text = 'Changes may take up to 24 hours to take effect across all systems.'

#Add groups to form
$form.controls.AddRange(@($WorkAddressGroupBox,$contactInformationGroupBox,$searchgroupBox,$detailsgroupBox,$managergroupBox,$reportsgroupBox,$SaveButton,$cancelButton,$DisclaimerLabel))

$form.Topmost = $true
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK){
$UserRecord = [adsi]$UserInfo.adspath[0]

#set or clear pronouns
    if ([string]::IsNullOrEmpty($PronounstextBox.Text)) {
        $UserRecord.PutEx(1, "extensionAttribute10", 0); 
       	
    }else {
        $UserRecord.Put("extensionAttribute10", $PronounstextBox.Text); 
    
    }

#set or clear home phone
    if ([string]::IsNullOrEmpty($HomePhoneTextBox.Text)) {
        $UserRecord.PutEx(1, "homephone", 0); 
       
    }else {
        $UserRecord.Put("homephone", $HomePhoneTextBox.Text); 
      
    }

#set or clear mobile phone
    if ([string]::IsNullOrEmpty($MobilePhonetextBox.Text)) {
        $UserRecord.PutEx(1, "mobile", 0); 
      
    }else {
        $UserRecord.Put("mobile", $MobilePhonetextBox.Text); 
       
    }

#set or clear name pronunciation
    if ([string]::IsNullOrEmpty($PronunciationtextBox.Text)) {
        $UserRecord.PutEx(1,"extensionAttribute6", 0); 
     
    }else {
        $UserRecord.Put("extensionAttribute6", $PronunciationtextBox.Text); 
      
    }

#set first name
$UserRecord.Put("givenname", $firstNametextBox.Text); 

#set last name
$UserRecord.Put("sn", $lastNametextBox.Text); 
$UserRecord.setinfo();


}
