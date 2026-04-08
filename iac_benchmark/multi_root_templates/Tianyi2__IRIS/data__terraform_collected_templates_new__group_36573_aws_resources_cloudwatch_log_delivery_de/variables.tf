variable "delivery_destination_name" {
  description = "The name of the delivery destination to assign this policy to."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.delivery_destination_name))
    error_message = "resource_aws_cloudwatch_log_delivery_destination_policy, delivery_destination_name must contain only alphanumeric characters, periods, underscores, and hyphens."
  }

  validation {
    condition     = length(var.delivery_destination_name) > 0 && length(var.delivery_destination_name) <= 512
    error_message = "resource_aws_cloudwatch_log_delivery_destination_policy, delivery_destination_name must be between 1 and 512 characters long."
  }
}

variable "delivery_destination_policy" {
  description = "The contents of the policy."
  type        = string

  validation {
    condition     = can(jsondecode(var.delivery_destination_policy))
    error_message = "resource_aws_cloudwatch_log_delivery_destination_policy, delivery_destination_policy must be a valid JSON string."
  }

  validation {
    condition     = length(var.delivery_destination_policy) > 0
    error_message = "resource_aws_cloudwatch_log_delivery_destination_policy, delivery_destination_policy cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_cloudwatch_log_delivery_destination_policy, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null."
  }
}