# ── main.tf ────────────────────────────────────
resource "azurerm_resource_group" "network" {
  name     = "${var.prefix}-network-rg"
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_virtual_network" "network" {
  name                = "${var.prefix}-network"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  address_space       = [var.cidr_block]
  tags                = var.common_tags
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [each.value.address_prefixes]
  service_endpoints = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegation_name != null ? [each.value] : []

    content {
    name = delegation.value.delegation_name
    service_delegation {
      name    = delegation.value.service_delegation_name
      actions = delegation.value.service_delegation_actions
    }
    }
  }
}

# ── variables.tf ────────────────────────────────────
variable "location" {
  description = "The location to use for the network"
  type        = string

}

variable "prefix" {
  description = "The prefix to use for the network"
  type        = string

}

variable "common_tags" {
  description = "The common tags to use for the network"
  type        = map(string)

}

variable "cidr_block" {
  description = "The CIDR block to use for the network"
  type        = string

}

variable "subnets" {
  type = map(object({
    address_prefixes           = string
    delegation_name            = optional(string)
    service_delegation_name    = optional(string)
    service_delegation_actions = optional(list(string))
    service_endpoints          = optional(list(string))
  }))
  description = "Map of subnets to create"
}

# ── outputs.tf ────────────────────────────────────
output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.network.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.network.name
}

output "subnet_id_map" {
  description = "Map of subnet IDs"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }

}