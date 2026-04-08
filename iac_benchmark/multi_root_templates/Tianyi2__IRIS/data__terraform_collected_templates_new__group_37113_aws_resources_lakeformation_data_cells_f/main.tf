resource "aws_lakeformation_data_cells_filter" "this" {
  region = var.region

  table_data {
    database_name    = var.table_data.database_name
    name             = var.table_data.name
    table_catalog_id = var.table_data.table_catalog_id
    table_name       = var.table_data.table_name
    column_names     = var.table_data.column_names
    version_id       = var.table_data.version_id

    dynamic "column_wildcard" {
      for_each = var.table_data.column_wildcard != null ? [var.table_data.column_wildcard] : []
      content {
        excluded_column_names = column_wildcard.value.excluded_column_names
      }
    }

    dynamic "row_filter" {
      for_each = var.table_data.row_filter != null ? [var.table_data.row_filter] : []
      content {
        dynamic "all_rows_wildcard" {
          for_each = row_filter.value.all_rows_wildcard != null ? [row_filter.value.all_rows_wildcard] : []
          content {}
        }
        filter_expression = row_filter.value.filter_expression
      }
    }
  }

  timeouts {
    create = var.timeouts.create
  }
}