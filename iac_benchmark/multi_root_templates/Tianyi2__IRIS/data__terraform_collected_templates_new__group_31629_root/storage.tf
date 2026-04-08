locals {
  storage_prefix   = format("%sstorage", local.prefix)
  storage_internal = format("%sint", local.storage_prefix)
  storage_external = format("%sext", local.storage_prefix)
}

module "data_storage_external" {
  source                             = "./module_storage"
  name                               = local.storage_external
  resource_group_name                = data.azurerm_resource_group.logging.name
  azurerm_log_analytics_workspace_id = module.core_logging.oms_id
  is_hns_enabled                     = true
  log_retention_days                 = var.log_retention_days
  location                           = data.azurerm_resource_group.logging.location
}

resource "azurerm_storage_container" "source" {
  name                  = "source"
  storage_account_name  = local.storage_external
  container_access_type = "private"
}

module "data_storage_internal" {
  source                             = "./module_storage"
  name                               = local.storage_internal
  resource_group_name                = data.azurerm_resource_group.logging.name
  azurerm_log_analytics_workspace_id = module.core_logging.oms_id
  is_hns_enabled                     = true
  log_retention_days                 = var.log_retention_days
  location                           = data.azurerm_resource_group.logging.location
}

resource "azurerm_storage_container" "destination" {
  name                  = "destination"
  storage_account_name  = local.storage_internal
  container_access_type = "private"
}