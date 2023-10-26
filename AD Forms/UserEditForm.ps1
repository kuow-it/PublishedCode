<#Allows authorized users(HR, Finance, etc) to edit information on a users AD account such as cell number, supervisor, and extensible attributes. 
Computer just needs to be domain joined and have DC connectivity. AD powershell modules are not required
Permissions must be set as delegated for those attributes in AD for this script to work
#>


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = 'User Edit'
$form.Size = New-Object System.Drawing.Size(510,600)
$form.StartPosition = 'CenterScreen'

#Create the Save button
$SaveButton = New-Object System.Windows.Forms.Button
$SaveButton.Location = New-Object System.Drawing.Point(150,520)
$SaveButton.Size = New-Object System.Drawing.Size(75,23)
$SaveButton.Text = 'Save'

#Create the cancel button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(300,520)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton

#SearchGroupBox

$searchgroupBox = New-Object System.Windows.Forms.GroupBox
$searchgroupBox.Location = '5,5' 
$searchgroupBox.size = '485,50'
$searchgroupBox.text = "Search for Staff"
$searchgroupBox.Visible = $true

#Create the Search button
$usersearchButton = New-Object System.Windows.Forms.Button
$usersearchButton.Location = New-Object System.Drawing.Point(360,20)
$usersearchButton.Size = New-Object System.Drawing.Size(120,23)
$usersearchButton.Text = 'Search'

#Label StaffName
$StaffNamelabel = New-Object System.Windows.Forms.Label
$StaffNamelabel.Location = New-Object System.Drawing.Point(10,20)
$StaffNamelabel.Size = New-Object System.Drawing.Size(70,20)
$StaffNamelabel.Text = 'Staff Name'

#Staff name input text box
$StaffNametextBox = New-Object System.Windows.Forms.TextBox
$StaffNametextBox.Location = New-Object System.Drawing.Point(90,20)
$StaffNametextBox.Size = New-Object System.Drawing.Size(250,20)

$searchgroupBox.Controls.AddRange(@($usersearchButton,$StaffNamelabel,$StaffNametextBox))

#detailsgroupBox

$detailsgroupBox = New-Object System.Windows.Forms.GroupBox
$detailsgroupBox.Location = '5,60' 
$detailsgroupBox.size = '485,125'
$detailsgroupBox.text = "Staff Details"
$detailsgroupBox.Visible = $true
    
#Label first name
$firstNamelabel = New-Object System.Windows.Forms.Label
$firstNamelabel.Location = New-Object System.Drawing.Point(10,20)
$firstNamelabel.Size = New-Object System.Drawing.Size(70,20)
$firstNamelabel.Text = 'First Name'
    
#First name text box
$firstNametextBox = New-Object System.Windows.Forms.Label
$firstNametextBox.Location = New-Object System.Drawing.Point(90,20)
$firstNametextBox.Size = New-Object System.Drawing.Size(250,20)

#Label last name
$lastNamelabel = New-Object System.Windows.Forms.Label
$lastNamelabel.Location = New-Object System.Drawing.Point(10,45)
$lastNamelabel.Size = New-Object System.Drawing.Size(70,20)
$lastNamelabel.Text = 'Last Name'
    
#Last name text box
$lastNametextBox = New-Object System.Windows.Forms.Label
$lastNametextBox.Location = New-Object System.Drawing.Point(90,45)
$lastNametextBox.Size = New-Object System.Drawing.Size(250,20)

#Label Job Title
$jobtitlelabel = New-Object System.Windows.Forms.Label
$jobtitlelabel.Location = New-Object System.Drawing.Point(10,70)
$jobtitlelabel.Size = New-Object System.Drawing.Size(70,20)
$jobtitlelabel.Text = 'Job Title'
    
#Job title text box
$jobtitletextBox = New-Object System.Windows.Forms.TextBox
$jobtitletextBox.Location = New-Object System.Drawing.Point(90,70)
$jobtitletextBox.Size = New-Object System.Drawing.Size(250,20)

#Label Department
$departmentlabel = New-Object System.Windows.Forms.Label
$departmentlabel.Location = New-Object System.Drawing.Point(10,95)
$departmentlabel.Size = New-Object System.Drawing.Size(70,20)
$departmentlabel.Text = 'Department'
    
#Last name text box
$departmenttextBox = New-Object System.Windows.Forms.TextBox
$departmenttextBox.Location = New-Object System.Drawing.Point(90,95)
$departmenttextBox.Size = New-Object System.Drawing.Size(250,20)

$detailsgroupBox.Controls.AddRange(@($firstNamelabel,$firstNametextBox,$lastNametextBox,$lastNamelabel,$jobtitlelabel,$jobtitletextBox,$departmentlabel,$departmenttextBox))
    
#ManagerGroupBox
$managergroupBox = New-Object System.Windows.Forms.GroupBox
$managergroupBox.Location = '5,190' 
$managergroupBox.size = '485,50'
$managergroupBox.text = "Manager"
$managergroupBox.Visible = $true

#Create the Search button
$managersearchButton = New-Object System.Windows.Forms.Button
$managersearchButton.Location = New-Object System.Drawing.Point(360,20)
$managersearchButton.Size = New-Object System.Drawing.Size(120,23)
$managersearchButton.Text = 'Change'

#Label StaffName
$ManagerNamelabel = New-Object System.Windows.Forms.Label
$ManagerNamelabel.Location = New-Object System.Drawing.Point(10,20)
$ManagerNamelabel.Size = New-Object System.Drawing.Size(70,20)
$ManagerNamelabel.Text = 'Name'

#Staff name input text box
$ManagerNametextBox = New-Object System.Windows.Forms.Label
$ManagerNametextBox.Location = New-Object System.Drawing.Point(90,20)
$ManagerNametextBox.Size = New-Object System.Drawing.Size(250,20)

