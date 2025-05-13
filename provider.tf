provider "azurerm" {
  features {}
  
  # Configure the Microsoft Azure Provider with service principal credentials from tfvars
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}
