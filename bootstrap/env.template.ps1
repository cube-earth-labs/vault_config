# The public or private address of the Vault cluster
$Env:VAULT_ADDR="https://addr:port"

# The namespace for the Vault cluster - "admin" for the root namespace in HCP Vault
$Env:VAULT_NAMESPACE="admin"

# The root token for the Vault cluster in the admin namespace
# Generate a new token in the HCP Vault web UI
$Env:VAULT_TOKEN="SECRETTOKEN"

# The child Vault namespace for your new Organiztaion
$CHILD_NAMESPACE="cube-earth-labs"

# The TFC Project and Workspace used to configure HCP Vault
$TFC_ORG="ericreeves-demo"
$TFC_PROJECT="Cube Earth Platform"
$TFC_WORKSPACE="vault_config"

# Enable or disable userpass
$ENABLE_USERPASS="true"

# userpass admin username
$USERPASS_USERNAME="vault-admin"
$USERPASS_PASSWORD="SECRETPASS"