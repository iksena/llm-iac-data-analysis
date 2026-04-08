variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]+-[a-z]+-\\d+$", var.region))
    error_message = "resource_aws_media_store_container_policy, region must be a valid AWS region format (e.g., us-west-2) or null to use provider default."
  }
}

variable "container_name" {
  description = "The name of the container"
  type        = string

  validation {
    condition     = length(var.container_name) > 0 && length(var.container_name) <= 255
    error_message = "resource_aws_media_store_container_policy, container_name must be between 1 and 255 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.container_name))
    error_message = "resource_aws_media_store_container_policy, container_name must contain only alphanumeric characters, underscores, periods, and hyphens."
  }
}

variable "policy" {
  description = "The contents of the policy"
  type        = string

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_media_store_container_policy, policy cannot be empty."
  }

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_media_store_container_policy, policy must be valid JSON."
  }
}