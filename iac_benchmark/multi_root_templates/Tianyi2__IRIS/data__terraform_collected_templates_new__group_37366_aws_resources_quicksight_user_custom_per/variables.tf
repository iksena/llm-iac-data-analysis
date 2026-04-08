variable "custom_permissions_name" {
  description = "Custom permissions profile name"
  type        = string

  validation {
    condition     = length(var.custom_permissions_name) > 0
    error_message = "resource_aws_quicksight_user_custom_permission, custom_permissions_name must not be empty."
  }
}

variable "user_name" {
  description = "Username of the user"
  type        = string

  validation {
    condition     = length(var.user_name) > 0
    error_message = "resource_aws_quicksight_user_custom_permission, user_name must not be empty."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider"
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_user_custom_permission, aws_account_id must be a 12-digit number."
  }
}

variable "namespace" {
  description = "Namespace that the user belongs to. Defaults to default"
  type        = string
  default     = "default"

  validation {
    condition     = length(var.namespace) > 0
    error_message = "resource_aws_quicksight_user_custom_permission, namespace must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}