resource "aws_lakeformation_resource_lf_tag" "this" {
  region     = var.region
  catalog_id = var.catalog_id

  lf_tag {
    key        = var.lf_tag.key
    value      = var.lf_tag.value
    catalog_id = var.lf_tag.catalog_id
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
      column_names  = table_with_columns.value.column_names
      database_name = table_with_columns.value.database_name
      name          = table_with_columns.value.name
      catalog_id    = table_with_columns.value.catalog_id

      dynamic "column_wildcard" {
        for_each = table_with_columns.value.column_wildcard != null ? [table_with_columns.value.column_wildcard] : []
        content {
          excluded_column_names = column_wildcard.value.excluded_column_names
        }
      }
    }
  }

  timeouts {
    create = "20m"
    delete = "20m"
  }
}