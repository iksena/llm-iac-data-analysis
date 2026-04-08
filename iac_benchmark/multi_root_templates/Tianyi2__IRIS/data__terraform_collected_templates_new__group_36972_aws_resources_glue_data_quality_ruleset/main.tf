resource "aws_glue_data_quality_ruleset" "this" {
  region      = var.region
  description = var.description
  name        = var.name
  ruleset     = var.ruleset
  tags        = var.tags

  dynamic "target_table" {
    for_each = var.target_table != null ? [var.target_table] : []
    content {
      catalog_id    = target_table.value.catalog_id
      database_name = target_table.value.database_name
      table_name    = target_table.value.table_name
    }
  }
}