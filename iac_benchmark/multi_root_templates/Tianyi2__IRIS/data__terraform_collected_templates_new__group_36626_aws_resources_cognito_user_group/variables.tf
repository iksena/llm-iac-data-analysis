variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the user group."
  type        = string

  validation {
    condition     = can(regex("^[\\w\\s+=,.@-]+$", var.name))
    error_message = "resource_aws_cognito_user_group, name must contain only alphanumeric characters, spaces, and the following special characters: +=,.@-"
  }

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 128
    error_message = "resource_aws_cognito_user_group, name must be between 1 and 128 characters long."
  }
}

variable "user_pool_id" {
  description = "The user pool ID."
  type        = string

  validation {
    condition     = can(regex("^[\\w-]+_[0-9a-zA-Z]+$", var.user_pool_id))
    error_message = "resource_aws_cognito_user_group, user_pool_id must be a valid Cognito User Pool ID format."
  }
}

variable "description" {
  description = "The description of the user group."
  type        = string
  default     = null

  validation {
    condition = var.description == null || (
      length(var.description) >= 0 && length(var.description) <= 2048
    )
    error_message = "resource_aws_cognito_user_group, description must be between 0 and 2048 characters long."
  }
}

variable "precedence" {
  description = "The precedence of the user group."
  type        = number
  default     = null

  validation {
    condition = var.precedence == null || (
      var.precedence >= 0 && var.precedence <= 2147483647
    )
    error_message = "resource_aws_cognito_user_group, precedence must be between 0 and 2147483647."
  }
}

variable "role_arn" {
  description = "The ARN of the IAM role to be associated with the user group."
  type        = string
  default     = null

  validation {
    condition     = var.role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.+$", var.role_arn))
    error_message = "resource_aws_cognito_user_group, role_arn must be a valid IAM role ARN format."
  }
}