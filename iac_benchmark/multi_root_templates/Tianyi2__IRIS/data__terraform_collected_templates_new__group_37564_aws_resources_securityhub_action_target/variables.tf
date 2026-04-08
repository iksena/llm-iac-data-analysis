variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]+-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_securityhub_action_target, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "name" {
  description = "The description for the custom action target."
  type        = string

  validation {
    condition     = can(regex("^.+$", var.name)) && length(var.name) > 0
    error_message = "resource_aws_securityhub_action_target, name must be a non-empty string."
  }
}

variable "identifier" {
  description = "The ID for the custom action target."
  type        = string

  validation {
    condition     = can(regex("^.+$", var.identifier)) && length(var.identifier) > 0
    error_message = "resource_aws_securityhub_action_target, identifier must be a non-empty string."
  }
}

variable "description" {
  description = "The name of the custom action target."
  type        = string

  validation {
    condition     = can(regex("^.+$", var.description)) && length(var.description) > 0
    error_message = "resource_aws_securityhub_action_target, description must be a non-empty string."
  }
}