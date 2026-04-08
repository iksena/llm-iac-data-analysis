variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "app_id" {
  description = "Unique ID for an Amplify app."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.app_id))
    error_message = "resource_aws_amplify_backend_environment, app_id must contain only alphanumeric characters."
  }
}

variable "environment_name" {
  description = "Name for the backend environment."
  type        = string

  validation {
    condition     = length(var.environment_name) > 0 && length(var.environment_name) <= 255
    error_message = "resource_aws_amplify_backend_environment, environment_name must be between 1 and 255 characters."
  }
}

variable "deployment_artifacts" {
  description = "Name of deployment artifacts."
  type        = string
  default     = null

  validation {
    condition = var.deployment_artifacts == null || (
      length(var.deployment_artifacts) > 0 &&
      length(var.deployment_artifacts) <= 1000
    )
    error_message = "resource_aws_amplify_backend_environment, deployment_artifacts must be between 1 and 1000 characters when specified."
  }
}

variable "stack_name" {
  description = "AWS CloudFormation stack name of a backend environment."
  type        = string
  default     = null

  validation {
    condition = var.stack_name == null || (
      can(regex("^[a-zA-Z][-a-zA-Z0-9]*$", var.stack_name)) &&
      length(var.stack_name) >= 1 &&
      length(var.stack_name) <= 128
    )
    error_message = "resource_aws_amplify_backend_environment, stack_name must start with a letter, contain only alphanumeric characters and hyphens, and be between 1 and 128 characters when specified."
  }
}