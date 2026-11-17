terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstate29072" # from the script output
    container_name       = "tfstate"
    key                  = "lab.tfstate"
  }
}