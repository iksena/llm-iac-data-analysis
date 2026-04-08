variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "key_name" {
  description = "Specifies the name of the API key. Key names must be unique to the workspace."
  type        = string

  validation {
    condition     = length(var.key_name) > 0
    error_message = "resource_aws_grafana_workspace_api_key, key_name must not be empty."
  }
}

variable "key_role" {
  description = "Specifies the permission level of the API key. Valid values are VIEWER, EDITOR, or ADMIN."
  type        = string

  validation {
    condition     = contains(["VIEWER", "EDITOR", "ADMIN"], var.key_role)
    error_message = "resource_aws_grafana_workspace_api_key, key_role must be one of: VIEWER, EDITOR, or ADMIN."
  }
}

variable "seconds_to_live" {
  description = "Specifies the time in seconds until the API key expires. Keys can be valid for up to 30 days."
  type        = number

  validation {
    condition     = var.seconds_to_live > 0 && var.seconds_to_live <= 2592000
    error_message = "resource_aws_grafana_workspace_api_key, seconds_to_live must be greater than 0 and less than or equal to 2592000 (30 days)."
  }
}

variable "workspace_id" {
  description = "The ID of the workspace that the API key is valid for."
  type        = string

  validation {
    condition     = length(var.workspace_id) > 0
    error_message = "resource_aws_grafana_workspace_api_key, workspace_id must not be empty."
  }
}