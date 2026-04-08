variable "file_system_id" {
  description = "The ID of the EFS file system"
  type        = string

  validation {
    condition     = length(var.file_system_id) > 0
    error_message = "resource_aws_efs_file_system_policy, file_system_id must not be empty."
  }

  validation {
    condition     = can(regex("^fs-[0-9a-f]{8,40}$", var.file_system_id))
    error_message = "resource_aws_efs_file_system_policy, file_system_id must be a valid EFS file system ID (e.g., fs-12345678)."
  }
}

variable "policy" {
  description = "The JSON formatted file system policy for the EFS file system"
  type        = string

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_efs_file_system_policy, policy must not be empty."
  }

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_efs_file_system_policy, policy must be valid JSON."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_efs_file_system_policy, region must be a valid AWS region (e.g., us-east-1) or null."
  }
}

variable "bypass_policy_lockout_safety_check" {
  description = "A flag to indicate whether to bypass the aws_efs_file_system_policy lockout safety check. Set to true only when you intend to prevent the principal making the request from making subsequent PutFileSystemPolicy requests"
  type        = bool
  default     = false

  validation {
    condition     = can(tobool(var.bypass_policy_lockout_safety_check))
    error_message = "resource_aws_efs_file_system_policy, bypass_policy_lockout_safety_check must be a boolean value (true or false)."
  }
}