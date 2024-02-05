##########################################################
# Configuration
##########################################################
locals {
  tfc_labs_role          = "tfc-labs-role"
  tfc_labs_auth_path     = "jwt-labs"
  azure_secrets_vcs_repo = "cube-earth-labs/azure_secrets"
}

resource "vault_jwt_auth_backend" "tfc_jwt" {
  path               = local.tfc_labs_auth_path
  type               = "jwt"
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer       = "https://app.terraform.io"
}

resource "vault_jwt_auth_backend_role" "tfc_role" {
  backend        = vault_jwt_auth_backend.tfc_jwt.path
  role_name      = local.tfc_labs_role
  token_policies = [vault_policy.tfc_policy.name]

  bound_audiences = ["vault.workload.identity"]

  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:ericreeves-demo:project:Cube Earth Labs:workspace:azure_secrets:run_phase:*"
  }

  user_claim = "terraform_full_workspace"
  role_type  = "jwt"
  token_ttl  = 1200
}

resource "vault_policy" "tfc_policy" {
  name = "tfc-azure-policy"

  policy = <<EOT
# Allow tokens to query themselves
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Allow tokens to renew themselves
path "auth/token/renew-self" {
    capabilities = ["update"]
}

# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
    capabilities = ["update"]
}

path "sys/mounts" {
  capabilities = ["list", "read"]
}

path "azure/config" {
  capabilities = ["read"]
}

path "azure/creds/tfc" {
  capabilities = ["read"]
}

path "app1-secrets/database/dev" {
  capabilities = ["read"]
}
EOT
}
