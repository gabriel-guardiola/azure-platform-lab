# Looks up who is running Terraform: Tenant ID + your object ID
data "azurerm_client_config" "current" {}

# The vault itself, using RBAC for access
resource "azurerm_key_vault" "kv" {
  name                       = "kv-${var.prefix}-${random_integer.n.result}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  soft_delete_retention_days = 7     # Deleted vaults stay recoverable for 7 days
  purge_protection_enabled   = false # Lav only, so destroy can fully delete it
  tags                       = var.tags
}

# YOU: can create and manage secrets
resource "azurerm_role_assignment" "runner_kv" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Generates a random passowrd
resource "random_password" "db" {
  length  = 24
  special = true
}

# Stores the password in the vault, after the role exits
resource "azurerm_key_vault_secret" "db" {
  name         = "Dbpassword"
  value        = random_password.db.result
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_role_assignment.runner_kv]
}

# THE APP: read-only access to secrets, through its managed identity
resource "azurerm_role_assignment" "app_kv" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}