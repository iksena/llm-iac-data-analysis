variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "user_pool_id" {
  description = "The user pool ID of the user and group."
  type        = string

  validation {
    condition     = can(regex("^[\\w-]+_[0-9a-zA-Z]+$", var.user_pool_id))
    error_message = "resource_aws_cognito_user_in_group, user_pool_id must be a valid Cognito user pool ID format."
  }
}

variable "group_name" {
  description = "The name of the group to which the user is to be added."
  type        = string

  validation {
    condition     = length(var.group_name) > 0 && length(var.group_name) <= 128
    error_message = "resource_aws_cognito_user_in_group, group_name must be between 1 and 128 characters."
  }
}

variable "username" {
  description = "The username of the user to be added to the group."
  type        = string

  validation {
    condition     = length(var.username) > 0 && length(var.username) <= 128
    error_message = "resource_aws_cognito_user_in_group, username must be between 1 and 128 characters."
  }
}