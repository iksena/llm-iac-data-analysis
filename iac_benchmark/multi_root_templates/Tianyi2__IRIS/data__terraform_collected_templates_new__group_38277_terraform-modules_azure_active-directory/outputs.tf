output "azure_b2c_id" {
  description = "The ID of the AAD B2C Directory."
  value       = azurerm_aadb2c_directory.azure_b2c.id
}

output "azure_b2c_tenant_id" {
  description = "The Tenant ID for the AAD B2C tenant."
  value       = azurerm_aadb2c_directory.azure_b2c.tenant_id
}
