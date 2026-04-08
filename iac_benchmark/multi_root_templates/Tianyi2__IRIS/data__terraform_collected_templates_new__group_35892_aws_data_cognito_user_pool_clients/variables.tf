variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "user_pool_id" {
  description = "Cognito user pool ID."
  type        = string

  validation {
    condition     = var.user_pool_id != null && var.user_pool_id != ""
    error_message = "data_aws_cognito_user_pool_clients, user_pool_id must be a non-empty string."
  }
}