variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_cognito_user_pools, region must be a valid AWS region format (e.g., us-east-1)"
  }
}

variable "name" {
  description = "Name of the cognito user pools. Name is not a unique attribute for cognito user pool, so multiple pools might be returned with given name."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "data_aws_cognito_user_pools, name must be between 1 and 128 characters"
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "data_aws_cognito_user_pools, name can only contain alphanumeric characters, hyphens, and underscores"
  }
}