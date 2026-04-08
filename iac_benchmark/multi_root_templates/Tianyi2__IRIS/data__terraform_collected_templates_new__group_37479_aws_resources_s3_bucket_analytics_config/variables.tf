variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the bucket this analytics configuration is associated with."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket))
    error_message = "resource_aws_s3_bucket_analytics_configuration, bucket must be a valid S3 bucket name."
  }
}

variable "name" {
  description = "Unique identifier of the analytics configuration for the bucket."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "resource_aws_s3_bucket_analytics_configuration, name must be between 1 and 64 characters long."
  }
}

variable "filter" {
  description = "Object filtering that accepts a prefix, tags, or a logical AND of prefix and tags."
  type = object({
    prefix = optional(string)
    tags   = optional(map(string))
  })
  default = null

  validation {
    condition = var.filter == null || (
      var.filter.prefix != null || var.filter.tags != null
    )
    error_message = "resource_aws_s3_bucket_analytics_configuration, filter must specify at least prefix or tags when defined."
  }
}

variable "storage_class_analysis" {
  description = "Configuration for the analytics data export."
  type = object({
    data_export = object({
      output_schema_version = optional(string, "V_1")
      destination = object({
        s3_bucket_destination = object({
          bucket_arn        = string
          bucket_account_id = optional(string)
          format            = optional(string, "CSV")
          prefix            = optional(string)
        })
      })
    })
  })
  default = null

  validation {
    condition = var.storage_class_analysis == null || (
      var.storage_class_analysis.data_export.output_schema_version == null ||
      var.storage_class_analysis.data_export.output_schema_version == "V_1"
    )
    error_message = "resource_aws_s3_bucket_analytics_configuration, output_schema_version must be V_1."
  }

  validation {
    condition = var.storage_class_analysis == null || (
      var.storage_class_analysis.data_export.destination.s3_bucket_destination.format == null ||
      var.storage_class_analysis.data_export.destination.s3_bucket_destination.format == "CSV"
    )
    error_message = "resource_aws_s3_bucket_analytics_configuration, format must be CSV."
  }

  validation {
    condition = var.storage_class_analysis == null || (
      can(regex("^arn:aws:s3:::", var.storage_class_analysis.data_export.destination.s3_bucket_destination.bucket_arn))
    )
    error_message = "resource_aws_s3_bucket_analytics_configuration, bucket_arn must be a valid S3 bucket ARN."
  }
}