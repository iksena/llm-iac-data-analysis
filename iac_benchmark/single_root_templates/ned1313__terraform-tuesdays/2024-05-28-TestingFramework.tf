# ── main.tf ────────────────────────────────────
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.website_name}-staging-rg"
  location = var.location
}

locals {
  storage_account_name = "${lower(replace(var.website_name, "/[[:^alnum:]]/", ""))}data001"
}

resource "azurerm_storage_account" "main" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  timeouts {
    delete = "5m"
  }
}

resource "azurerm_storage_container" "main" {
  name                  = "wwwroot"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "homepage" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = azurerm_storage_container.main.name
  source                 = var.html_path
  type                   = "Block"
  content_type           = "text/html"
}

# ── variables.tf ────────────────────────────────────
variable "location" {
  description = "The Azure region in which to create all resources."
  default     = "eastus"
}

variable "website_name" {
  description = "The website name to use to create related resources in Azure."
  default     = "tacocat"

  validation {
    condition = length(var.website_name) <= 17
    error_message = "The website name must be 17 characters or fewer."
  }
}

variable "html_path" {
  description = "The file path of the static home page HTML in your local file system."
  default     = "index.html"
}

# ── outputs.tf ────────────────────────────────────
output "homepage_url" {
  value = azurerm_storage_blob.homepage.url
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "resource_group_name" {
  value = azurerm_storage_account.main.resource_group_name
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_version = ">=1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}