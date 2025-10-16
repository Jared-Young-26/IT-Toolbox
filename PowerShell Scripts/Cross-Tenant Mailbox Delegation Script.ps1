Install-Module -Name PowerShellGet -Force 
# Install the Exchange Online Management module if it's not already installed. 
# This check prevents re-installation on every run
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-host "Installing the Exchange Online Management module..." -ForegroundColor Yellow
    Install-Module -Name ExchangeOnlineManagement -Force -Scope CurrentUser
}

# Prompt for the email address of teh local mailbox to be delegated
$LocalMailbox = Read-Host("Enter the email of the local mailbox you want to delegate access to (e.g., native_user@contoso.com): ")
# Prompt for the email address of teh cross-tenant guest user
$GuestUser = Read-Host("Enter teh guest user email address from the other tenant (E.g, guest_user#EXT#@contoso.onmicrosoft.com): ")

# Display a confirmation message to the user
Write-Host " "
Write-Host "You are about to delegate the mailbox: " -ForegroundColor White -NoNewLine
Write-Host $LocalMailbox -ForegroundColor Green
Write-Host "To the guest user: " -ForegroundColor White -NoNewLine
Write-Host $GuestUser -ForegroundColor Green
Write-Host " "

# Pause to give the user time to confirm the values
Start-Sleep -Seconds 8

# Connect to the Exchange Online Server
Write-Host "Connecting to Exchange Online... Please sign in with an account that has admin permissions." -ForegroundColor Cyan
Connect-ExchangeOnline

# Delegate "Full Access" permissions to the guest user
Write-Host "Delegating Full Access permissions... " -ForegroundColor Yellow
Add-MailboxPermission -Identity $LocalMailbox -User $GuestUser -AccessRights FullAccess -InheritanceType All 
Write-Host "Full Access permissions successfully granted." -ForegroundColor Green

# Delegate "Send As" permissions to the guest user
Write-Host "Delegating Send As permissions..." -ForegroundColor Yellow
Add-RecipientPermission -Identity $LocalMailbox -Trustee $GuestUser -AccessRights SendAs
Write-Host "Send As permissions successfully granted." -ForegroundColor Green


Write-Host " "
Write-Host "Script finished. The guest user now has delegated access to the local mailbox." -ForegroundColor Cyan
Read-Host ("Press enter to exit the program...")
