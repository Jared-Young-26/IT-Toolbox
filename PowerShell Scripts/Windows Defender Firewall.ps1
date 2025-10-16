# Create a new firewall rule
New-NetFirewallRule -DisplayName "NEW_RULE" -Direction [Inbound, Outbound] -Action [Allow, Block] -Protocol TCP -LocalPort 443 -Program "%systemroot%\system32\svchost.exe" -Service "SERVICE_NAME" -Profile [Domain, Private, Public] -Enabled $true

# Set a firewall rule that is preconfigured to enabled/disbaled
Set-NetFirewallRule -Name "RULE_NAME" -profile [Domain, Public, Private] -Enabled [True, False]

# Whitelist specific IP address
Set-NetFirewallAddressFilter -RemoteAddress "IP ADDRESS"