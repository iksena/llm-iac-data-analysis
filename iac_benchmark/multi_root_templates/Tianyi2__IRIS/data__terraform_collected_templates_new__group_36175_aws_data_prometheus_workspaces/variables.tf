variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_prometheus_workspaces, region must be a valid AWS region format (lowercase letters, numbers, and hyphens only)."
  }
}

variable "alias_prefix" {
  description = "Limits results to workspaces with aliases that begin with this value."
  type        = string
  default     = null

  validation {
    condition     = var.alias_prefix == null || length(var.alias_prefix) > 0
    error_message = "data_aws_prometheus_workspaces, alias_prefix must be a non-empty string when specified."
  }
}