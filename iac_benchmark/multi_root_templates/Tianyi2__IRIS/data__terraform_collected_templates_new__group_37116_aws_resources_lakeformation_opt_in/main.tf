resource "aws_lakeformation_opt_in" "this" {
  region = var.region
  dynamic "principal" {
    for_each = var.principal != null ? [var.principal] : []
    content {
      data_lake_principal_identifier = principal.value.data_lake_principal_identifier
    }
  }
  dynamic "resource_data" {
    for_each = var.resource_data != null ? [var.resource_data] : []
    content {
      dynamic "data_location" {
        for_each = resource_data.value.data_location != null ? [resource_data.value.data_location] : []
        content {
          resource_arn = data_location.value.resource_arn
        }
      }

      dynamic "database" {
        for_each = resource_data.value.database != null ? [resource_data.value.database] : []
        content {
          catalog_id = database.value.catalog_id
          name       = database.value.name
        }
      }

      dynamic "table" {
        for_each = resource_data.value.table != null ? [resource_data.value.table] : []
        content {
          catalog_id    = table.value.catalog_id
          database_name = table.value.database_name
          name          = table.value.name
          wildcard      = table.value.wildcard
        }
      }
    }
  }

}