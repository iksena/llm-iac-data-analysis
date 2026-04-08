data "local_file" "databricks_logging_query" {
  filename = "${path.module}/ai_queries/databricks_logging_shared_query.txt"
}

resource "azurerm_application_insights_analytics_item" "databricks_logging_query" {
  name                    = "databricks_logging_query"
  application_insights_id = module.core_logging.ai_id
  content                 = data.local_file.databricks_logging_query.content
  scope                   = "shared"
  type                    = "query"
}