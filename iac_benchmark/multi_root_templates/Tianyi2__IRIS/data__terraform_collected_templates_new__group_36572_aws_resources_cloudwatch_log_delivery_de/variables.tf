variable "name" {
  description = "The name for this delivery destination."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_cloudwatch_log_delivery_destination, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "delivery_destination_configuration" {
  description = "The AWS resource that will receive the logs."
  type = object({
    destination_resource_arn = string
  })

  validation {
    condition     = length(var.delivery_destination_configuration.destination_resource_arn) > 0
    error_message = "resource_aws_cloudwatch_log_delivery_destination, delivery_destination_configuration.destination_resource_arn must not be empty."
  }

  validation {
    condition     = can(regex("^arn:aws", var.delivery_destination_configuration.destination_resource_arn))
    error_message = "resource_aws_cloudwatch_log_delivery_destination, delivery_destination_configuration.destination_resource_arn must be a valid AWS ARN."
  }
}

variable "output_format" {
  description = "The format of the logs that are sent to this delivery destination."
  type        = string
  default     = null

  validation {
    condition = var.output_format == null || contains([
      "json",
      "plain",
      "w3c",
      "raw",
      "parquet"
    ], var.output_format)
    error_message = "resource_aws_cloudwatch_log_delivery_destination, output_format must be one of: json, plain, w3c, raw, parquet."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags)
    error_message = "resource_aws_cloudwatch_log_delivery_destination, tags must be a valid map of strings."
  }
}