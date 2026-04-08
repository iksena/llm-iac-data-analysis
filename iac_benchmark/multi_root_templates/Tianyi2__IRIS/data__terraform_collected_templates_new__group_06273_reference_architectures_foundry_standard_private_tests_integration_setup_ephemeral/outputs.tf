# ---------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. Licensed under the MIT license.
# ---------------------------------------------------------------------

output "agent_subnet" {
  value       = azurerm_subnet.agent
  description = "The ephemeral agent subnet resource"
}

output "agent_subnet_id" {
  value       = azurerm_subnet.agent.id
  description = "ID of the ephemeral agent subnet (use in agents_subnet_id variable)"
}

output "allocated_cidr" {
  value       = local.agent_cidr
  description = "The CIDR allocated for this test run (e.g., 172.16.42.0/24)"
}

output "subnet_name" {
  value       = local.agent_name
  description = "Name of the ephemeral agent subnet (includes run ID for traceability)"
}

output "octet_value" {
  value       = local.octet_value
  description = "The third octet value used in CIDR (2-255)"
}
