variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}
variable "enabled" {
  description = "Whether the KMS module is enabled. If true, a custom KMS key will be used for encryption. If false, the default AWS managed KMS key will be used."
  type        = bool
  default     = true
}

variable "kms_key_alias" {
  description = "Alias for the custom KMS key (if enabled)."
  type        = string
  default     = "alias/benchmark-canary-key"
}

variable "protocol" {
  description = "The protocol for the SNS subscription endpoint."
  type        = string
  default     = "email"
}

variable "endpoint" {
  description = "The endpoint for the SNS subscription."
  type        = string
  default     = "nobody@example.com"
}

///////// KMS //////////////////

variable "deletion_window_in_days" {
  type        = number
  default     = 10
  description = "Duration in days after which the key is deleted after destruction of the resource"
}

variable "enable_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled"
}

variable "custom_kms_policy" {
  description = "Custom KMS policy to apply if enabled. If not provided, a default policy will be used."
  type        = string
  default     = ""
}
variable "sns_topic_name" {
  description = "Name for the SNS topic."
  type        = string
  default     = "benchmark-canary-topic"
}

variable "canaries_with_vpc" {
  description = "List of canaries with VPC configuration"
  type = map(object({
    name     = string
    handler  = string
    zip_file = string
    s3_details = optional(object({
      s3_bucket  = string
      s3_key     = string
      s3_version = string
    }), null)
    runtime_version          = string
    start_canary             = bool
    failure_retention_period = number
    success_retention_period = number
    schedule_expression      = string
    environment_variables    = map(string)
  }))
  default     = {}
}

variable "subnet_ids" {
  description = "List of subnet IDs where the canary will run"
  type        = list(string)
  default     = [""]
}

variable "security_group_ids" {
  description = "List of security group IDs for the canary"
  type        = list(string)
  default     = [""]
}

variable "tags" {
  description = "Tags to apply to the canary"
  type        = map(string)
  default     = {}
}
################################################################################
## S3
################################################################################

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket."
  default     = "benchmark-canary-bucket-tf5x"
}
variable "bucket_key_enabled" {
  type        = bool
  description = "Specifies whether bucket key is enabled."
  default     = false
}
variable "force_destroy" {
  type        = bool
  default     = true
  description = "Specifies whether to force destroy the bucket (and all objects) when the bucket is removed."
}
variable "versioning_enabled" {
  type        = bool
  default     = false
  description = "Enable versioning for the S3 bucket."
}
variable "block_public_acls" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should block public ACLs for this bucket."
}
variable "ignore_public_acls" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
}
variable "block_public_policy" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
}
variable "restrict_public_buckets" {
  type        = bool
  default     = true
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
}
variable "cors_configuration" {
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = [
    {
      allowed_headers = ["Authorization"]
      allowed_methods = ["GET", "POST"]
      allowed_origins = ["*"]
      expose_headers  = ["x-amz-server-side-encryption"]
      max_age_seconds = 3000
    }
  ]
  description = "The CORS configuration for the S3 bucket."
}
variable "sse_algorithm" {
  type        = string
  default     = "aws:kms"
  description = "The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`"
}
variable "cloudwatch_metric_alarms_enabled" {
  type        = bool
  description = "Boolean flag to enable/disable CloudWatch metrics alarms"
  default     = false
}
