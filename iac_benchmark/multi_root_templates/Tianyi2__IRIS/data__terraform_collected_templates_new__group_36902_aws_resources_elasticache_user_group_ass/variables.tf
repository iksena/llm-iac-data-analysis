variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_elasticache_user_group_association, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "user_group_id" {
  description = "ID of the user group."
  type        = string

  validation {
    condition     = length(var.user_group_id) > 0
    error_message = "resource_aws_elasticache_user_group_association, user_group_id cannot be empty."
  }
}

variable "user_id" {
  description = "ID of the user to associated with the user group."
  type        = string

  validation {
    condition     = length(var.user_id) > 0
    error_message = "resource_aws_elasticache_user_group_association, user_id cannot be empty."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the user group association."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.create_timeout))
    error_message = "resource_aws_elasticache_user_group_association, create_timeout must be a valid timeout format (e.g., 10m, 1h, 30s)."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the user group association."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.delete_timeout))
    error_message = "resource_aws_elasticache_user_group_association, delete_timeout must be a valid timeout format (e.g., 10m, 1h, 30s)."
  }
}