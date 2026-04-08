variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "collaboration_id" {
  description = "The ID of the collaboration to which the member was invited."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.collaboration_id))
    error_message = "resource_aws_cleanrooms_membership, collaboration_id must be a valid UUID format."
  }
}

variable "query_log_status" {
  description = "An indicator as to whether query logging has been enabled or disabled for the membership."
  type        = string

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.query_log_status)
    error_message = "resource_aws_cleanrooms_membership, query_log_status must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "default_result_configuration" {
  description = "The default configuration for a query result."
  type = object({
    role_arn = optional(string)
    output_configuration = object({
      s3 = object({
        bucket        = string
        result_format = string
        key_prefix    = optional(string)
      })
    })
  })
  default = null

  validation {
    condition = var.default_result_configuration == null ? true : (
      var.default_result_configuration.output_configuration.s3.bucket != null &&
      var.default_result_configuration.output_configuration.s3.bucket != ""
    )
    error_message = "resource_aws_cleanrooms_membership, default_result_configuration output_configuration.s3.bucket is required when default_result_configuration is provided."
  }

  validation {
    condition = var.default_result_configuration == null ? true : (
      contains(["PARQUET", "CSV"], var.default_result_configuration.output_configuration.s3.result_format)
    )
    error_message = "resource_aws_cleanrooms_membership, default_result_configuration output_configuration.s3.result_format must be either 'PARQUET' or 'CSV'."
  }

  validation {
    condition = var.default_result_configuration == null ? true : (
      var.default_result_configuration.role_arn == null ? true : can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.default_result_configuration.role_arn))
    )
    error_message = "resource_aws_cleanrooms_membership, default_result_configuration role_arn must be a valid IAM role ARN when provided."
  }
}

variable "tags" {
  description = "Key value pairs which tag the membership."
  type        = map(string)
  default     = {}
}