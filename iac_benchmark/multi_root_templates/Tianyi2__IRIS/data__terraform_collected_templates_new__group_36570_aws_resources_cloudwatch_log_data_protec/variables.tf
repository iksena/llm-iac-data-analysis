variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region)) || can(regex("^[a-z]{2}-[a-z]+-[a-z]+-[0-9]{1}$", var.region)) || can(regex("^us-gov-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_cloudwatch_log_data_protection_policy, region must be a valid AWS region format."
  }
}

variable "log_group_name" {
  description = "The name of the log group under which the log stream is to be created."
  type        = string

  validation {
    condition     = length(var.log_group_name) > 0
    error_message = "resource_aws_cloudwatch_log_data_protection_policy, log_group_name cannot be empty."
  }

  validation {
    condition     = length(var.log_group_name) <= 512
    error_message = "resource_aws_cloudwatch_log_data_protection_policy, log_group_name must be 512 characters or less."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_./#-]+$", var.log_group_name))
    error_message = "resource_aws_cloudwatch_log_data_protection_policy, log_group_name can only contain alphanumeric characters, underscores, periods, slashes, hashes, and hyphens."
  }
}

variable "policy_document" {
  description = "Specifies the data protection policy in JSON."
  type        = string

  validation {
    condition     = length(var.policy_document) > 0
    error_message = "resource_aws_cloudwatch_log_data_protection_policy, policy_document cannot be empty."
  }

  validation {
    condition     = can(jsondecode(var.policy_document))
    error_message = "resource_aws_cloudwatch_log_data_protection_policy, policy_document must be valid JSON."
  }
}