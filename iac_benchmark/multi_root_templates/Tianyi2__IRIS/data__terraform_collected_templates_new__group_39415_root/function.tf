
resource "azurerm_storage_account" "storage" {
  name                     = "sttfappserviceause"
  resource_group_name      = data.azurerm_resource_group.group.name
  location                 = data.azurerm_resource_group.group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_windows_function_app" "function" {
  name                       = "func-tfappservice-australiasoutheast"
  resource_group_name        = data.azurerm_resource_group.group.name
  location                   = data.azurerm_resource_group.group.location
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  https_only                 = true

  site_config {
    minimum_tls_version = "1.2"
    application_stack {
      dotnet_version = "v3.0"
    }
  }
}
