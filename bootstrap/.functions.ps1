# Example usage:
# Test-VaultNamespaceExists -Namespace "exampleNamespace"
function Test-VaultNamespaceExists {
    param(
        [string]$Namespace
    )

    vault namespace list -format=json | ConvertFrom-Json | Where-Object { $_ -eq "$Namespace/" }
}

# Example usage:
# Test-VaultAuthMethodExists -MountPath "userpass"
function Test-VaultAuthMethodExists {
    param(
        [string]$MountPath
    )

    (vault auth list -format=json | ConvertFrom-Json).PSObject.Properties.Name -contains "$MountPath/"
}
