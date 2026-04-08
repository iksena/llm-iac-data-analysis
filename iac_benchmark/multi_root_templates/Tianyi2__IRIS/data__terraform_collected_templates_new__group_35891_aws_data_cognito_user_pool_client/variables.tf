variable "client_id" {
  description = "Client Id of the user pool"
  type        = string

  validation {
    condition     = length(var.client_id) > 0
    error_message = "data_aws_cognito_user_pool_client, client_id must not be empty."
  }
}

variable "user_pool_id" {
  description = "User pool the client belongs to"
  type        = string

  validation {
    condition     = length(var.user_pool_id) > 0
    error_message = "data_aws_cognito_user_pool_client, user_pool_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}