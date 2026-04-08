resource "aws_lakeformation_resource_lf_tags" "this" {
  catalog_id = var.catalog_id
  region     = var.region

  dynamic "lf_tag" {
    for_each = var.lf_tags
    content {
      key        = lf_tag.value.key
      value      = lf_tag.value.value
      catalog_id = lf_tag.value.catalog_id
    }
  }

  dynamic "database" {
    for_each = var.database != null ? [var.database] : []
    content {
      name       = database.value.name
      catalog_id = database.value.catalog_id
    }
  }

  dynamic "table" {
    for_each = var.table != null ? [var.table] : []
    content {
      database_name = table.value.database_name
      name          = table.value.name
      wildcard      = table.value.wildcard
      catalog_id    = table.value.catalog_id
    }
  }

  dynamic "table_with_columns" {
    for_each = var.table_with_columns != null ? [var.table_with_columns] : []
    content {
      column_names          = table_with_columns.value.column_names
      database_name         = table_with_columns.value.database_name
      name                  = table_with_columns.value.name
      wildcard              = table_with_columns.value.wildcard
      catalog_id            = table_with_columns.value.catalog_id
      excluded_column_names = table_with_columns.value.excluded_column_names
    }
  }
}