# Creation of key vault
resource "azurerm_key_vault" "vault" {
  name                        = local.resource_key_vault_name
  location                    = var.resource_location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get", "backup", "delete", "list", "purge", "recover", "restore", "set",
    ]

    storage_permissions = [
      "get",
    ]
  }
}

# Create Key Vault Secret
resource "azurerm_key_vault_secret" "secret" {
  count = var.resource_instance_count

  name         = "${var.resource_name}${format("%02d", count.index + 1)}-vm"
  value        = var.resource_secret[count.index].result
  key_vault_id = azurerm_key_vault.vault.id
}