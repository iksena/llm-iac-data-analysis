variable "user_name" {
  description = "The name of the user that you want to match."
  type        = string

  validation {
    condition     = length(var.user_name) > 0
    error_message = "data_quicksight_user, user_name must not be empty."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "data_quicksight_user, aws_account_id must be a 12-digit AWS account ID or null."
  }
}

variable "namespace" {
  description = "QuickSight namespace. Defaults to 'default'."
  type        = string
  default     = null

  validation {
    condition     = var.namespace == null || length(var.namespace) > 0
    error_message = "data_quicksight_user, namespace must not be empty if specified."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_quicksight_user, region must be a valid AWS region format or null."
  }
}