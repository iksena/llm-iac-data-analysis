# ── main.tf ────────────────────────────────────
provider "azurerm" {
  features {}

}

resource "random_integer" "example" {
  min = 10000
  max = 99999

}

locals {
  name = "${var.prefix}-ephemeral-${random_integer.example.result}"
}

resource "azurerm_resource_group" "example" {
  name     = local.name
  location = "East US"
}

data "azurerm_client_config" "example" {

}

resource "azurerm_key_vault" "example" {
  name                = local.name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.example.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.example.tenant_id
    object_id = data.azurerm_client_config.example.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore", "Recover", "Purge"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Backup", "Restore", "Recover", "Purge"
    ]

    certificate_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Import", "Backup", "Restore", "Recover", "Purge"
    ]
  }

}

resource "azurerm_key_vault_secret" "normal" {
  name         = "db-password-normal"
  value        = var.db_password_regular
  key_vault_id = azurerm_key_vault.example.id
}

resource "azurerm_key_vault_secret" "write_only" {
  name             = "db-password-wo"
  value_wo         = var.db_password_ephemeral
  value_wo_version = var.db_password_version
  key_vault_id     = azurerm_key_vault.example.id
}

# ── variables.tf ────────────────────────────────────
variable "prefix" {
  description = "The prefix for the Key Vault name."
  type        = string
}

variable "db_password_regular" {
  description = "The database password to be stored in the Key Vault."
  type        = string
  sensitive   = true
}

variable "db_password_ephemeral" {
  description = "The ephemeral database password to be stored in the Key Vault."
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "db_password_version" {
  description = "The version of the database password to be stored in the Key Vault."
  type        = number

  validation {
    condition     = var.db_password_version > 0 && var.db_password_version == floor(var.db_password_version)
    error_message = "The db_password_version must be a non-negative integer."
  }
}

# ── outputs.tf ────────────────────────────────────
output "db_password_info" {
  value = {
    key_vault_id          = azurerm_key_vault.example.id
    key_vault_secret_name = azurerm_key_vault_secret.write_only.name
    version               = nonsensitive(azurerm_key_vault_secret.write_only.value_wo_version)
  }
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_version = ">= 1.11.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.23.0"
    }
  }
}