$managergroupBox.Controls.AddRange(@($managersearchButton,$ManagerNamelabel,$ManagerNametextBox))
    
#ManagerGroupBox
$reportsgroupBox = New-Object System.Windows.Forms.GroupBox
$reportsgroupBox.Location = '5,270' 
$reportsgroupBox.size = '485,125'
$reportsgroupBox.text = "Direct Reports"
$reportsgroupBox.Visible = $true

#Direct reports listbox
$directlistBox = New-Object System.Windows.Forms.ListBox
$directlistBox.Location = New-Object System.Drawing.Point(10,20)
$directlistBox.Size = New-Object System.Drawing.Size(330,100)
$directlistBox.Height = 100

$reportsgroupBox.Controls.AddRange(@($directlistBox))

$errorlabelbox = New-Object System.Windows.Forms.ListBox
$errorlabelbox.Location = New-Object System.Drawing.Point(5,400)
$errorlabelbox.Size = New-Object System.Drawing.Size(485,100)
$errorlabelbox.Height = 100

#Add groups to form
$form.controls.AddRange(@($searchgroupBox,$detailsgroupBox,$managergroupBox,$reportsgroupBox,$SaveButton,$cancelButton,$errorlabelbox))

#UserSearch click event
$usersearchButton.Add_Click({

try{
$directlistBox.Items.Clear()
$StaffName = $StaffNametextBox.Text
$adsi = [adsisearcher]""
$adsi.Filter = "(&(objectCategory=person)(objectClass=user)(name=$StaffName))"
$adsi.PropertiesToLoad.AddRange(@('givenname','sn','title','department','manager','directreports','name','distinguishedname','adspath'))
$adsi.PageSize = 10
$UserInfo = $adsi.FindOne().properties
$firstNametextBox.Text = $UserInfo.givenname
$lastNametextBox.Text = $UserInfo.sn
$jobtitletextBox.Text = $UserInfo.title
$departmenttextBox.Text = $UserInfo.department
$ManagerCN = ($UserInfo.manager -split ",")[0]
$ManagerName = ($ManagerCN -split "=")[1]
$ManagerNametextBox.Text = $ManagerName
$DirectReports = $UserInfo.directreports
if ($DirectReports.Count -gt 0) {
    foreach($directreport in $DirectReports){
    $directreportCN = ($directreport -split ",")[0]
    $DirectReportsName = ($directreportCN -split "=")[1]
$directlistBox.Items.Add($DirectReportsName)
    }  
}

$form.Refresh()

    }Catch{
        $errorlabelbox.Items.Add("We couldn't find that user. Double check the name and try searching again.")
    }

})

#SaveButton click event

$SaveButton.Add_Click({
$UserRecord = [adsi]$UserInfo.adspath[0]
$ManagerSearchName = $ManagerNametextBox.Text
$JobTitle = $jobtitletextBox.Text
$Department = $departmenttextBox.Text
$adsi.Filter = "(&(objectCategory=person)(objectClass=user)(name=$managersearchName))"
$adsi.PropertiesToLoad.AddRange(@('givenname','sn','title','department','manager','directreports','name','distinguishedname','adspath'))
$adsi.PageSize = 10
$Manager = ($adsi.FindOne().properties).distinguishedname[0]

try{

#Update Title
$UserRecord.Put("title", $JobTitle); 

#Update Manager
$UserRecord.Put("manager", $Manager); 

#Update Department
$UserRecord.Put("department", $Department); 

$UserRecord.setinfo();

$errorlabelbox.Items.Add( "Staff information updated successfully.")
}Catch{
$errorlabelbox.Items.Add($Error)
}


$form.Refresh()
})

#ManagerSearch button click event
$managersearchButton.Add_Click({
$searchform = New-Object System.Windows.Forms.Form
$searchform.Text = 'Manager Search'
$searchform.Size = New-Object System.Drawing.Size(510,100)
$searchform.StartPosition = 'CenterScreen'
#Create the Search button
$secondsearchButton = New-Object System.Windows.Forms.Button
$secondsearchButton.Location = New-Object System.Drawing.Point(360,20)
$secondsearchButton.Size = New-Object System.Drawing.Size(120,23)
$secondsearchButton.Text = 'Search'

#Label StaffName
$secondNamelabel = New-Object System.Windows.Forms.Label
$secondNamelabel.Location = New-Object System.Drawing.Point(10,20)
$secondNamelabel.Size = New-Object System.Drawing.Size(70,20)
$secondNamelabel.Text = 'Name'

#Staff name input text box
$secondSearchtextBox = New-Object System.Windows.Forms.TextBox
$secondSearchtextBox.Location = New-Object System.Drawing.Point(90,20)
$secondSearchtextBox.Size = New-Object System.Drawing.Size(250,20)

$searchform.controls.AddRange(@($secondSearchtextBox,$secondsearchButton,$secondNamelabel))
$searchform.Topmost = $true

$secondsearchButton.Add_Click({
try {
$managersearchName = $secondSearchtextBox.Text
$adsi.Filter = "(&(objectCategory=person)(objectClass=user)(name=$managersearchName))"
$ManagerInfo = $adsi.FindOne().properties
$ManagerNametextBox.Text = $ManagerInfo.name
$searchform.Close()
}
catch {
$errorlabelbox.Items.Add("Cannot find that staff member, please search again.")
}

$searchform.Refresh()
})
$searchresult = $searchform.ShowDialog()

if ($searchresult -eq [System.Windows.Forms.DialogResult]::OK){

    
}
$searchform.Refresh()
})

$form.Topmost = $true
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK){

    
}
