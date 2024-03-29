. .\.config.ps1
. .\.functions.ps1

$Env:VAULT_NAMESPACE="admin/$CHILD_NAMESPACE"

# Enable the JWT Auth Method
if (!(Test-VaultAuthMethodExists -MountPath jwt-platform)) {
  vault auth enable -path jwt-platform jwt
}

# Configure the JWT Auth Method for TFC
vault write auth/jwt-platform/config `
    oidc_discovery_url="https://app.terraform.io" `
    bound_issuer="https://app.terraform.io"

# Define the Policy for the TFC Service Account
$TFC_POLICY = @"
path "sys/health" {
  capabilities = ["read", "sudo"]
}

path "sys/policies/acl" {
  capabilities = ["list"]
}

path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/auth/*" {
  capabilities = ["create", "update", "delete", "sudo"]
}

path "sys/auth" {
  capabilities = ["read"]
}

# Grant access to create secrets engines 
path "sys/mounts/*" {  
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/mounts" {
  capabilities = ["read"]
}

# Give TFC Admin Access
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
"@

# Write the Policy for the TFC Service Account
Write-Output $TFC_POLICY | vault policy write tfc-policy -

$TFC_ROLE = @"
{
    "policies": ["tfc-policy"],
    "bound_audiences": ["vault.workload.identity"],
    "bound_claims_type": "glob",
    "bound_claims": {
      "sub":
  "organization:$($TFC_ORG):project:$($TFC_PROJECT):workspace:$($TFC_WORKSPACE):run_phase:*"
    },
    "user_claim": "terraform_full_workspace",
    "role_type": "jwt",
    "token_ttl": "20m"
  }
"@  

Write-Output $TFC_ROLE
# Edit vault-jwt-auth-role.json to include the correct Project and Workspace
Write-Output $TFC_ROLE | vault write auth/jwt-platform/role/tfc-role -
