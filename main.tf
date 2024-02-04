provider "vault" {
}

#--------------------------------------
# Create 'admin/alluvium' namespace
#--------------------------------------
resource "vault_namespace" "test" {
  path = "test4"
}
