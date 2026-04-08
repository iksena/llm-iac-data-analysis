terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.78"
    }
  }

  required_version = ">=1.2.0"

}

provider "azurerm" {
  features {}
}

