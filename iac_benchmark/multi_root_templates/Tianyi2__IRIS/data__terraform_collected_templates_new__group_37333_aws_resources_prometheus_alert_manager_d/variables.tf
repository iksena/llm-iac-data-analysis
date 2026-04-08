variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "workspace_id" {
  description = "ID of the prometheus workspace the alert manager definition should be linked to"
  type        = string

  validation {
    condition     = length(var.workspace_id) > 0
    error_message = "resource_aws_prometheus_alert_manager_definition, workspace_id must not be empty."
  }
}

variable "definition" {
  description = "The alert manager definition that you want to be applied."
  type        = string

  validation {
    condition     = length(var.definition) > 0
    error_message = "resource_aws_prometheus_alert_manager_definition, definition must not be empty."
  }
}