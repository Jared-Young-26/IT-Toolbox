# ================================
# Samsung Bloatware Removal Script
# ================================

function Remove-SamsungBloatware {
# List of Samsung-related AppX package name patterns
$SamsungBloat = @(
    "SamsungAISelect",
    "SamsungAirCommand",
    "SamsungBixby",
    "SamsungCameraShare",
    "SamsungClickToDo",
    "SamsungGalaxyBookExperience",
    "SamsungGalaxyBookSmartSwitch",
    "GoodnotesSamsung",
    "SamsungJournal",
    "SamsungLiveWallpaper",
    "SamsungMultiControl",
    "SamsungNearbyDevices",
    "NoteshelfSamsung",
    "SamsungPENUP",
    "SamsungQuickSearch",
    "SamsungQuickShare",
    "SamsungAccount",
    "SamsungCarePlus",
    "SamsungDeviceCare",
    "SamsungFind",
    "SamsungFlow",
    "SamsungGallery",
    "SamsungNotes",
    "SamsungPass",
    "SamsungSettings",
    "SamsungStudio",
    "SamsungScreenRecorder",
    "SamsungSecondScreen",
    "SamsungSmartThings"
)

Write-Host "Starting Samsung bloatware removal..." -ForegroundColor Cyan

foreach ($pattern in $SamsungBloat) {

    Write-Host "`nProcessing: $pattern" -ForegroundColor Yellow

    # Remove installed packages for all users
    Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "*$pattern*" } | ForEach-Object {
        Write-Host "Removing installed package: $($_.Name)"
        Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction SilentlyContinue
    }

    # Remove provisioned packages (preinstalled for new users)
    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like "*$pattern*" } | ForEach-Object {
        Write-Host "Removing provisioned package: $($_.DisplayName)"
        Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue
    }
}

Write-Host "`nSamsung bloatware removal complete." -ForegroundColor Green
}

function audit-removal {
Write-Host "Auditing samsung bloatware:"
Get-AppxPackage -AllUsers |
Where-Object { $_.Publisher -like "*Samsung*" } |
Select Name, PackageFullName

Write-Host "Provisioned Packages:"
Get-AppxProvisionedPackage -Online |
Where-Object { $_.DisplayName -like "*Samsung*" } |
Select DisplayName, PackageName

Write-Host "Non Appx Packages:"
Get-Package | Where-Object { $_.Name -like "*Samsung*" }
}

# Execute the removal function
audit-removal
