# Generate random text for a unique storage account name
resource "random_id" "adf_random" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = data.azurerm_resource_group.logging.name
    index          = var.instance
  }
  byte_length = 8
}

locals {
  azurerm_data_factory_name                           = format("%sadf%s", local.prefix, random_id.adf_random.hex)
  databricks_link_name                                = formatdate("'DatabricksLink'YYYYMMDDhhmmss", timestamp())
  dataset_data_lake_storage_gen2_source_arm_name      = formatdate("'dataset_data_lake_storage_gen2_source'YYYYMMDDhhmmss", timestamp())
  dataset_data_lake_storage_gen2_destination_arm_name = formatdate("'dataset_data_lake_storage_gen2_destination'YYYYMMDDhhmmss", timestamp())
}

resource "azurerm_data_factory" "adf" {
  name                = local.azurerm_data_factory_name
  location            = data.azurerm_resource_group.logging.location
  resource_group_name = data.azurerm_resource_group.logging.name
  identity {
    type = "SystemAssigned"
  }
  depends_on = [
    module.data_storage_internal
  ]
}


resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "external" {
  name                 = "external"
  data_factory_id      = azurerm_data_factory.adf.id
  use_managed_identity = true
  //service_principal_id  = data.azurerm_client_config.current.client_id
  //service_principal_key = "exampleKey"
  url = module.data_storage_external.primary_dfs_endpoint

}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "internal" {
  name                 = "internal"
  data_factory_id      = azurerm_data_factory.adf.id
  use_managed_identity = true
  //  service_principal_id  = data.azurerm_client_config.current.client_id
  //  service_principal_key = "exampleKey"
  url = module.data_storage_internal.primary_dfs_endpoint
}

## Diagnostis
data "azurerm_monitor_diagnostic_categories" "adf" {
  resource_id = azurerm_data_factory.adf.id
}

resource "azurerm_monitor_diagnostic_setting" "adf" {
  name                       = azurerm_data_factory.adf.name
  target_resource_id         = azurerm_data_factory.adf.id
  log_analytics_workspace_id = module.core_logging.oms_id

  dynamic "log" {
    iterator = log_category
    for_each = data.azurerm_monitor_diagnostic_categories.adf.logs

    content {
      category = log_category.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.log_retention_days
      }
    }
  }

  dynamic "metric" {
    iterator = metric_category
    for_each = data.azurerm_monitor_diagnostic_categories.adf.metrics

    content {
      category = metric_category.value
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.log_retention_days
      }
    }
  }
}

data "local_file" "linked_databricks" {
  filename = "${path.module}/arm/linked_databricks.json"
}

resource "azurerm_resource_group_template_deployment" "linked_databricks" {
  name                = local.databricks_link_name
  resource_group_name = data.azurerm_resource_group.logging.name
  template_content    = data.local_file.linked_databricks.content
  deployment_mode     = "Incremental"

  parameters_content = jsonencode({ dataFactoryName = azurerm_data_factory.adf.name
    location            = data.azurerm_resource_group.logging.location
    domain              = format("https://%s", azurerm_databricks_workspace.databricks.workspace_url)
    workspaceResourceId = azurerm_databricks_workspace.databricks.id
    clusterId           = databricks_cluster.my-cluster.id
    }
  )
  depends_on = [
    azurerm_databricks_workspace.databricks,
    databricks_cluster.my-cluster,
    azurerm_data_factory.adf
  ]
}



# datasets



# resource "azurerm_data_factory_linked_service_azure_blob_storage" "external" {
#   name                = "external"
#   resource_group_name = data.azurerm_resource_group.logging.name
#   data_factory_name   = azurerm_data_factory.adf.name
#   connection_string   = module.data_storage_external.primary_connection_string

#   depends_on = [
#     module.data_storage_external
#   ]
# }

# resource "azurerm_data_factory_linked_service_azure_blob_storage" "internal" {
#   name                = "internal"
#   resource_group_name = data.azurerm_resource_group.logging.name
#   data_factory_name   = azurerm_data_factory.adf.name
#   connection_string   = module.data_storage_internal.primary_connection_string

#   depends_on = [
#     module.data_storage_internal
#   ]
# }

# resource "azurerm_data_factory_dataset_azure_blob" "external" {
#   name                = "from_external"
#   resource_group_name = data.azurerm_resource_group.logging.name
#   data_factory_name   = azurerm_data_factory.adf.name
#   linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.external.name
# }

# resource "azurerm_data_factory_dataset_azure_blob" "internal" {
#   name                = "to_internal"
#   resource_group_name = data.azurerm_resource_group.logging.name
#   data_factory_name   = azurerm_data_factory.adf.name
#   linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.internal.name
# }


