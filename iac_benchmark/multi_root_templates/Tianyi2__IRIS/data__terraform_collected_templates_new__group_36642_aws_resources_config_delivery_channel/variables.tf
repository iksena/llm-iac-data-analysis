variable "name" {
  description = "The name of the delivery channel. Defaults to `default`. Changing it recreates the resource."
  type        = string
  default     = "default"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket used to store the configuration history."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.s3_bucket_name)) && length(var.s3_bucket_name) >= 3 && length(var.s3_bucket_name) <= 63
    error_message = "resource_aws_config_delivery_channel, s3_bucket_name must be a valid S3 bucket name (3-63 characters, lowercase letters, numbers, dots, and hyphens, starting and ending with alphanumeric characters)."
  }
}

variable "s3_key_prefix" {
  description = "The prefix for the specified S3 bucket."
  type        = string
  default     = null
}

variable "s3_kms_key_arn" {
  description = "The ARN of the AWS KMS key used to encrypt objects delivered by AWS Config. Must belong to the same Region as the destination S3 bucket."
  type        = string
  default     = null

  validation {
    condition     = var.s3_kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.s3_kms_key_arn))
    error_message = "resource_aws_config_delivery_channel, s3_kms_key_arn must be a valid KMS key ARN or null."
  }
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic that AWS Config delivers notifications to."
  type        = string
  default     = null

  validation {
    condition     = var.sns_topic_arn == null || can(regex("^arn:aws:sns:[a-z0-9-]+:[0-9]{12}:[a-zA-Z0-9_-]+$", var.sns_topic_arn))
    error_message = "resource_aws_config_delivery_channel, sns_topic_arn must be a valid SNS topic ARN or null."
  }
}

variable "snapshot_delivery_properties" {
  description = "Options for how AWS Config delivers configuration snapshots."
  type = object({
    delivery_frequency = string
  })
  default = null

  validation {
    condition = var.snapshot_delivery_properties == null || contains([
      "One_Hour",
      "Three_Hours",
      "Six_Hours",
      "Twelve_Hours",
      "TwentyFour_Hours"
    ], var.snapshot_delivery_properties.delivery_frequency)
    error_message = "resource_aws_config_delivery_channel, snapshot_delivery_properties.delivery_frequency must be one of: One_Hour, Three_Hours, Six_Hours, Twelve_Hours, TwentyFour_Hours."
  }
}