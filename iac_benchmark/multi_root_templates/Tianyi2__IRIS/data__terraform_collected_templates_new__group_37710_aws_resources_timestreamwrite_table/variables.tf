variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "database_name" {
  description = "The name of the Timestream database."
  type        = string
}

variable "table_name" {
  description = "The name of the Timestream table."
  type        = string
}

variable "tags" {
  description = "Map of tags to assign to this resource."
  type        = map(string)
  default     = {}
}

variable "magnetic_store_write_properties" {
  description = "Contains properties to set on the table when enabling magnetic store writes."
  type = object({
    enable_magnetic_store_writes = bool
    magnetic_store_rejected_data_location = optional(object({
      s3_configuration = optional(object({
        bucket_name       = optional(string)
        encryption_option = optional(string)
        kms_key_id        = optional(string)
        object_key_prefix = optional(string)
      }))
    }))
  })
  default = null

  validation {
    condition     = var.magnetic_store_write_properties == null || var.magnetic_store_write_properties.enable_magnetic_store_writes != null
    error_message = "resource_aws_timestreamwrite_table, magnetic_store_write_properties.enable_magnetic_store_writes is required when magnetic_store_write_properties is specified."
  }

  validation {
    condition     = var.magnetic_store_write_properties == null || var.magnetic_store_write_properties.magnetic_store_rejected_data_location == null || var.magnetic_store_write_properties.magnetic_store_rejected_data_location.s3_configuration == null || var.magnetic_store_write_properties.magnetic_store_rejected_data_location.s3_configuration.encryption_option == null || contains(["SSE_KMS", "SSE_S3"], var.magnetic_store_write_properties.magnetic_store_rejected_data_location.s3_configuration.encryption_option)
    error_message = "resource_aws_timestreamwrite_table, magnetic_store_write_properties.magnetic_store_rejected_data_location.s3_configuration.encryption_option must be one of: SSE_KMS, SSE_S3."
  }
}

variable "retention_properties" {
  description = "The retention duration for the memory store and magnetic store."
  type = object({
    magnetic_store_retention_period_in_days = number
    memory_store_retention_period_in_hours  = number
  })
  default = null

  validation {
    condition     = var.retention_properties == null || (var.retention_properties.magnetic_store_retention_period_in_days >= 1 && var.retention_properties.magnetic_store_retention_period_in_days <= 73000)
    error_message = "resource_aws_timestreamwrite_table, retention_properties.magnetic_store_retention_period_in_days must be between 1 and 73000."
  }

  validation {
    condition     = var.retention_properties == null || (var.retention_properties.memory_store_retention_period_in_hours >= 1 && var.retention_properties.memory_store_retention_period_in_hours <= 8766)
    error_message = "resource_aws_timestreamwrite_table, retention_properties.memory_store_retention_period_in_hours must be between 1 and 8766."
  }
}

variable "schema" {
  description = "The schema of the table."
  type = object({
    composite_partition_key = list(object({
      enforcement_in_record = optional(string)
      name                  = optional(string)
      type                  = string
    }))
  })
  default = null

  validation {
    condition     = var.schema == null || (var.schema.composite_partition_key != null && length(var.schema.composite_partition_key) > 0)
    error_message = "resource_aws_timestreamwrite_table, schema.composite_partition_key must be a non-empty list when schema is specified."
  }

  validation {
    condition = var.schema == null || alltrue([
      for key in var.schema.composite_partition_key :
      key.enforcement_in_record == null || contains(["REQUIRED", "OPTIONAL"], key.enforcement_in_record)
    ])
    error_message = "resource_aws_timestreamwrite_table, schema.composite_partition_key.enforcement_in_record must be one of: REQUIRED, OPTIONAL."
  }

  validation {
    condition = var.schema == null || alltrue([
      for key in var.schema.composite_partition_key :
      contains(["DIMENSION", "MEASURE"], key.type)
    ])
    error_message = "resource_aws_timestreamwrite_table, schema.composite_partition_key.type must be one of: DIMENSION, MEASURE."
  }
}