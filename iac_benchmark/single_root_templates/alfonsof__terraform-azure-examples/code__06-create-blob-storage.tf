# ── main.tf ────────────────────────────────────
# Set the Azure Provider source and version being used
terraform {
  required_version = ">= 0.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1.0"
    }
  }
}

# Configure the Microsoft Azure provider
provider "azurerm" {
  features {}
}

# Create a Resource Group if it doesn’t exist
resource "azurerm_resource_group" "tfexample" {
  name     = "my-terraform-rg"
  location = "West Europe"
}

# Create a Storage account
resource "azurerm_storage_account" "terraform_state" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.tfexample.name
  location                 = azurerm_resource_group.tfexample.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "my-terraform-env"
  }
}

# Create a Storage container
resource "azurerm_storage_container" "terraform_state" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}


# ── outputs.tf ────────────────────────────────────
# Output variable: Blob Storage container name
output "blob_storage_container" {
  value = "https://${azurerm_storage_account.terraform_state.name}.blob.core.windows.net/${azurerm_storage_container.terraform_state.name}/"
}


# ── vars.tf ────────────────────────────────────
# Input variable: Name of Storage Account
variable "storage_account_name" {
  description = "The name of the storage account. Must be globally unique, length between 3 and 24 characters and contain numbers and lowercase letters only."
  default     = "mytfstorageaccount"
}

# Input variable: Name of Storage container
variable "container_name" {
  description = "The name of the Blob Storage container."
  default     = "my-terraform-state-container"
}
