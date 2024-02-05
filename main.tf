provider "vault" {
}

variable "app1-api-key" {
  description = "App1 Api Key"
}

resource "vault_namespace" "platform-team" {
  path = "platform-team"
}
