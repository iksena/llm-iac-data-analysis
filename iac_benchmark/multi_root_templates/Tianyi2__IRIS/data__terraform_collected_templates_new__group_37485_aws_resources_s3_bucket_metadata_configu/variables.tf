variable "bucket" {
  description = "General purpose bucket that you want to create the metadata configuration for."
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "resource_aws_s3_bucket_metadata_configuration, bucket must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "metadata_configuration" {
  description = "Metadata configuration."
  type = object({
    inventory_table_configuration = object({
      configuration_state = string
      encryption_configuration = optional(object({
        sse_algorithm = string
        kms_key_arn   = optional(string)
      }))
    })
    journal_table_configuration = object({
      encryption_configuration = optional(object({
        sse_algorithm = string
        kms_key_arn   = optional(string)
      }))
      record_expiration = object({
        days       = optional(number)
        expiration = string
      })
    })
  })

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.metadata_configuration.inventory_table_configuration.configuration_state)
    error_message = "resource_aws_s3_bucket_metadata_configuration, configuration_state must be either 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition     = var.metadata_configuration.inventory_table_configuration.encryption_configuration == null || contains(["aws:kms", "AES256"], var.metadata_configuration.inventory_table_configuration.encryption_configuration.sse_algorithm)
    error_message = "resource_aws_s3_bucket_metadata_configuration, inventory_table_configuration.encryption_configuration.sse_algorithm must be either 'aws:kms' or 'AES256'."
  }

  validation {
    condition     = var.metadata_configuration.journal_table_configuration.encryption_configuration == null || contains(["aws:kms", "AES256"], var.metadata_configuration.journal_table_configuration.encryption_configuration.sse_algorithm)
    error_message = "resource_aws_s3_bucket_metadata_configuration, journal_table_configuration.encryption_configuration.sse_algorithm must be either 'aws:kms' or 'AES256'."
  }

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.metadata_configuration.journal_table_configuration.record_expiration.expiration)
    error_message = "resource_aws_s3_bucket_metadata_configuration, record_expiration.expiration must be either 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition     = var.metadata_configuration.journal_table_configuration.record_expiration.days == null || var.metadata_configuration.journal_table_configuration.record_expiration.days > 0
    error_message = "resource_aws_s3_bucket_metadata_configuration, record_expiration.days must be greater than 0 when specified."
  }

  validation {
    condition     = var.metadata_configuration.inventory_table_configuration.encryption_configuration == null || var.metadata_configuration.inventory_table_configuration.encryption_configuration.sse_algorithm != "aws:kms" || var.metadata_configuration.inventory_table_configuration.encryption_configuration.kms_key_arn != null
    error_message = "resource_aws_s3_bucket_metadata_configuration, inventory_table_configuration.encryption_configuration.kms_key_arn is required when sse_algorithm is 'aws:kms'."
  }

  validation {
    condition     = var.metadata_configuration.journal_table_configuration.encryption_configuration == null || var.metadata_configuration.journal_table_configuration.encryption_configuration.sse_algorithm != "aws:kms" || var.metadata_configuration.journal_table_configuration.encryption_configuration.kms_key_arn != null
    error_message = "resource_aws_s3_bucket_metadata_configuration, journal_table_configuration.encryption_configuration.kms_key_arn is required when sse_algorithm is 'aws:kms'."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "30m")
  })
  default = {}
}