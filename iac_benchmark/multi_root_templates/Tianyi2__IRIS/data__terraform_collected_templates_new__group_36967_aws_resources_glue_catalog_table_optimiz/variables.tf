variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "catalog_id" {
  description = "The Catalog ID of the table."
  type        = string

  validation {
    condition     = var.catalog_id != null && var.catalog_id != ""
    error_message = "resource_aws_glue_catalog_table_optimizer, catalog_id cannot be null or empty."
  }
}

variable "database_name" {
  description = "The name of the database in the catalog in which the table resides."
  type        = string

  validation {
    condition     = var.database_name != null && var.database_name != ""
    error_message = "resource_aws_glue_catalog_table_optimizer, database_name cannot be null or empty."
  }
}

variable "table_name" {
  description = "The name of the table."
  type        = string

  validation {
    condition     = var.table_name != null && var.table_name != ""
    error_message = "resource_aws_glue_catalog_table_optimizer, table_name cannot be null or empty."
  }
}

variable "type" {
  description = "The type of table optimizer. Valid values are compaction, retention, and orphan_file_deletion."
  type        = string

  validation {
    condition     = contains(["compaction", "retention", "orphan_file_deletion"], var.type)
    error_message = "resource_aws_glue_catalog_table_optimizer, type must be one of: compaction, retention, orphan_file_deletion."
  }
}

variable "configuration" {
  description = "A configuration block that defines the table optimizer settings."
  type = object({
    enabled  = bool
    role_arn = string
    retention_configuration = optional(object({
      iceberg_configuration = optional(object({
        snapshot_retention_period_in_days = optional(number)
        number_of_snapshots_to_retain     = optional(number)
        clean_expired_files               = optional(bool)
        run_rate_in_hours                 = optional(number)
      }))
    }))
    orphan_file_deletion_configuration = optional(object({
      iceberg_configuration = optional(object({
        orphan_file_retention_period_in_days = optional(number)
        location                             = optional(string)
        run_rate_in_hours                    = optional(number)
      }))
    }))
  })

  validation {
    condition     = var.configuration.role_arn != null && var.configuration.role_arn != ""
    error_message = "resource_aws_glue_catalog_table_optimizer, configuration.role_arn cannot be null or empty."
  }

  validation {
    condition = var.configuration.retention_configuration != null ? (
      var.configuration.retention_configuration.iceberg_configuration != null ? (
        var.configuration.retention_configuration.iceberg_configuration.snapshot_retention_period_in_days == null ||
        var.configuration.retention_configuration.iceberg_configuration.snapshot_retention_period_in_days >= 1
      ) : true
    ) : true
    error_message = "resource_aws_glue_catalog_table_optimizer, configuration.retention_configuration.iceberg_configuration.snapshot_retention_period_in_days must be at least 1 day."
  }

  validation {
    condition = var.configuration.retention_configuration != null ? (
      var.configuration.retention_configuration.iceberg_configuration != null ? (
        var.configuration.retention_configuration.iceberg_configuration.number_of_snapshots_to_retain == null ||
        var.configuration.retention_configuration.iceberg_configuration.number_of_snapshots_to_retain >= 1
      ) : true
    ) : true
    error_message = "resource_aws_glue_catalog_table_optimizer, configuration.retention_configuration.iceberg_configuration.number_of_snapshots_to_retain must be at least 1."
  }

  validation {
    condition = var.configuration.orphan_file_deletion_configuration != null ? (
      var.configuration.orphan_file_deletion_configuration.iceberg_configuration != null ? (
        var.configuration.orphan_file_deletion_configuration.iceberg_configuration.orphan_file_retention_period_in_days == null ||
        var.configuration.orphan_file_deletion_configuration.iceberg_configuration.orphan_file_retention_period_in_days >= 1
      ) : true
    ) : true
    error_message = "resource_aws_glue_catalog_table_optimizer, configuration.orphan_file_deletion_configuration.iceberg_configuration.orphan_file_retention_period_in_days must be at least 1 day."
  }

  validation {
    condition = var.configuration.retention_configuration != null ? (
      var.configuration.retention_configuration.iceberg_configuration != null ? (
        var.configuration.retention_configuration.iceberg_configuration.run_rate_in_hours == null ||
        var.configuration.retention_configuration.iceberg_configuration.run_rate_in_hours >= 1
      ) : true
    ) : true
    error_message = "resource_aws_glue_catalog_table_optimizer, configuration.retention_configuration.iceberg_configuration.run_rate_in_hours must be at least 1 hour."
  }

  validation {
    condition = var.configuration.orphan_file_deletion_configuration != null ? (
      var.configuration.orphan_file_deletion_configuration.iceberg_configuration != null ? (
        var.configuration.orphan_file_deletion_configuration.iceberg_configuration.run_rate_in_hours == null ||
        var.configuration.orphan_file_deletion_configuration.iceberg_configuration.run_rate_in_hours >= 1
      ) : true
    ) : true
    error_message = "resource_aws_glue_catalog_table_optimizer, configuration.orphan_file_deletion_configuration.iceberg_configuration.run_rate_in_hours must be at least 1 hour."
  }
}