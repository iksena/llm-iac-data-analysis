variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_grafana_workspace_service_account, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "name" {
  description = "A name for the service account. The name must be unique within the workspace, as it determines the ID associated with the service account."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_grafana_workspace_service_account, name must be a non-empty string."
  }
}

variable "grafana_role" {
  description = "The permission level to use for this service account. For more information about the roles and the permissions each has, see the User roles documentation."
  type        = string

  validation {
    condition     = contains(["ADMIN", "EDITOR", "VIEWER"], var.grafana_role)
    error_message = "resource_aws_grafana_workspace_service_account, grafana_role must be one of: ADMIN, EDITOR, VIEWER."
  }
}

variable "workspace_id" {
  description = "The Grafana workspace with which the service account is associated."
  type        = string

  validation {
    condition     = length(var.workspace_id) > 0
    error_message = "resource_aws_grafana_workspace_service_account, workspace_id must be a non-empty string."
  }
}