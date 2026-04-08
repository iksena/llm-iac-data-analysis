output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "workload_identity_id" {
  description = "ID of the AKS workload identity"
  value       = azurerm_user_assigned_identity.aks_workload.id
}

output "workload_identity_client_id" {
  description = "Client ID of the AKS workload identity"
  value       = azurerm_user_assigned_identity.aks_workload.client_id
}

output "workload_identity_principal_id" {
  description = "Principal ID of the AKS workload identity"
  value       = azurerm_user_assigned_identity.aks_workload.principal_id
}

output "private_endpoint_ip" {
  description = "Private IP address of the Key Vault private endpoint"
  value       = azurerm_private_endpoint.key_vault.private_service_connection[0].private_ip_address
}
