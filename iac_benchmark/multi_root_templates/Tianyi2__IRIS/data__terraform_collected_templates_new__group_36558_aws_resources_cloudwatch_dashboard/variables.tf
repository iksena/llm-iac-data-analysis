variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "dashboard_name" {
  description = "The name of the dashboard."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.dashboard_name))
    error_message = "resource_aws_cloudwatch_dashboard, dashboard_name must contain only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = length(var.dashboard_name) > 0 && length(var.dashboard_name) <= 255
    error_message = "resource_aws_cloudwatch_dashboard, dashboard_name must be between 1 and 255 characters."
  }
}

variable "dashboard_body" {
  description = "The detailed information about the dashboard, including what widgets are included and their location on the dashboard."
  type        = string

  validation {
    condition     = can(jsondecode(var.dashboard_body))
    error_message = "resource_aws_cloudwatch_dashboard, dashboard_body must be valid JSON."
  }
}