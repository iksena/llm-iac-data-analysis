# ── main.tf ────────────────────────────────────
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

variable "subscription_id" {
  type = string
}




# ── import.tf ────────────────────────────────────
# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "/subscriptions/4d8e572a-3214-40e9-a26f-8f71ecd24e0d/resourceGroups/import-me-please"
resource "azurerm_resource_group" "example" {
  location   = "eastus"
  name       = "import-me-please"
}
