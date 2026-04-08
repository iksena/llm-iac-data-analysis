resource "aws_lakeformation_permissions" "this" {
  permissions                   = var.permissions
  principal                     = var.principal
  catalog_resource              = var.catalog_resource
  catalog_id                    = var.catalog_id
  permissions_with_grant_option = var.permissions_with_grant_option

  dynamic "data_cells_filter" {
    for_each = var.data_cells_filter != null ? [var.data_cells_filter] : []
    content {
      database_name    = data_cells_filter.value.database_name
      name             = data_cells_filter.value.name
      table_catalog_id = data_cells_filter.value.table_catalog_id
      table_name       = data_cells_filter.value.table_name
    }
  }

  dynamic "data_location" {
    for_each = var.data_location != null ? [var.data_location] : []
    content {
      arn        = data_location.value.arn
      catalog_id = data_location.value.catalog_id
    }
  }

  dynamic "database" {
    for_each = var.database != null ? [var.database] : []
    content {
      name       = database.value.name
      catalog_id = database.value.catalog_id
    }
  }

  dynamic "lf_tag" {
    for_each = var.lf_tag != null ? [var.lf_tag] : []
    content {
      key        = lf_tag.value.key
      values     = lf_tag.value.values
      catalog_id = lf_tag.value.catalog_id
    }
  }

  dynamic "lf_tag_policy" {
    for_each = var.lf_tag_policy != null ? [var.lf_tag_policy] : []
    content {
      resource_type = lf_tag_policy.value.resource_type
      catalog_id    = lf_tag_policy.value.catalog_id

      dynamic "expression" {
        for_each = lf_tag_policy.value.expression
        content {
          key    = expression.value.key
          values = expression.value.values
        }
      }
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