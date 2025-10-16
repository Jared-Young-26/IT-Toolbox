# Install module if not already installed
Install-Module -Name Microsoft.Online.SharePoint.PowerShell 

# Connect to SharePoint Online
Connect-SPOService -Url https://<CurrentTenant>-admin.sharepoint.com

# Schedule the rename at least 24 hours in the future
Start-SPOTenantRename -DomainName "NEWTENANT" -ScheduleDateTime "2025-10-01T02:00:00"

# User tis to monitor the progress
Get-SPOTenantRenameStatus