variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "group_name" {
  type        = string
  description = "The name of the group."

  validation {
    condition     = length(var.group_name) > 0
    error_message = "resource_aws_xray_group, group_name must not be empty."
  }
}

variable "filter_expression" {
  type        = string
  description = "The filter expression defining criteria by which to group traces."

  validation {
    condition     = length(var.filter_expression) > 0
    error_message = "resource_aws_xray_group, filter_expression must not be empty."
  }
}

variable "insights_configuration" {
  type = object({
    insights_enabled      = bool
    notifications_enabled = optional(bool)
  })
  description = "Configuration options for enabling insights."
  default     = null

  validation {
    condition = var.insights_configuration == null || (
      var.insights_configuration.insights_enabled != null
    )
    error_message = "resource_aws_xray_group, insights_configuration.insights_enabled is required when insights_configuration is specified."
  }
}

variable "tags" {
  type        = map(string)
  description = "Key-value mapping of resource tags."
  default     = {}
}