terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "your-storage-account-name"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"  # Isolated dev environment state
  }
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Development team terraform configuration
# This state file is fully controlled by dev team
# Changes here do NOT affect staging or production
