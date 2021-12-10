$InstallSource = "winget"
Try {
    $FFInstall = winget list --name Firefox
    If ($FFInstall[-1].Contains($installSource)){
        Write-Output "Compliant"
        Exit 1
    } 
    Write-Warning "Not Compliant"
    Exit 0
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 0
}