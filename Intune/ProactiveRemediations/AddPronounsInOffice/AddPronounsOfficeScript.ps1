New-Item -Path "HKCU:\Software\Policies\Microsoft\Office\16.0\Common"
New-Item -Path "HKCU:\Software\Policies\Microsoft\Office\16.0\Common\ContactCard"
$Path = "HKCU:\Software\Policies\Microsoft\Office\16.0\Common\ContactCard"
New-ItemProperty -Path $Path -PropertyType 'String' -Name 'TurnOnContactTabLabelReplace4' -Value 'Pronouns' 
New-ItemProperty -Path $Path -PropertyType 'DWord' -Name 'TurnOnContactTabMAPIReplace4' -Value '0x8036001F'
New-ItemProperty -Path $Path -PropertyType 'String' -Name 'TurnonContactTabADReplace4' -Value 'ExtensionAttribute 1'
