output "resource_group_name" {
  description = "Name of the shared resource group"
  value       = azurerm_resource_group.shared.name
}

output "resource_group_id" {
  description = "ID of the shared resource group"
  value       = azurerm_resource_group.shared.id
}

output "resource_group_location" {
  description = "Location of the shared resource group"
  value       = azurerm_resource_group.shared.location
}

# ACR outputs (shared enterprise pattern)
output "acr_name" {
  description = "Name of the shared Azure Container Registry"
  value       = azurerm_container_registry.shared.name
}

output "acr_login_server" {
  description = "Login server URL for the shared Azure Container Registry"
  value       = azurerm_container_registry.shared.login_server
}

output "acr_id" {
  description = "ID of the shared Azure Container Registry"
  value       = azurerm_container_registry.shared.id
}

output "acr_resource_group_name" {
  description = "Resource group containing the shared ACR"
  value       = azurerm_resource_group.shared.name
}

# GitHub Actions Service Principal outputs
# These will be used to configure GitHub secrets
output "github_actions_client_id" {
  description = "Client ID for GitHub Actions service principal"
  value       = local.github_actions.client_id
}

output "github_actions_object_id" {
  description = "Object ID for GitHub Actions service principal"
  value       = local.github_actions.object_id
}

output "github_actions_tenant_id" {
  description = "Tenant ID for GitHub Actions service principal"
  value       = local.github_actions.tenant_id
}

output "github_actions_subscription_id" {
  description = "Subscription ID for GitHub Actions"
  value       = local.github_actions.subscription_id
}
