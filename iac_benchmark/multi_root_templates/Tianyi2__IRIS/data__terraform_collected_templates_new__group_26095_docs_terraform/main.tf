terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.23.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}

resource "azurerm_storage_account" "example" {
  name                     = "terraformtesting123456" # use whatever name you like
  resource_group_name      = "my-rg" # should be a existing RG
  location                 = "West US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

