output "id" {
  description = "The ID of the API Management Service."
  value       = azurerm_api_management.api_management.id
}

output "additional_location" {
  description = "Zero or more additional_location blocks."
  value       = azurerm_api_management.api_management.additional_location
}

output "gateway_url" {
  description = "The URL of the Gateway for the API Management Service."
  value       = azurerm_api_management.api_management.gateway_url
}

output "gateway_regional_url" {
  description = "The Region URL for the Gateway of the API Management Service."
  value       = azurerm_api_management.api_management.gateway_regional_url
}

output "management_api_url" {
  description = "The URL for the Management API associated with this API Management service."
  value       = azurerm_api_management.api_management.management_api_url
}

output "portal_url" {
  description = "The URL for the Publisher Portal associated with this API Management service."
  value       = azurerm_api_management.api_management.portal_url
}

output "developer_portal_url" {
  description = "The URL for the Developer Portal associated with this API Management service."
  value       = azurerm_api_management.api_management.developer_portal_url
}

output "public_ip_addresses" {
  description = "The Public IP addresses of the API Management Service."
  value       = azurerm_api_management.api_management.public_ip_addresses
}

output "private_ip_addresses" {
  description = "The Private IP addresses of the API Management Service."
  value       = azurerm_api_management.api_management.private_ip_addresses
}

output "scm_url" {
  description = "The URL for the SCM (Source Code Management) Endpoint associated with this API Management service."
  value       = azurerm_api_management.api_management.scm_url
}
