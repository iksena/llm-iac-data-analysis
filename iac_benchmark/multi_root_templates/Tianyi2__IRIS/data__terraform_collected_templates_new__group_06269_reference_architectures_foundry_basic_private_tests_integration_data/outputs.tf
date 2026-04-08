# ---------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. Licensed under the MIT license.
# ---------------------------------------------------------------------

# Resource Group ID
output "resource_group_id" {
  description = "Resource ID of the durable resource group"
  value       = data.azurerm_resource_group.this.id
}

# Resource Group Name
output "resource_group_name" {
  description = "Name of the durable resource group"
  value       = data.azurerm_resource_group.this.name
}

# Virtual Network ID
output "virtual_network_id" {
  description = "Resource ID of the durable virtual network"
  value       = data.azurerm_virtual_network.this.id
}

# Subnet IDs for networking
output "connection" {
  description = "Connection subnet information for AI Foundry private endpoints"
  value = {
    id                   = data.azurerm_subnet.connection.id
    name                 = data.azurerm_subnet.connection.name
    resource_group_name  = data.azurerm_subnet.connection.resource_group_name
    virtual_network_name = data.azurerm_subnet.connection.virtual_network_name
    address_prefixes     = data.azurerm_subnet.connection.address_prefixes
  }
}

# Private DNS Zone IDs
output "private_dns_zone_cognitive_id" {
  description = "Resource ID of the Cognitive Services private DNS zone"
  value       = data.azurerm_private_dns_zone.cognitive.id
}

output "private_dns_zone_ai_services_id" {
  description = "Resource ID of the AI Services private DNS zone"
  value       = data.azurerm_private_dns_zone.ai_services.id
}

output "private_dns_zone_openai_id" {
  description = "Resource ID of the OpenAI private DNS zone"
  value       = data.azurerm_private_dns_zone.openai.id
}

