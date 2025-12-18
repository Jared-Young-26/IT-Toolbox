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

function Registry-PathUninstall {

    $GUIDS = @(
        {0B48E952-494A-408B-8D9D-5F3331F96659},
        {5536CC89-01C4-4120-B4ED-AFDBC6626A48},
        {97CE6D18-8335-4420-A7C7-A72B8AFAFFFD},
        {CC15AA48-F58F-4205-BB77-AE02A58B1F4D},
        {D32679F0-C481-4A49-BA3F-EF2F2EFD0775},
        {E82B4BDF-8120-4DC9-9BCB-20505E2E3C47},
        {DDC69433-03CB-4AB4-B8F4-CBB7B03A9D16},
        {0B48E952-494A-408B-8D9D-5F3331F96659},
        {4DD1A19E-EBE1-401C-A950-A6380CCE8882},
        {7F9518EA-F585-4C03-A8F2-7A6587C5BC88},
        {97CE6D18-8335-4420-A7C7-A72B8AFAFFFD},
        {C7669FC5-CF14-4E5B-92CE-5ED29B1BF446}
    )

    foreach ($guid in $GUIDS) {
        Write-Host "Uninstalling $guid"
        Start-Process "msiexec.exe" -ArgumentList "/qn /x $guid" -Wait
    }
    Get-AppxPackage -AllUsers -Publisher \"CN=520D4CDF-A287-4423-AB88-D88CCF7E866D\" | Remove-AppxPackage -AllUsers
    Get-AppxPackage -AllUsers -Publisher \"CN=14C847C8-791E-46EB-9C0D-7CADAF31C930\" | Remove-AppxPackage -AllUsers
    Get-AppxPackage -AllUsers -Publisher \"CN=78A2D367-878A-4A64-8AC0-55373B990090\" | Remove-AppxPackage -AllUsers
    Get-AppxPackage -AllUsers -Publisher \"CN=7114E541-2A85-4D4F-87D3-EF523CD29723\" | Remove-AppxPackage -AllUsers
    Get-AppxPackage -AllUsers -Publisher \"CN=C763A64C-9802-4DC0-94E4-F882A0000049\" | Remove-AppxPackage -AllUsers
}