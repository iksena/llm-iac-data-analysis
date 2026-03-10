# ── main.tf ────────────────────────────────────
provider "azurerm" {
  features {}
  
}

resource "azurerm_resource_group" "test" {
  name = "opentofu-test"
  location = "East US"
  tags = {
    managed_by = "Terraform"
  }
}

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "4.1.0"
  
    resource_group_name = azurerm_resource_group.test.name
    use_for_each = true
    vnet_location = azurerm_resource_group.test.location
    address_space = ["10.0.0.0/16"]
    subnet_names = ["subnet1", "subnet2"]
    subnet_prefixes = ["10.0.0.0/24", "10.0.1.0/24"]

}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "tacoTruck"
    storage_account_name = "opentofu1313"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}