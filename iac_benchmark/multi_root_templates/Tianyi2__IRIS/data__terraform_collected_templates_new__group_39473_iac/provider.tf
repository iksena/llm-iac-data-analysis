terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.88.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "= 2.47.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azuread" {}

provider "random" {}
