variable "name" {
  description = "Name of the table bucket. Must be between 3 and 63 characters in length. Can consist of lowercase letters, numbers, and hyphens, and must begin and end with a lowercase letter or number."
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 63
    error_message = "resource_aws_s3tables_table_bucket, name must be between 3 and 63 characters in length."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.name))
    error_message = "resource_aws_s3tables_table_bucket, name must consist of lowercase letters, numbers, and hyphens, and must begin and end with a lowercase letter or number."
  }
}

variable "encryption_configuration" {
  description = "A single table bucket encryption configuration object."
  type = object({
    kms_key_arn   = optional(string)
    sse_algorithm = string
  })
  default = null

  validation {
    condition = var.encryption_configuration == null || (
      var.encryption_configuration.sse_algorithm != null &&
      contains(["aws:kms", "AES256"], var.encryption_configuration.sse_algorithm)
    )
    error_message = "resource_aws_s3tables_table_bucket, encryption_configuration.sse_algorithm must be one of 'aws:kms' or 'AES256'."
  }
}

variable "force_destroy" {
  description = "Whether all tables and namespaces within the table bucket should be deleted when the table bucket is destroyed so that the table bucket can be destroyed without error."
  type        = bool
  default     = false
}

variable "maintenance_configuration" {
  description = "A single table bucket maintenance configuration object."
  type = object({
    iceberg_unreferenced_file_removal = object({
      settings = object({
        non_current_days  = number
        unreferenced_days = number
      })
      status = string
    })
  })
  default = null

  validation {
    condition = var.maintenance_configuration == null || (
      var.maintenance_configuration.iceberg_unreferenced_file_removal.status != null &&
      contains(["enabled", "disabled"], var.maintenance_configuration.iceberg_unreferenced_file_removal.status)
    )
    error_message = "resource_aws_s3tables_table_bucket, maintenance_configuration.iceberg_unreferenced_file_removal.status must be 'enabled' or 'disabled'."
  }

  validation {
    condition = var.maintenance_configuration == null || (
      var.maintenance_configuration.iceberg_unreferenced_file_removal.settings.non_current_days >= 1
    )
    error_message = "resource_aws_s3tables_table_bucket, maintenance_configuration.iceberg_unreferenced_file_removal.settings.non_current_days must be at least 1."
  }

  validation {
    condition = var.maintenance_configuration == null || (
      var.maintenance_configuration.iceberg_unreferenced_file_removal.settings.unreferenced_days >= 1
    )
    error_message = "resource_aws_s3tables_table_bucket, maintenance_configuration.iceberg_unreferenced_file_removal.settings.unreferenced_days must be at least 1."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}