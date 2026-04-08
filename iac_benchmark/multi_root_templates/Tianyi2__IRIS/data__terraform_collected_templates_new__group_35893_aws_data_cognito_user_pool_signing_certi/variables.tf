variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_cognito_user_pool_signing_certificate, region must be a valid AWS region format (e.g., us-east-1, eu-west-2)."
  }
}

variable "user_pool_id" {
  description = "Cognito user pool ID"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.user_pool_id))
    error_message = "data_aws_cognito_user_pool_signing_certificate, user_pool_id must be a valid Cognito user pool ID containing only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = length(var.user_pool_id) > 0
    error_message = "data_aws_cognito_user_pool_signing_certificate, user_pool_id cannot be empty."
  }
}