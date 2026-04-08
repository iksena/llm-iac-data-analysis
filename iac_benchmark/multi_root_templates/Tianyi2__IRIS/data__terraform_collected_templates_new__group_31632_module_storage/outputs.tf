output "id" {
  value = azurerm_storage_account.storage.id
}

output "primary_blob_endpoint" {
  value     = azurerm_storage_account.storage.primary_blob_endpoint
  sensitive = true
}

output "primary_dfs_endpoint" {
  value     = azurerm_storage_account.storage.primary_dfs_endpoint
  sensitive = true
}