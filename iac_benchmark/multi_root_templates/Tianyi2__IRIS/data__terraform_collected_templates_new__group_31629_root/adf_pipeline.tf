
resource "azurerm_role_assignment" "external_adf" {
  scope                = module.data_storage_external.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_data_factory.adf.identity[0].principal_id

  depends_on = [
    module.data_storage_external,
    azurerm_data_factory.adf
  ]
}

resource "azurerm_role_assignment" "internal_adf" {
  scope                = module.data_storage_internal.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.adf.identity[0].principal_id

  depends_on = [
    module.data_storage_internal,
    azurerm_data_factory.adf
  ]
}

resource "azurerm_role_assignment" "adf_databricks" {
  scope                = azurerm_databricks_workspace.databricks.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_data_factory.adf.identity[0].principal_id

  depends_on = [
    azurerm_databricks_workspace.databricks,
    azurerm_data_factory.adf
  ]
}


data "local_file" "dataset_data_lake_storage_gen2" {
  filename = "${path.module}/adf/dataset_data_lake_storage_gen2.json"
}

resource "azurerm_resource_group_template_deployment" "dataset_data_lake_storage_gen2_source" {
  name                = "dataset_source"
  resource_group_name = data.azurerm_resource_group.logging.name
  template_content    = data.local_file.dataset_data_lake_storage_gen2.content
  deployment_mode     = "Incremental"

  parameters_content = jsonencode({
    data_factory_id   = azurerm_data_factory.adf.id
    location          = data.azurerm_resource_group.logging.location
    context           = "external"
    linkedServiceName = azurerm_data_factory_linked_service_data_lake_storage_gen2.external.name
    container         = "source"
    }
  )
  depends_on = [
    azurerm_databricks_workspace.databricks,
    databricks_cluster.my-cluster,
    azurerm_data_factory.adf
  ]
}

resource "azurerm_resource_group_template_deployment" "dataset_data_lake_storage_gen2_destination" {
  name                = "dataset_destination"
  resource_group_name = data.azurerm_resource_group.logging.name
  template_content    = data.local_file.dataset_data_lake_storage_gen2.content
  deployment_mode     = "Incremental"

  parameters_content = jsonencode({
    dataFactoryName   = azurerm_data_factory.adf.name
    location          = data.azurerm_resource_group.logging.location
    context           = "internal"
    linkedServiceName = azurerm_data_factory_linked_service_data_lake_storage_gen2.internal.name
    container         = "destination"
    }
  )
  depends_on = [
    azurerm_databricks_workspace.databricks,
    databricks_cluster.my-cluster,
    azurerm_data_factory.adf
  ]
}


data "template_file" "pipeline_external_internal" {
  template = templatefile("${path.module}/adf/pipeline_external_internal.json.tpl", {
    input                     = azurerm_data_factory_linked_service_data_lake_storage_gen2.external.name
    output                    = azurerm_data_factory_linked_service_data_lake_storage_gen2.internal.name
    databricks_notebook       = databricks_notebook.adf_calling_databricks.path
    databricks_linked_service = "ArmtemplateDatabricksLinkedService"
  })
}

resource "azurerm_data_factory_pipeline" "external_internal" {
  name            = "external_internal"
  data_factory_id = azurerm_data_factory.adf.id
  activities_json = data.template_file.pipeline_external_internal.rendered
}

resource "azurerm_data_factory_trigger_schedule" "external_internal" {
  name            = "external_internal"
  data_factory_id = azurerm_data_factory.adf.id
  pipeline_name   = azurerm_data_factory_pipeline.external_internal.name

  interval  = 5
  frequency = "Minute"
}