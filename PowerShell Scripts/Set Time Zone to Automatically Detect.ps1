# Set the registry key to enable automatic time zone updates
$TZAutoSettingRegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate"
Set-ItemProperty -Path $TZAutoSettingRegPath -Name "Start" -Value 3 -Force

# Set the "Let apps access your location" to allow
$AppAccess = "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
Set-ItemProperty -Path $AppAccess -Name "Value" -Value "Allow" -Force

# Set the registry key to allow location services, which are required for automatic time zone detection
$LocationConsentRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
Set-ItemProperty -Path $LocationConsentRegPath -Name "Value" -Value "Allow" -Force

Write-Host "Automatic time zone setting has been enabled and location services have been allowed"