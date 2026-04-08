variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "user_id" {
  description = "Identifier for the user."
  type        = string

  validation {
    condition     = length(var.user_id) > 0
    error_message = "data_aws_elasticache_user, user_id must be a non-empty string."
  }
}