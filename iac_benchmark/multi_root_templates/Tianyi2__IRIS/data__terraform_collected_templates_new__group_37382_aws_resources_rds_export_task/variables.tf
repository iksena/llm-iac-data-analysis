variable "export_task_identifier" {
  description = "Unique identifier for the snapshot export task"
  type        = string

  validation {
    condition     = length(var.export_task_identifier) > 0
    error_message = "resource_aws_rds_export_task, export_task_identifier must not be empty."
  }
}

variable "iam_role_arn" {
  description = "ARN of the IAM role to use for writing to the Amazon S3 bucket"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.iam_role_arn))
    error_message = "resource_aws_rds_export_task, iam_role_arn must be a valid IAM role ARN."
  }
}

variable "kms_key_id" {
  description = "ID of the Amazon Web Services KMS key to use to encrypt the snapshot"
  type        = string

  validation {
    condition     = length(var.kms_key_id) > 0
    error_message = "resource_aws_rds_export_task, kms_key_id must not be empty."
  }
}

variable "s3_bucket_name" {
  description = "Name of the Amazon S3 bucket to export the snapshot to"
  type        = string

  validation {
    condition     = length(var.s3_bucket_name) > 0 && length(var.s3_bucket_name) <= 63
    error_message = "resource_aws_rds_export_task, s3_bucket_name must be between 1 and 63 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.s3_bucket_name))
    error_message = "resource_aws_rds_export_task, s3_bucket_name must contain only lowercase letters, numbers, dots, and hyphens."
  }
}

variable "source_arn" {
  description = "Amazon Resource Name (ARN) of the snapshot to export"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:rds:", var.source_arn))
    error_message = "resource_aws_rds_export_task, source_arn must be a valid RDS ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "export_only" {
  description = "Data to be exported from the snapshot. If this parameter is not provided, all the snapshot data is exported"
  type        = list(string)
  default     = null
}

variable "s3_prefix" {
  description = "Amazon S3 bucket prefix to use as the file name and path of the exported snapshot"
  type        = string
  default     = null
}