variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "workspace_id" {
  description = "Prometheus workspace ID."
  type        = string

  validation {
    condition     = can(regex("^ws-[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.workspace_id))
    error_message = "data_aws_prometheus_workspace, workspace_id must be a valid Prometheus workspace ID format (e.g., ws-41det8a1-2c67-6a1a-9381-9b83d3d78ef7)."
  }
}