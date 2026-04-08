output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

output "database_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.database.id
}

output "private_endpoints_subnet_id" {
  description = "ID of the private endpoints subnet"
  value       = azurerm_subnet.private_endpoints.id
}

output "aks_subnet_cidr" {
  description = "CIDR of the AKS subnet"
  value       = var.aks_subnet_cidr
}

output "database_subnet_cidr" {
  description = "CIDR of the database subnet"
  value       = var.database_subnet_cidr
}

output "private_endpoints_subnet_cidr" {
  description = "CIDR of the private endpoints subnet"
  value       = var.private_endpoints_subnet_cidr
}

output "app_gateway_subnet_cidr" {
  description = "CIDR of the Application Gateway subnet"
  value       = var.app_gateway_subnet_cidr
}
