# ── main.tf ────────────────────────────────────
provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.azure_region
}

module "main" {
  source = "./network"

  resource_group_name = azurerm_resource_group.main.name
  azure_region        = azurerm_resource_group.main.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnets             = var.subnets
}

# ── variables.tf ────────────────────────────────────
variable "azure_region" {
  type        = string
  description = "(Optional) Region of Azure to use for resources. Defaults to East US."
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) Name of resource group."
}

variable "vnet_name" {
  type        = string
  description = "(Required) Name of virtual network."
}

variable "address_space" {
  type        = list(string)
  description = "(Required) Address space for virtual network."
}

variable "subnets" {
  type        = map(string)
  description = "(Required) Map of subnet names and address prefixes."
}

# ── outputs.tf ────────────────────────────────────


# ── imports.tf ────────────────────────────────────
/*
import {
  to = module.main.azurerm_subnet.main["web3"]
  id = "SUBNET_ID"
}
*/

# ── terraform.tf ────────────────────────────────────
terraform {
  required_version = ">=1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}