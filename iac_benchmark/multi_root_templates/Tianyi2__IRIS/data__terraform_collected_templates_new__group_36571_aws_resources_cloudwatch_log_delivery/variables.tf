variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "delivery_destination_arn" {
  description = "The ARN of the delivery destination to use for this delivery."
  type        = string

  validation {
    condition     = can(regex("^arn:aws", var.delivery_destination_arn))
    error_message = "resource_aws_cloudwatch_log_delivery, delivery_destination_arn must be a valid AWS ARN starting with 'arn:aws'."
  }
}

variable "delivery_source_name" {
  description = "The name of the delivery source to use for this delivery."
  type        = string

  validation {
    condition     = length(var.delivery_source_name) > 0
    error_message = "resource_aws_cloudwatch_log_delivery, delivery_source_name must be a non-empty string."
  }
}

variable "field_delimiter" {
  description = "The field delimiter to use between record fields when the final output format of a delivery is in plain, w3c, or raw format."
  type        = string
  default     = null
}

variable "record_fields" {
  description = "The list of record fields to be delivered to the destination, in order."
  type        = list(string)
  default     = null

  validation {
    condition = var.record_fields == null || (
      var.record_fields != null && length(var.record_fields) > 0
    )
    error_message = "resource_aws_cloudwatch_log_delivery, record_fields must be null or a non-empty list of strings."
  }
}

variable "s3_delivery_configuration" {
  description = "Parameters that are valid only when the delivery's delivery destination is an S3 bucket."
  type = object({
    enable_hive_compatible_path = optional(bool)
    suffix_path                 = optional(string)
  })
  default = null

  validation {
    condition = var.s3_delivery_configuration == null || (
      var.s3_delivery_configuration != null &&
      (var.s3_delivery_configuration.enable_hive_compatible_path == null || can(tobool(var.s3_delivery_configuration.enable_hive_compatible_path)))
    )
    error_message = "resource_aws_cloudwatch_log_delivery, s3_delivery_configuration.enable_hive_compatible_path must be a boolean value or null."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition     = var.tags != null
    error_message = "resource_aws_cloudwatch_log_delivery, tags cannot be null."
  }
}