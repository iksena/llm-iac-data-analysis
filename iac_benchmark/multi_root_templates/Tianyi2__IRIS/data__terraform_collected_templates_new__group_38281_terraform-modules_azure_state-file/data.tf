data "azurerm_storage_account" "this" {
  name                = module.storage_account.name
  resource_group_name = azurerm_resource_group.this.name

  depends_on = [module.storage_account]
}
