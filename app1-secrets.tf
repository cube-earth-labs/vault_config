resource "vault_mount" "app1" {
  path        = "app1-secrets"
  type        = "kv"
  options     = { version = "2" }
  description = "App1 Secrets"
}

resource "vault_kv_secret_v2" "app1-secrets" {
  mount = vault_mount.app1.path
  name  = "api-key"
  data_json = jsonencode(
    {
      endpoint = "http://api.app1.example.com",
      key      = var.app1-api-key
    }
  )
  custom_metadata {
    max_versions = 10
    data = {
      owner = "eric.reeves@hashicorp.com",
      team  = "Platform"
    }
  }
}
