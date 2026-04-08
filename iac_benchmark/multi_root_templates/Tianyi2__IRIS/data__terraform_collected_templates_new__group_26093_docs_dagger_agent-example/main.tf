terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}

resource "azurerm_storage_account" "example" {
  name                     = "daggertestingsa123"
  resource_group_name      = "dagger" # 🔴 Hardcoded RG name
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled = false # 🔴 Insecure: allows HTTP

  public_network_access_enabled = true # 🔴 Open to the internet

  network_rules {
    default_action = "Allow"       # 🔴 Very permissive
    ip_rules       = ["0.0.0.0/0"] # 🔴 Everyone has access
    bypass         = ["AzureServices"]
  }

  tags = {
    environment = "test" # 🔴 Incomplete tagging, no owner/security tags
  }
}

resource "azurerm_storage_container" "public_container" {
  name                  = "public"
  storage_account_id    = azurerm_storage_account.example.id
  container_access_type = "blob" # 🔴 Public anonymous read access
}
