# ================================
# Samsung Bloatware Removal Script
# ================================

function Remove-SamsungBloatware {
$SamsungBloat = @(
    "AI Select",
    "Air Command",
    "Bixby",
    "Camera Share",
    "Click to Do",
    "Galaxy Book Experience",
    "Galaxy Book Smart Switch",
    "Goodnotes",
    "Journal",
    "Live Wallpaper",
    "Multi Control",
    "Nearby devices",
    "Noteshelf",
    "PENUP",
    "Quick Search",
    "Quick Share",
    "Samsung Account",
    "Samsung Care+",
    "Samsung Device Care",
    "Samsung Find",
    "Samsung Flow",
    "Samsung Gallery",
    "Samsung Notes",
    "Samsung Pass",
    "Samsung Settings",
    "Samsung Studio",
    "Screen Recorder",
    "Second Screen",
    "SmartThings"
)

$UninstallRoots = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
)

Write-Host "`nStarting Samsung Win32 bloatware removal..." -ForegroundColor Cyan

foreach ($root in $UninstallRoots) {
    Get-ChildItem $root | ForEach-Object {

        $app = Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue
        if (-not $app.DisplayName -or -not $app.UninstallString) { return }

        foreach ($name in $SamsungBloat) {
            if ($app.DisplayName -like "*$name*") {

                Write-Host "`nFound: $($app.DisplayName)" -ForegroundColor Yellow
                Write-Host "Uninstall command: $($app.UninstallString)"

                $cmd = $app.UninstallString

                # MSI-based uninstall
                if ($cmd -match "msiexec") {
                    if ($cmd -notmatch "/quiet") {
                        $cmd += " /quiet /norestart"
                    }
                    Start-Process "cmd.exe" -ArgumentList "/c $cmd" -Wait -NoNewWindow
                }
                else {
                    # EXE-based uninstall
                    if ($cmd -notmatch "/quiet|/silent|/s") {
                        $cmd += " /quiet"
                    }
                    Start-Process "cmd.exe" -ArgumentList "/c `"$cmd`"" -Wait -NoNewWindow
                }

                Write-Host "Removal attempted for $($app.DisplayName)" -ForegroundColor Green
            }
        }
    }
}

Write-Host "`nSamsung Win32 bloatware removal completed." -ForegroundColor Cyan

}

function audit-removal {
Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall,
              HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall |
Get-ItemProperty |
Where-Object { $_.DisplayName -like "*Samsung*" } |
Select DisplayName, UninstallString
}

# Execute the removal function
audit-removal
