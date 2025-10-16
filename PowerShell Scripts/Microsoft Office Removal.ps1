# NOTE: This script is to be run in conjunction with the Office Deployment Tool found at https://www.microsoft.com/en-us/download/details.aspx?id=49117

# This is hte office suite that gets pushed through Intune & Downloaded by licensed users with a Business Standard or higher license package
$c2rPath = "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe"

# For volume licensing, No M365 subscription, or a specific app version (non-updating LSTR versions)
$msiProduct = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Microsoft Office*" }

# New consumer PC's and devices bought at a retail store
$uwpApp = Get-AppxPackage -Name "Microsoft.Office.Desktop"

if (Test-Path $c2rPath) {
    # May need modified depending on the path the script is being run from
    $ODT = "setup.exe"
    $config = "uninstall.xml"

    Write-Output "Office Click2Run installation detected. Running the Office Deployment Tool with the uninstall config..."

    Start-Process -FilePath $ODT -ArgumentList "/configure $config" -Wait

    Write-Output "Done running the Office Deployment Tool."
}
elseif ($msiProduct) {
    Write-Output "MSI installations detected. Removing each product"
    $officeProducts = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Microsoft Office*" }
    foreach ($product in $products) {
        $product.Uninstall()
    }
}
elseif ($uwpApp) {
    Write-Output "Consumer default office software detected from Microsoft Store. Uninstalling from the store."
    Get-AppxPackage -Name "Microsoft.Office.Desktop" | Remove-AppxPackage
}
else {
    Write-Output "No Microsoft Office installation detected"
}