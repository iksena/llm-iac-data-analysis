variable "policy_store_id" {
  description = "The ID of the Policy Store."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.policy_store_id))
    error_message = "resource_aws_verifiedpermissions_policy_template, policy_store_id must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "statement" {
  description = "Defines the content of the statement, written in Cedar policy language."
  type        = string

  validation {
    condition     = length(var.statement) > 0
    error_message = "resource_aws_verifiedpermissions_policy_template, statement cannot be empty."
  }
}

variable "description" {
  description = "Provides a description for the policy template."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 500
    error_message = "resource_aws_verifiedpermissions_policy_template, description must be 500 characters or less."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_verifiedpermissions_policy_template, region must be a valid AWS region format."
  }
}