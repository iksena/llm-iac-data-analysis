variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "identity_pool_name" {
  description = "The Cognito Identity Pool name."
  type        = string

  validation {
    condition     = length(var.identity_pool_name) > 0
    error_message = "data_aws_cognito_identity_pool, identity_pool_name must not be empty."
  }
}