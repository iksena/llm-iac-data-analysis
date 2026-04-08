# ---------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. Licensed under the MIT license.
# ---------------------------------------------------------------------

output "resource_group_name" {
  value       = data.azurerm_resource_group.this.name
  description = "Name of the resource group"
}

output "resource_group_id" {
  value       = data.azurerm_resource_group.this.id
  description = "ID of the resource group"
}

output "virtual_network_id" {
  value       = data.azurerm_virtual_network.this.id
  description = "ID of the virtual network"
}

output "connection" {
  value       = data.azurerm_subnet.connection
  description = "Connections subnet (for AI Foundry private endpoints)"
}

# NOTE: Agent subnet data lookup removed (can't be shared across Foundry instances)
# For plan-only tests (acceptance), provide a mock agent subnet object
# For apply tests (integration), use setup_ephemeral module instead
output "agent" {
  value = {
    id                  = "${data.azurerm_virtual_network.this.id}/subnets/agent-mock-for-plan-only"
    name                = "agent-mock-for-plan-only"
    resource_group_name = data.azurerm_resource_group.this.name
    address_prefixes    = ["172.16.255.0/24"] # Mock CIDR not actually created
  }
  description = "Mock agent subnet for plan-only acceptance tests (NOT a real subnet)"
}

output "private_dns_zones" {
  value = {
    cognitive   = data.azurerm_private_dns_zone.cognitive.name
    ai_services = data.azurerm_private_dns_zone.ai_services.name
    openai      = data.azurerm_private_dns_zone.openai.name
  }
  description = "Private DNS zone names"
}

output "cosmosdb_account_name" {
  value       = data.azurerm_cosmosdb_account.this.name
  description = "Cosmos DB account name"
}

output "cosmosdb_endpoint" {
  value       = data.azurerm_cosmosdb_account.this.endpoint
  description = "Cosmos DB endpoint"
}

output "cosmosdb_resource_id" {
  value       = data.azurerm_cosmosdb_account.this.id
  description = "Cosmos DB resource ID"
}

output "storage_account_name" {
  value       = data.azurerm_storage_account.this.name
  description = "Storage Account name"
}

output "storage_primary_blob_endpoint" {
  value       = data.azurerm_storage_account.this.primary_blob_endpoint
  description = "Storage Account primary blob endpoint"
}

output "storage_resource_id" {
  value       = data.azurerm_storage_account.this.id
  description = "Storage Account resource ID"
}

output "search_service_name" {
  value       = data.azurerm_search_service.this.name
  description = "AI Search service name"
}

output "search_resource_id" {
  value       = data.azurerm_search_service.this.id
  description = "AI Search service resource ID"
}
