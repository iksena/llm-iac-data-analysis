resource "aws_glue_catalog_table_optimizer" "this" {
  catalog_id    = var.catalog_id
  database_name = var.database_name
  table_name    = var.table_name
  type          = var.type
  region        = var.region

  configuration {
    enabled  = var.configuration.enabled
    role_arn = var.configuration.role_arn

    dynamic "retention_configuration" {
      for_each = var.configuration.retention_configuration != null ? [var.configuration.retention_configuration] : []
      content {
        dynamic "iceberg_configuration" {
          for_each = retention_configuration.value.iceberg_configuration != null ? [retention_configuration.value.iceberg_configuration] : []
          content {
            snapshot_retention_period_in_days = iceberg_configuration.value.snapshot_retention_period_in_days
            number_of_snapshots_to_retain     = iceberg_configuration.value.number_of_snapshots_to_retain
            clean_expired_files               = iceberg_configuration.value.clean_expired_files
            run_rate_in_hours                 = iceberg_configuration.value.run_rate_in_hours
          }
        }
      }
    }

    dynamic "orphan_file_deletion_configuration" {
      for_each = var.configuration.orphan_file_deletion_configuration != null ? [var.configuration.orphan_file_deletion_configuration] : []
      content {
        dynamic "iceberg_configuration" {
          for_each = orphan_file_deletion_configuration.value.iceberg_configuration != null ? [orphan_file_deletion_configuration.value.iceberg_configuration] : []
          content {
            orphan_file_retention_period_in_days = iceberg_configuration.value.orphan_file_retention_period_in_days
            location                             = iceberg_configuration.value.location
            run_rate_in_hours                    = iceberg_configuration.value.run_rate_in_hours
          }
        }
      }
    }
  }
}