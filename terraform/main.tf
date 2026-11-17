resource "random_integer" "n" {
  min = 1000
  max = 9999
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_service_plan" "plan" {
  name                = "asp-${var.prefix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1" #free; switch to B1 in B17
  tags                = var.tags
}

resource "azurerm_linux_web_app" "app" {
  name                = "app-${random_integer.n.result}-${random_integer.n.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id
  tags                = var.tags
  https_only          = true

  # Azure creates an identify for this app (no password needed)
  identity {
    type = "SystemAssigned"
  }

  # App setting that points to the secrect instead of holding its value
  app_settings = {
    MY_SECRET = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.db.versionless_id})"
  }


  site_config {
    always_on           = false #required in F1
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
  }
}