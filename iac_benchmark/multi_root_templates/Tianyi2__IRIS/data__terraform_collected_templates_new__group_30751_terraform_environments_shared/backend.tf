terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "your-storage-account-name"
    container_name       = "tfstate"
    key                  = "shared.terraform.tfstate"  # Dedicated state for shared services
  }
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Platform team terraform configuration
# This state file contains shared services that affect all environments
# Changes require approval and impact analysis
