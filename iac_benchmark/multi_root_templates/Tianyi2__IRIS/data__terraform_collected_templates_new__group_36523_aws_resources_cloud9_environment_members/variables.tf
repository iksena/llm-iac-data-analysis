variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "environment_id" {
  description = "The ID of the environment that contains the environment member you want to add."
  type        = string

  validation {
    condition     = length(var.environment_id) > 0
    error_message = "resource_aws_cloud9_environment_membership, environment_id must be a non-empty string."
  }
}

variable "permissions" {
  description = "The type of environment member permissions you want to associate with this environment member. Allowed values are read-only and read-write."
  type        = string

  validation {
    condition     = contains(["read-only", "read-write"], var.permissions)
    error_message = "resource_aws_cloud9_environment_membership, permissions must be either 'read-only' or 'read-write'."
  }
}

variable "user_arn" {
  description = "The Amazon Resource Name (ARN) of the environment member you want to add."
  type        = string

  validation {
    condition     = length(var.user_arn) > 0 && can(regex("^arn:aws", var.user_arn))
    error_message = "resource_aws_cloud9_environment_membership, user_arn must be a valid AWS ARN starting with 'arn:aws'."
  }
}