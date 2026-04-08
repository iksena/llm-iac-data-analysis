variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account_id" {
  description = "The AWS account ID for the S3 Storage Lens configuration. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null
}

variable "config_id" {
  description = "The ID of the S3 Storage Lens configuration."
  type        = string

  validation {
    condition     = length(var.config_id) > 0
    error_message = "resource_aws_s3control_storage_lens_configuration, config_id must not be empty."
  }
}

variable "storage_lens_configuration" {
  description = "The S3 Storage Lens configuration."
  type = object({
    enabled = bool

    account_level = object({
      bucket_level = object({
        activity_metrics = optional(object({
          enabled = optional(bool)
        }))
        advanced_cost_optimization_metrics = optional(object({
          enabled = optional(bool)
        }))
        advanced_data_protection_metrics = optional(object({
          enabled = optional(bool)
        }))
        detailed_status_code_metrics = optional(object({
          enabled = optional(bool)
        }))
        prefix_level = optional(object({
          storage_metrics = object({
            enabled = optional(bool)
            selection_criteria = optional(object({
              delimiter                    = optional(string)
              max_depth                    = optional(number)
              min_storage_bytes_percentage = optional(number)
            }))
          })
        }))
      })
      activity_metrics = optional(object({
        enabled = optional(bool)
      }))
      advanced_cost_optimization_metrics = optional(object({
        enabled = optional(bool)
      }))
      advanced_data_protection_metrics = optional(object({
        enabled = optional(bool)
      }))
      detailed_status_code_metrics = optional(object({
        enabled = optional(bool)
      }))
    })

    aws_org = optional(object({
      arn = string
    }))

    data_export = optional(object({
      cloud_watch_metrics = optional(object({
        enabled = bool
      }))
      s3_bucket_destination = optional(object({
        account_id            = string
        arn                   = string
        format                = string
        output_schema_version = string
        prefix                = optional(string)
        encryption = optional(object({
          sse_kms = optional(object({
            key_id = string
          }))
          sse_s3 = optional(object({}))
        }))
      }))
    }))

    exclude = optional(object({
      buckets = optional(list(string))
      regions = optional(list(string))
    }))

    include = optional(object({
      buckets = optional(list(string))
      regions = optional(list(string))
    }))
  })

  validation {
    condition     = var.storage_lens_configuration.enabled != null
    error_message = "resource_aws_s3control_storage_lens_configuration, storage_lens_configuration.enabled is required."
  }

  validation {
    condition     = var.storage_lens_configuration.account_level != null
    error_message = "resource_aws_s3control_storage_lens_configuration, storage_lens_configuration.account_level is required."
  }

  validation {
    condition     = var.storage_lens_configuration.account_level.bucket_level != null
    error_message = "resource_aws_s3control_storage_lens_configuration, storage_lens_configuration.account_level.bucket_level is required."
  }

  validation {
    condition     = var.storage_lens_configuration.exclude == null || var.storage_lens_configuration.include == null
    error_message = "resource_aws_s3control_storage_lens_configuration, storage_lens_configuration.exclude and storage_lens_configuration.include are mutually exclusive."
  }

  validation {
    condition     = var.storage_lens_configuration.data_export == null || var.storage_lens_configuration.data_export.cloud_watch_metrics == null || var.storage_lens_configuration.data_export.cloud_watch_metrics.enabled != null
    error_message = "resource_aws_s3control_storage_lens_configuration, storage_lens_configuration.data_export.cloud_watch_metrics.enabled is required when cloud_watch_metrics block is specified."
  }

  validation {
    condition = var.storage_lens_configuration.data_export == null || var.storage_lens_configuration.data_export.s3_bucket_destination == null || (
      var.storage_lens_configuration.data_export.s3_bucket_destination.account_id != null &&
      var.storage_lens_configuration.data_export.s3_bucket_destination.arn != null &&
      var.storage_lens_configuration.data_export.s3_bucket_destination.format != null &&
      var.storage_lens_configuration.data_export.s3_bucket_destination.output_schema_version != null
    )
    error_message = "resource_aws_s3control_storage_lens_configuration, storage_lens_configuration.data_export.s3_bucket_destination requires account_id, arn, format, and output_schema_version."
  }

  validation {
    condition     = var.storage_lens_configuration.data_export == null || var.storage_lens_configuration.data_export.s3_bucket_destination == null || contains(["CSV", "Parquet"], var.storage_lens_configuration.data_export.s3_bucket_destination.format)
    error_message = "resource_aws_s3control_storage_lens_configuration, storage_lens_configuration.data_export.s3_bucket_destination.format must be either 'CSV' or 'Parquet'."
  }

  validation {
    condition     = var.storage_lens_configuration.data_export == null || var.storage_lens_configuration.data_export.s3_bucket_destination == null || var.storage_lens_configuration.data_export.s3_bucket_destination.output_schema_version == "V_1"
    error_message = "resource_aws_s3control_storage_lens_configuration, storage_lens_configuration.data_export.s3_bucket_destination.output_schema_version must be 'V_1'."
  }

  validation {
    condition     = var.storage_lens_configuration.data_export == null || var.storage_lens_configuration.data_export.s3_bucket_destination == null || var.storage_lens_configuration.data_export.s3_bucket_destination.encryption == null || var.storage_lens_configuration.data_export.s3_bucket_destination.encryption.sse_kms == null || var.storage_lens_configuration.data_export.s3_bucket_destination.encryption.sse_kms.key_id != null
    error_message = "resource_aws_s3control_storage_lens_configuration, storage_lens_configuration.data_export.s3_bucket_destination.encryption.sse_kms.key_id is required when sse_kms block is specified."
  }

  validation {
    condition     = var.storage_lens_configuration.aws_org == null || var.storage_lens_configuration.aws_org.arn != null
    error_message = "resource_aws_s3control_storage_lens_configuration, storage_lens_configuration.aws_org.arn is required when aws_org block is specified."
  }

  validation {
    condition     = var.storage_lens_configuration.account_level.bucket_level.prefix_level == null || var.storage_lens_configuration.account_level.bucket_level.prefix_level.storage_metrics != null
    error_message = "resource_aws_s3control_storage_lens_configuration, storage_lens_configuration.account_level.bucket_level.prefix_level.storage_metrics is required when prefix_level block is specified."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}