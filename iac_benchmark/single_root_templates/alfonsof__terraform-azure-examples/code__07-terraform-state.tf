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


# ── backend.tf ────────────────────────────────────
# Define Terraform backend using a blob storage container on Microsoft Azure for storing the Terraform state
terraform {
  backend "azurerm" {
    resource_group_name  = "my-terraform-rg"
    storage_account_name = "mytfstorageaccount"
    container_name       = "my-terraform-state-container"
    key                  = "terraform.tfstate"
  }
}