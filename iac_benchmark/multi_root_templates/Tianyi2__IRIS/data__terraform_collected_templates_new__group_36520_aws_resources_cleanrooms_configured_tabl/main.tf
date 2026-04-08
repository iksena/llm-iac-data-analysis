resource "aws_cleanrooms_configured_table" "this" {
  name            = var.name
  description     = var.description
  analysis_method = var.analysis_method
  allowed_columns = var.allowed_columns

  table_reference {
    database_name = var.table_reference_database_name
    table_name    = var.table_reference_table_name
  }

  tags = var.tags

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}