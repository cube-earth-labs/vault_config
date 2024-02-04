provider "vault" {
}

variable "app1-api-key" {
  description = "App1 Api Key"
}

#--------------------------------------
# Create 'app1-team' Namespace
#--------------------------------------
resource "vault_namespace" "app1-team" {
  path = "app1-team"
}
