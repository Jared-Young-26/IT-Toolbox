# Create a new AD User
New-ADUser -Name "USER" -GivenName "FIRST" -Surname "LAST" -SamAccountName "LOGIN" -UserPrincipalName "LOGIN@DOMAIN" -DisplayName "FIRST LAST" -Title "JOB ROLE" -Department "DEPARTMENT" -Path "CN=CommonName, OU=Organizational Unit, DC=Domain, DC=Path" -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $true -PasswordNeverExpires $false

# Add User to a group
Add-ADGroupMember -Identity "GROUP NAME" -Members "SAM ACCOUNT NAME"

# Change the name of an AD Object
Rename-ADObject -Identity "CN=NAME, OU=Organizational Unit, DC=Domain" -NewName "NEW_NAME"

# Update AD User Attribute
Set-ADUser -Identity "SAM ACCOUNT NAME" -Replace @{info='Sync'} # This is just modifying the info field attribute to sync with Azure AD but there are others
