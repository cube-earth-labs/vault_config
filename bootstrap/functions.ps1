# Example usage:
# Check-VaultNamespaceExists -Namespace "exampleNamespace"
function Check-VaultNamespaceExists {
    param(
        [string]$Namespace
    )

    vault namespace list -format=json | ConvertFrom-Json | Where-Object { $_ -eq "$Namespace/" }
}

# Example usage:
# Check-VaultAuthMethodExists -MountPath "userpass"
function Check-VaultAuthMethodExists {
    param(
        [string]$MountPath
    )

    (vault auth list -format=json | ConvertFrom-Json).PSObject.Properties.Name -contains "$MountPath/"
}
