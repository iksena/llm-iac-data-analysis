variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_cloudwatch_log_index_policy, region must be a valid AWS region name or null."
  }
}

variable "log_group_name" {
  description = "Log group name to set the policy for."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_/.-]+$", var.log_group_name)) && length(var.log_group_name) > 0
    error_message = "resource_aws_cloudwatch_log_index_policy, log_group_name must be a non-empty string containing only valid log group name characters."
  }
}

variable "policy_document" {
  description = "JSON policy document. This is a JSON formatted string."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy_document))
    error_message = "resource_aws_cloudwatch_log_index_policy, policy_document must be a valid JSON string."
  }

  validation {
    condition     = length(var.policy_document) > 0
    error_message = "resource_aws_cloudwatch_log_index_policy, policy_document cannot be empty."
  }
}