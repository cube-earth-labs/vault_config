. .\.config.ps1
. .\.functions.ps1

Write-Host "Creating $CHILD_NAMESPACE if it does not exist"
# Check if the specified child namespace exists and create it if it doesn't
if (!(Test-VaultNameSpaceExists -Namespace $CHILD_NAMESPACE)) {
    vault namespace create $CHILD_NAMESPACE
}

# Switch to the new namespace
Write-Host "Switching to namespace: $CHILD_NAMESPACE"
$Env:VAULT_NAMESPACE="admin/$CHILD_NAMESPACE"

# Define sudo-policy granting full admin privileges within the new namespace
$SUDO_POLICY = @"
path "*" {
    capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
"@

# Write sudo-policy to the new namespace
Write-Output $SUDO_POLICY | vault policy write sudo-policy -

# Enable or disable this in .config.ps1
if ($ENABLE_USERPASS -eq $true) {
    # Optionally enable userpass auth method at the new namespace
    # Convenient for testing, but not recommended for production
    Write-Host "Enabling userpass if it does not exist"
    if (!(Test-VaultAuthMethodExists -MountPath userpass)) {
        vault auth enable userpass
    }

    Write-Host "Creating userpass admin user"
    Write-Host $USERPASS_USERNAME
    Write-Host $USERPASS_PASSWORD
    vault write auth/userpass/users/$($USERPASS_USERNAME) password=$($USERPASS_PASSWORD) policies=sudo-policy
}

$Env:VAULT_NAMESPACE=''