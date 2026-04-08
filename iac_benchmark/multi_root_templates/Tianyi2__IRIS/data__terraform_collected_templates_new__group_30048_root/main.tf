terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.35.0, < 4.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
