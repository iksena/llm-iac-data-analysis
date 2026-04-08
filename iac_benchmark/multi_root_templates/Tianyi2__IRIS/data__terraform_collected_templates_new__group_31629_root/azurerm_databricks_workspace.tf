locals {
  private_databricks_name     = format("%sprivatedatabricks", local.prefix)
  public_databricks_name      = format("%spublicdatabricks", local.prefix)
  workspace_name              = format("%sworkspace", local.prefix)
  managed_resource_group_name = format("%s-managed-rg", data.azurerm_resource_group.logging.name)
  db_logging_name             = format("%s_logging", local.workspace_name)
}

data "databricks_spark_version" "latest" {}

data "databricks_node_type" "smallest" {
  local_disk = false
}

provider "databricks" {
  host = azurerm_databricks_workspace.databricks.workspace_url
}

resource "azurerm_databricks_workspace" "databricks" {
  name                        = local.workspace_name
  resource_group_name         = data.azurerm_resource_group.logging.name
  location                    = data.azurerm_resource_group.logging.location
  sku                         = "premium"
  managed_resource_group_name = local.managed_resource_group_name
}


module "databricks_logging" {
  source  = "./databricks_logging"
  ai_key  = module.core_logging.ai_key
  oms_id  = module.core_logging.oms_id
  oms_key = module.core_logging.oms_key
  depends_on = [
    azurerm_databricks_workspace.databricks,
    module.core_logging
  ]
}

resource "databricks_cluster" "my-cluster" {
  spark_version = "7.3.x-scala2.12"
  node_type_id  = "Standard_DS3_v2"
  num_workers   = 1
  cluster_name  = "logging cluster"


  library {
    pypi {
      package = "applicationinsights==0.11.9"
    }
  }

  init_scripts {
    dbfs {
      destination = module.databricks_logging.cluster_init_script
    }
  }
}