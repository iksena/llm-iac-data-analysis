variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "user_pool_id" {
  description = "User pool the client belongs to."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.user_pool_id))
    error_message = "data_aws_cognito_user_groups, user_pool_id must contain only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = length(var.user_pool_id) > 0
    error_message = "data_aws_cognito_user_groups, user_pool_id cannot be empty."
  }
}