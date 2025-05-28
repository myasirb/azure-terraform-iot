terraform {
  required_version = ">= 1.0"

  backend "azurerm" {
    resource_group_name  = "Training-RG"
    storage_account_name = "myasirstorage2"
    container_name       = "data-lake"
    key                  = "terraformState/dev.terraform.tfstate"
  }
}
