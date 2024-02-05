# This Terraform code retrieves a generic secret from Vault.
# It uses the "vault_generic_secret" data source to fetch the secret located at "app1-secrets/database/dev".
data "vault_generic_secret" "database-dev" {
  path = "app1-secrets/database/dev"
}

# This output retrieves the API key from the "database-dev" secret in Vault.
output "secret-database-dev-api-key" {
  value     = data.vault_generic_secret.database-dev.data["api_key"]
  sensitive = true
}
