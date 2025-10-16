# Force remove links from User Desktops; This can be personalized by changing the name of the links in the unwanted list

$publicDesktop = "C:\Users\Public\Desktop\"
$unwanted = @("Acrobat Reader.lnk", "Firefox.lnk", "Google Chrome.lnk", "Microsoft Edge.lnk", "Zoom Workplace.lnk")
foreach ($item in $unwanted) {
    $path = Join-Path -Path $publicDesktop -ChildPath $item
    if (Test-Path -Path $path) {Remove-Item -Path $path -Force}
}