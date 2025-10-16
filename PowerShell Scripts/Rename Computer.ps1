# Detect if device is virtual or physical
$Manufacturer = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer
$Model = (Get-WmiObject -Class Win32_ComputerSystem).Model

Write-Output "Manufacturer: $Manufacturer"
Write-Output "Model: $Model"

$VMVendors = @("VMware", "Virtual", "Microsoft Corporation", "Xen", "QEMU", "Hyper-V")

$IsVM = $false
foreach ($Vendor in $VMVendors) {
    if ($Manufacturer -like "*$Vendor*" -or $Model -like "*$Vendor*") {
        $IsVM = $true
        break
    }
}

if ($IsVM) {
    Write-Output "This is a virtual machine. Skipping rename..."
    exit 0
}
else {
    # Get serial number from BIOS
    $Serial = (Get-WmiObject -Class Win32_BIOS).SerialNumber.Trim()

    # Build new name with format HOB-Serial
    $NewName = "HOB-$Serial"

    # Get current hostname
    $CurrentName = $env:COMPUTERNAME

    Write-Output "Current computer name: $CurrentName"
    Write-Output "New computer will be: $NewName"

    # Only rename if different
    if ($CurrentName -ne $NewName) {
        try {
            Rename-Computer -NewName $NewName -Force -Restart
        }
        catch {
            Write-Error "Failed to rename computer: $_"
        }
    }
    else {
        Write-Output "Computer name already matches target format. No action taken"
    }
}