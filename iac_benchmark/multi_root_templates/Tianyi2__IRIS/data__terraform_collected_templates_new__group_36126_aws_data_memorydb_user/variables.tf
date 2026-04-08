variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "user_name" {
  description = "Name of the user."
  type        = string

  validation {
    condition     = length(var.user_name) > 0
    error_message = "data_aws_memorydb_user, user_name must not be empty."
  }
}