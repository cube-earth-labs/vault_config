# Variables for the Azure Secrets Engine
variable "arm_subscription_id" {
  description = "The Azure Subscription ID"
}

variable "arm_tenant_id" {
  description = "The Azure Tenant ID"
}

variable "arm_client_id" {
  description = "The Azure Client ID"
}

variable "arm_client_secret" {
  description = "The Azure Client Secret"
}

# Create the Azure Secret Backend
resource "vault_azure_secret_backend" "azure" {
  subscription_id = var.arm_subscription_id
  tenant_id       = var.arm_tenant_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret
}

resource "vault_azure_secret_backend_role" "generated_read_role" {
  backend          = vault_azure_secret_backend.azure.path
  role             = "generated_read_role"
  sign_in_audience = "AzureADMyOrg"
  tags             = ["team:engineering", "environment:development"]
  ttl              = 300
  max_ttl          = 600

  azure_roles {
    role_name = "Reader"
    scope     = "/subscriptions/${var.arm_subscription_id}/resourceGroups/azure-vault-group"
  }
}