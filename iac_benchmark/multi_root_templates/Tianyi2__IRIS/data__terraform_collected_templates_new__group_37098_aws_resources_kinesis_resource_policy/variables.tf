variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_kinesis_resource_policy, region must be a valid AWS region format."
  }
}

variable "policy" {
  description = "The policy document."
  type        = string

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_kinesis_resource_policy, policy cannot be empty."
  }

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_kinesis_resource_policy, policy must be valid JSON."
  }
}

variable "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the data stream or consumer."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kinesis:[a-z0-9-]+:[0-9]+:(stream|consumer)/[a-zA-Z0-9_.-]+", var.resource_arn))
    error_message = "resource_aws_kinesis_resource_policy, resource_arn must be a valid Kinesis stream or consumer ARN."
  }
}