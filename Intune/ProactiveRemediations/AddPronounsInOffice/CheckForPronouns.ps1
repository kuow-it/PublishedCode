$Path = "HKCU:\Software\Policies\Microsoft\Office\16.0\Common\ContactCard"
$Name = "TurnOnContactTabLabelReplace4"
$Value = "Pronouns"

Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name  -ErrorAction Stop | Select-Object -ExpandProperty $Name
    If ($Registry -eq $Value){
        Write-Output "Compliant"
        Exit 0
    } 
    Write-Warning "Not Compliant"
    Exit 1
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}