variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_cognito_user_pool, region must be a valid AWS region format if specified."
  }
}

variable "user_pool_id" {
  description = "The cognito pool ID"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.user_pool_id))
    error_message = "data_aws_cognito_user_pool, user_pool_id must be a valid Cognito User Pool ID."
  }
}