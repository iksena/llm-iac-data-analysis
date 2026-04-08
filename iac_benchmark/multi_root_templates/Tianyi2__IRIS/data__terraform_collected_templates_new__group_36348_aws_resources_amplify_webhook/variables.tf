variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "app_id" {
  description = "Unique ID for an Amplify app"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.app_id))
    error_message = "resource_aws_amplify_webhook, app_id must be a valid Amplify app ID."
  }
}

variable "branch_name" {
  description = "Name for a branch that is part of the Amplify app"
  type        = string

  validation {
    condition     = length(var.branch_name) > 0
    error_message = "resource_aws_amplify_webhook, branch_name cannot be empty."
  }
}

variable "description" {
  description = "Description for a webhook"
  type        = string
  default     = null
}