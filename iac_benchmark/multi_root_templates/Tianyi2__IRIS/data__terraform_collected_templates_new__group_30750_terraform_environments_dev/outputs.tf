output "resource_group_name" {
  description = "Name of the dev resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the dev resource group"
  value       = azurerm_resource_group.main.id
}

output "vnet_id" {
  description = "ID of the dev VNet"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Name of the dev VNet"
  value       = module.networking.vnet_name
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = module.networking.aks_subnet_id
}

output "database_subnet_id" {
  description = "ID of the database subnet"
  value       = module.networking.database_subnet_id
}

# AKS outputs
output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.cluster_name
}

output "aks_cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = module.aks.cluster_fqdn
}

output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks.cluster_id
}

# ACR outputs (shared enterprise pattern - referenced from shared environment)
output "acr_name" {
  description = "Name of the shared Azure Container Registry"
  value       = local.shared_acr_name
}

output "acr_login_server" {
  description = "Login server URL for the shared Azure Container Registry"
  value       = local.shared_acr_login_server
}

output "acr_id" {
  description = "ID of the shared Azure Container Registry"
  value       = local.shared_acr_id
}

# Security outputs
output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.security.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.security.key_vault_uri
}

output "aks_workload_identity_client_id" {
  description = "Client ID of the AKS workload identity for Key Vault access"
  value = module.security.workload_identity_client_id
}

# Database outputs
output "database_server_name" {
  description = "Name of the Azure SQL Server"
  value       = module.database.server_name
}

output "database_server_fqdn" {
  description = "FQDN of the Azure SQL Server"
  value       = module.database.server_fqdn
}

output "database_name" {
  description = "Name of the application database"
  value       = module.database.database_name
}

# Sensitive outputs (use with terraform output -json for automation)
output "database_admin_username" {
  description = "Database administrator username"
  value       = module.database.admin_username
  sensitive   = true
}
