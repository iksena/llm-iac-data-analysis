variable "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the account to create or update a resource policy for"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:redshift:", var.resource_arn))
    error_message = "resource_aws_redshift_resource_policy, resource_arn must be a valid Redshift ARN starting with 'arn:aws:redshift:'."
  }
}

variable "policy" {
  description = "The content of the resource policy being updated"
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_redshift_resource_policy, policy must be valid JSON."
  }

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_redshift_resource_policy, policy cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_redshift_resource_policy, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}