# Import Active Directory module
Import-Module ActiveDirectory

# Define variables
$GroupName = "CN=YourGroupName,OU=Groups,DC=YourDomain,DC=com"
$UserName = "CN=UserName,OU=Users,DC=YourDomain,DC=com"

# Get the group object
$Group = Get-ADGroup -Identity $GroupName

# Get the security descriptor (ACL) for the group
$ACL = Get-Acl -Path "AD:$($Group.DistinguishedName)"

# Define the Active Directory rights to be granted
$Identity = New-Object System.Security.Principal.NTAccount("YourDomain", "UserName")

# Grant the right to modify group membership
$AccessRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule `
    ($Identity, "WriteProperty", "Allow", [GUID]"bf9679c0-0de6-11d0-a285-00aa003049e2", "All")

# Add the new access rule to the ACL
$ACL.AddAccessRule($AccessRule)

# Apply the updated ACL to the group
Set-Acl -Path "AD:$($Group.DistinguishedName)" -AclObject $ACL

Write-Output "User $UserName can now modify membership of $GroupName"

#Verification
(Get-Acl -Path "AD:$($GroupName)").Access
