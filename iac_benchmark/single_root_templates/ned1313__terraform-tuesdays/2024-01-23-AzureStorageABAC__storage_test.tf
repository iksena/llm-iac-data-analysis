# ── main.tf ────────────────────────────────────
provider "azurerm" {
  features {
    
  }
}

resource "azurerm_resource_group" "main" {
  name = "${terraform.workspace}-storage-test"
  location = "eastus"
}

# ── terraform.tf ────────────────────────────────────
terraform {
  backend "azurerm" {
    storage_account_name = "STORAGE_ACCOUNT_NAME"
    container_name = "tfstate"
    key = "tacowagon/terraform.tfstate"
    use_azuread_auth = true
    client_id = "client_ID"
    client_secret = "CLIENT_SECRET"
    tenant_id = "TENANT_ID"
    subscription_id = "SUBSCRIPTION_ID"
  }

  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>3.0"
    }
  }
}