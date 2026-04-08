output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name  
}

output "storage_account_id" {
  value = azurerm_storage_account.storage_account.id  
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name  
}

output "vnet_id" {
  value = azurerm_virtual_network.env_vnet.id
}

output "snet_001_id" {
  value = azurerm_subnet.subnet_001.id  
}

output "snet_002_id" {
  value = azurerm_subnet.subnet_002.id  
}
