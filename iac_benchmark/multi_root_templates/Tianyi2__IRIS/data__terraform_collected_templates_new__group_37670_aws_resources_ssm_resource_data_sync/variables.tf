variable "name" {
  description = "Name for the configuration."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ssm_resource_data_sync, name must not be empty."
  }
}

variable "s3_destination" {
  description = "Amazon S3 configuration details for the sync."
  type = object({
    bucket_name = string
    region      = string
    kms_key_arn = optional(string)
    prefix      = optional(string)
    sync_format = optional(string, "JsonSerDe")
  })

  validation {
    condition     = length(var.s3_destination.bucket_name) > 0
    error_message = "resource_aws_ssm_resource_data_sync, bucket_name must not be empty."
  }

  validation {
    condition     = length(var.s3_destination.region) > 0
    error_message = "resource_aws_ssm_resource_data_sync, region must not be empty."
  }

  validation {
    condition     = var.s3_destination.kms_key_arn == null || can(regex("^arn:aws:kms:", var.s3_destination.kms_key_arn))
    error_message = "resource_aws_ssm_resource_data_sync, kms_key_arn must be a valid KMS key ARN starting with 'arn:aws:kms:'."
  }

  validation {
    condition     = var.s3_destination.sync_format == null || contains(["JsonSerDe"], var.s3_destination.sync_format)
    error_message = "resource_aws_ssm_resource_data_sync, sync_format must be 'JsonSerDe' if specified."
  }
}