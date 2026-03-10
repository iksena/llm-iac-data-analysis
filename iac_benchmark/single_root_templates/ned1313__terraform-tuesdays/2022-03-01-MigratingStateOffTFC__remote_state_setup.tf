# ── main.tf ────────────────────────────────────
##################################################################################
# LOCALS
##################################################################################

locals {
  resource_group_name    = "${var.naming_prefix}-${random_integer.sa_num.result}"
  storage_account_name   = "${lower(var.naming_prefix)}${random_integer.sa_num.result}"
  service_principal_name = "${var.naming_prefix}-${random_integer.sa_num.result}"
}

##################################################################################
# RESOURCES
##################################################################################

## AZURE AD SP ##

data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}

resource "azuread_application" "remote_state" {
  display_name = local.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "remote_state" {
  application_id = azuread_application.remote_state.application_id
  owners         = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "remote_state" {
  service_principal_id = azuread_service_principal.remote_state.object_id
}

resource "azurerm_role_assignment" "remote_state" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.remote_state.id
}

# Azure Storage Account

resource "random_integer" "sa_num" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "setup" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.setup.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "ct" {
  name                 = "terraform-state"
  storage_account_name = azurerm_storage_account.sa.name

}

resource "local_file" "backend" {
  filename = "backend.txt"
  content = <<EOF
storage_account_name="${azurerm_storage_account.sa.name}"
resource_group_name="${azurerm_resource_group.setup.name}"
container_name="terraform-state"
  EOF
}

# ── variables.tf ────────────────────────────────────
#############################################################################
# VARIABLES
#############################################################################

variable "location" {
  description = "(Optional) Region where the Azure resources will be created. Defaults to East US."
  type        = string
  default     = "eastus"
}

variable "naming_prefix" {
  description = "(Optional) Naming prefix used for resources. Defaults to adolabs."
  type        = string
  default     = "tfc"
}

# ── outputs.tf ────────────────────────────────────
output "azure_info" {
  value = {
    RESOURCE_GROUP      = azurerm_storage_account.sa.resource_group_name
    CONTAINER_NAME      = azurerm_storage_container.ct.name
    ARM_CLIENT_ID       = azuread_service_principal.remote_state.application_id
    ARM_CLIENT_SECRET   = nonsensitive(azuread_service_principal_password.remote_state.value)
    ARM_SUBSCRIPTION_ID = data.azurerm_subscription.current.subscription_id
    ARM_TENANT_ID       = data.azuread_client_config.current.tenant_id
  }
}

# ── terraform.tf ────────────────────────────────────
##################################################################################
# TERRAFORM CONFIG
##################################################################################
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
}


##################################################################################
# PROVIDERS
##################################################################################

provider "azurerm" {
  features {}
}