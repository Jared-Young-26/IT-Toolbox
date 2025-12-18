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

function Samsung-Services{
    Get-Service | Where-Object { $_.DisplayName -like "*Samsung*" -or $_.Name -like "*Samsung*" }

}

function Samsung-ScheduledTasks{
    Get-ScheduledTask | Where-Object {$_.TaskName -like "*Samsung*" -or $_.TaskPath -like "*Samsung*"}
}

function Samsung-InstallDirectories{
    $paths = @(
    "C:\Program Files\Samsung",
    "C:\Program Files (x86)\Samsung",
    "$env:LOCALAPPDATA\Samsung",
    "$env:APPDATA\Samsung",
    "C:\ProgramData\Samsung"
)

$paths | ForEach-Object {
    if (Test-Path $_) { Get-ChildItem $_ -Recurse -ErrorAction SilentlyContinue }
}
}

function Samsung-Recon {
    Samsung-Services
    Samsung-ScheduledTasks
    Samsung-InstallDirectories
}

function Disable-SamsungServices {
    Get-Service | Where-Object { $_.Name -like "*Samsung*" } | ForEach-Object {
    Stop-Service $_.Name -Force -ErrorAction SilentlyContinue
    Set-Service $_.Name -StartupType Disabled
}
}

function Disable-SamsungScheduledTasks {
    Get-ScheduledTask | Where-Object {
    $_.TaskName -like "*Samsung*" -or $_.TaskPath -like "*Samsung*"
} | Disable-ScheduledTask
}

function Remove-SamsungInstallDirectories {
    $RemovePaths = @(
    "C:\Program Files\Samsung",
    "C:\Program Files (x86)\Samsung",
    "C:\ProgramData\Samsung",
    "$env:LOCALAPPDATA\Samsung",
    "$env:APPDATA\Samsung"
)

foreach ($path in $RemovePaths) {
    if (Test-Path $path) {
        Write-Host "Removing $path"
        Remove-Item $path -Recurse -Force
    }
}

Get-WmiObject Win32_Product |
Where-Object { $_.Name -like "*Samsung Device Care*" } |
ForEach-Object { $_.Uninstall() }
}
