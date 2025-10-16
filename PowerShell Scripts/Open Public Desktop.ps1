# Grants users permissions to the "C:\Users\Public\Desktop" Folder to be able to add or remove whatever they'd like without Admin
# WARNING: This will also allow users to change and manipulate anything and could be used for malicious purposes

# Get-ACL "C:\Users\Public\Desktop" | Format-List

icals "C:\Users\Public\Desktop" /grant "Users:(OI)(CI)M"
