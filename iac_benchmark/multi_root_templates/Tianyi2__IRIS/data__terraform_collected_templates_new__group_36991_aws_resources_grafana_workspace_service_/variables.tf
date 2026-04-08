variable "name" {
  description = "A name for the token to create. The name must be unique within the workspace."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_grafana_workspace_service_account_token, name must not be empty."
  }
}

variable "seconds_to_live" {
  description = "Sets how long the token will be valid, in seconds. You can set the time up to 30 days in the future."
  type        = number

  validation {
    condition     = var.seconds_to_live > 0 && var.seconds_to_live <= 2592000
    error_message = "resource_aws_grafana_workspace_service_account_token, seconds_to_live must be between 1 and 2592000 (30 days)."
  }
}

variable "service_account_id" {
  description = "The ID of the service account for which to create a token."
  type        = string

  validation {
    condition     = length(var.service_account_id) > 0
    error_message = "resource_aws_grafana_workspace_service_account_token, service_account_id must not be empty."
  }
}

variable "workspace_id" {
  description = "The Grafana workspace with which the service account token is associated."
  type        = string

  validation {
    condition     = length(var.workspace_id) > 0
    error_message = "resource_aws_grafana_workspace_service_account_token, workspace_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}