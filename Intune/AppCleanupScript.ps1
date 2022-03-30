#$DeviceIDPath = "HKLM:SOFTWARE\Microsoft\IntuneManagementExtension\SideCarPolicies\LogCollectionStatus"
$UserAccountStatusPath = "HKLM:SOFTWARE\Microsoft\IntuneManagementExtension\SideCarPolicies\StatusServiceReports"
$AppDataPath = "HKLM:SOFTWARE\Microsoft\IntuneManagementExtension\SideCarPolicies\AppData"
$ContentPath = "HKLM:SOFTWARE\Microsoft\IntuneManagementExtension\SideCarPolicies\Content"

$Path = "HKLM:SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps"

<#Get Intune Device ID
$DeviceIDPath = "HKLM:SOFTWARE\Microsoft\IntuneManagementExtension\SideCarPolicies\LogCollectionStatus"
if(Test-Path -Path $DeviceIDPath){
    $DeviceID = (Get-ItemProperty -Path ('{0}\{1}' -f ($DeviceIDPath,(Get-ChildItem -Path $DeviceIDPath).Name.Split('\')[-1])) -Name 'DeviceId' | Select-Object -ExpandProperty 'DeviceId')

   }else{
       ''}
#>
#Get list of all users on the device that are not the system account
$AllUserSID = Get-ChildItem -Path $UserAccountStatusPath
    foreach ($UserSID in $AllUserSID){

#Get the user Azure SID
$UserSIDPathName = $UserSID.PSChildName

#Get the list of each Intune App associated with the user ID
$IntuneAppID = Get-ChildItem -Path $UserSID.PSPath

#Get each appID and the associated status, if the app failed add the app ID to the failed user apps list
    foreach ($AppRegKey in $IntuneAppID) {
        $AppId, $appStatus = Get-ItemPropertyValue -Path $AppRegKey.PSPath -Name AppId, Status2 
        if($appStatus -eq "Failed") {
#For each user account, go through the associated failed apps list and remove the associated win32app list
        (Get-ChildItem -Path $Path\$UserSIDPathName) -Match $AppId | Remove-Item -Recurse -Force
        (Get-ChildItem -Path $Path\$AppDataPath) -Match $AppId | Remove-Item -Recurse -Force
        (Get-ChildItem -Path $Path\$ContentPath) -Match $AppId | Remove-Item -Recurse -Force
        Get-Item -Path $UserAccountStatusPath\$UserSIDPathName\$AppId | Remove-Item -Recurse -Force
        }

    }
}
#Restart Intune Management Service
Restart-Service -Name IntuneManagementExtension -Force