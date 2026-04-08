variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the bucket."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket))
    error_message = "resource_aws_s3_bucket_logging, bucket must be a valid S3 bucket name (3-63 characters, lowercase letters, numbers, dots, and hyphens only)."
  }
}

variable "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner."
  type        = string
  default     = null

  validation {
    condition     = var.expected_bucket_owner == null || can(regex("^[0-9]{12}$", var.expected_bucket_owner))
    error_message = "resource_aws_s3_bucket_logging, expected_bucket_owner must be a valid 12-digit AWS account ID."
  }
}

variable "target_bucket" {
  description = "Name of the bucket where you want Amazon S3 to store server access logs."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.target_bucket))
    error_message = "resource_aws_s3_bucket_logging, target_bucket must be a valid S3 bucket name (3-63 characters, lowercase letters, numbers, dots, and hyphens only)."
  }
}

variable "target_prefix" {
  description = "Prefix for all log object keys."
  type        = string

  validation {
    condition     = length(var.target_prefix) > 0
    error_message = "resource_aws_s3_bucket_logging, target_prefix cannot be empty."
  }
}

variable "target_grant" {
  description = "Set of configuration blocks with information for granting permissions."
  type = list(object({
    permission = string
    grantee = object({
      email_address = optional(string)
      id            = optional(string)
      type          = string
      uri           = optional(string)
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for grant in var.target_grant : contains(["FULL_CONTROL", "READ", "WRITE"], grant.permission)
    ])
    error_message = "resource_aws_s3_bucket_logging, target_grant permission must be one of: FULL_CONTROL, READ, WRITE."
  }

  validation {
    condition = alltrue([
      for grant in var.target_grant : contains(["CanonicalUser", "AmazonCustomerByEmail", "Group"], grant.grantee.type)
    ])
    error_message = "resource_aws_s3_bucket_logging, target_grant grantee type must be one of: CanonicalUser, AmazonCustomerByEmail, Group."
  }
}

variable "target_object_key_format" {
  description = "Amazon S3 key format for log objects."
  type = object({
    partitioned_prefix = optional(object({
      partition_date_source = string
    }))
    simple_prefix = optional(object({}))
  })
  default = null

  validation {
    condition = var.target_object_key_format == null || (
      var.target_object_key_format.partitioned_prefix == null ||
      var.target_object_key_format.simple_prefix == null
    )
    error_message = "resource_aws_s3_bucket_logging, target_object_key_format cannot have both partitioned_prefix and simple_prefix configured."
  }

  validation {
    condition     = var.target_object_key_format == null || var.target_object_key_format.partitioned_prefix == null || contains(["EventTime", "DeliveryTime"], var.target_object_key_format.partitioned_prefix.partition_date_source)
    error_message = "resource_aws_s3_bucket_logging, target_object_key_format partitioned_prefix partition_date_source must be either EventTime or DeliveryTime."
  }
}