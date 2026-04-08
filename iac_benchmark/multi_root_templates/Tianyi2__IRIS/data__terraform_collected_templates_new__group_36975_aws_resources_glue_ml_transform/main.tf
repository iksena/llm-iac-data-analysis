resource "aws_glue_ml_transform" "this" {
  name     = var.name
  role_arn = var.role_arn

  dynamic "input_record_tables" {
    for_each = var.input_record_tables
    content {
      database_name   = input_record_tables.value.database_name
      table_name      = input_record_tables.value.table_name
      catalog_id      = input_record_tables.value.catalog_id
      connection_name = input_record_tables.value.connection_name
    }
  }

  parameters {
    transform_type = var.parameters.transform_type

    dynamic "find_matches_parameters" {
      for_each = var.parameters.find_matches_parameters != null ? [var.parameters.find_matches_parameters] : []
      content {
        accuracy_cost_trade_off    = find_matches_parameters.value.accuracy_cost_trade_off
        enforce_provided_labels    = find_matches_parameters.value.enforce_provided_labels
        precision_recall_trade_off = find_matches_parameters.value.precision_recall_trade_off
        primary_key_column_name    = find_matches_parameters.value.primary_key_column_name
      }
    }
  }

  description       = var.description
  glue_version      = var.glue_version
  max_capacity      = var.max_capacity
  max_retries       = var.max_retries
  tags              = var.tags
  timeout           = var.timeout
  worker_type       = var.worker_type
  number_of_workers = var.number_of_workers
}