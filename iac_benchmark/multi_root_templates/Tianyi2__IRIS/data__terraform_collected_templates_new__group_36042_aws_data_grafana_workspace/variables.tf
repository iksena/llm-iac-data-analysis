variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "workspace_id" {
  description = "Grafana workspace ID."
  type        = string

  validation {
    condition     = can(regex("^g-[a-zA-Z0-9]+$", var.workspace_id))
    error_message = "data_aws_grafana_workspace, workspace_id must be a valid Grafana workspace ID starting with 'g-'."
  }
}