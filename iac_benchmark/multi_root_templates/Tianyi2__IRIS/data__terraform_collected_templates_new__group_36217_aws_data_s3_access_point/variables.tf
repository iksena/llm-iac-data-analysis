variable "account_id" {
  description = "AWS account ID for the account that owns the specified access point"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the access point"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9\\-]*[a-z0-9]$", var.name)) && length(var.name) >= 3 && length(var.name) <= 50
    error_message = "data_aws_s3_access_point, name must be between 3 and 50 characters long and contain only lowercase letters, numbers, and hyphens, starting and ending with alphanumeric characters."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}