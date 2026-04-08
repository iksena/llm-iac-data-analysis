variable "s3_bucket" {
  description = "Name of the Amazon S3 bucket to export the snapshot to"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9\\-]*[a-z0-9]$", var.s3_bucket)) && length(var.s3_bucket) >= 3 && length(var.s3_bucket) <= 63
    error_message = "resource_aws_dynamodb_table_export, s3_bucket must be a valid S3 bucket name (3-63 characters, lowercase letters, numbers, and hyphens only, cannot start or end with hyphen)."
  }
}

variable "table_arn" {
  description = "ARN associated with the table to export"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:dynamodb:[a-z0-9\\-]+:[0-9]{12}:table/[a-zA-Z0-9_\\-\\.]+$", var.table_arn))
    error_message = "resource_aws_dynamodb_table_export, table_arn must be a valid DynamoDB table ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "export_format" {
  description = "Format for the exported data"
  type        = string
  default     = "DYNAMODB_JSON"

  validation {
    condition     = contains(["DYNAMODB_JSON", "ION"], var.export_format)
    error_message = "resource_aws_dynamodb_table_export, export_format must be either 'DYNAMODB_JSON' or 'ION'."
  }
}

variable "export_time" {
  description = "Time in RFC3339 format from which to export table data"
  type        = string
  default     = null

  validation {
    condition     = var.export_time == null || can(formatdate("RFC3339", var.export_time))
    error_message = "resource_aws_dynamodb_table_export, export_time must be a valid RFC3339 timestamp."
  }
}

variable "export_type" {
  description = "Whether to execute as a full export or incremental export"
  type        = string
  default     = "FULL_EXPORT"

  validation {
    condition     = contains(["FULL_EXPORT", "INCREMENTAL_EXPORT"], var.export_type)
    error_message = "resource_aws_dynamodb_table_export, export_type must be either 'FULL_EXPORT' or 'INCREMENTAL_EXPORT'."
  }
}

variable "incremental_export_specification" {
  description = "Parameters specific to an incremental export"
  type = object({
    export_from_time = optional(string)
    export_to_time   = optional(string)
    export_view_type = optional(string, "NEW_AND_OLD_IMAGES")
  })
  default = null

  validation {
    condition = var.incremental_export_specification == null || (
      var.incremental_export_specification.export_view_type == null ||
      contains(["NEW_AND_OLD_IMAGES", "NEW_IMAGES"], var.incremental_export_specification.export_view_type)
    )
    error_message = "resource_aws_dynamodb_table_export, incremental_export_specification.export_view_type must be either 'NEW_AND_OLD_IMAGES' or 'NEW_IMAGES'."
  }

  validation {
    condition     = var.export_type == "INCREMENTAL_EXPORT" ? var.incremental_export_specification != null : true
    error_message = "resource_aws_dynamodb_table_export, incremental_export_specification must be provided when export_type is 'INCREMENTAL_EXPORT'."
  }
}

variable "s3_bucket_owner" {
  description = "ID of the AWS account that owns the bucket the export will be stored in"
  type        = string
  default     = null

  validation {
    condition     = var.s3_bucket_owner == null || can(regex("^[0-9]{12}$", var.s3_bucket_owner))
    error_message = "resource_aws_dynamodb_table_export, s3_bucket_owner must be a 12-digit AWS account ID."
  }
}

variable "s3_prefix" {
  description = "Amazon S3 bucket prefix to use as the file name and path of the exported snapshot"
  type        = string
  default     = null
}

variable "s3_sse_algorithm" {
  description = "Type of encryption used on the bucket where export data will be stored"
  type        = string
  default     = null

  validation {
    condition     = var.s3_sse_algorithm == null || contains(["AES256", "KMS"], var.s3_sse_algorithm)
    error_message = "resource_aws_dynamodb_table_export, s3_sse_algorithm must be either 'AES256' or 'KMS'."
  }
}

variable "s3_sse_kms_key_id" {
  description = "ID of the AWS KMS managed key used to encrypt the S3 bucket where export data will be stored"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Timeout configuration for create and delete operations"
  type = object({
    create = optional(string, "60m")
    delete = optional(string, "60m")
  })
  default = {}
}