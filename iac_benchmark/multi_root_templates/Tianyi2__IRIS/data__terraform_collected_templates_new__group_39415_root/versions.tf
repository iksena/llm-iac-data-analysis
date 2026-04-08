terraform {
  cloud {
    organization = "flcdrg"
    hostname     = "app.terraform.io"

    workspaces {
      name = "terraform-azure-app-service"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.69.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}
