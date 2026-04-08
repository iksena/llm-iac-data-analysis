variable "workspace_id" {
  description = "ID of the workspace to configure"
  type        = string

  validation {
    condition     = can(regex("^ws-[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.workspace_id))
    error_message = "resource_aws_prometheus_workspace_configuration, workspace_id must be a valid workspace ID in format 'ws-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'."
  }
}

variable "limits_per_label_set" {
  description = "Configuration block for setting limits on metrics with specific label sets"
  type = list(object({
    label_set = map(string)
    limits = object({
      max_series = number
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for limit in var.limits_per_label_set : limit.limits.max_series > 0
    ])
    error_message = "resource_aws_prometheus_workspace_configuration, limits_per_label_set limits max_series must be greater than 0."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "retention_period_in_days" {
  description = "Number of days to retain metric data in the workspace"
  type        = number
  default     = null

  validation {
    condition     = var.retention_period_in_days == null || (var.retention_period_in_days >= 1 && var.retention_period_in_days <= 1000)
    error_message = "resource_aws_prometheus_workspace_configuration, retention_period_in_days must be between 1 and 1000 days."
  }
}

variable "timeouts" {
  description = "Timeouts configuration"
  type = object({
    create = optional(string)
    update = optional(string)
  })
  default = null

  validation {
    condition = var.timeouts == null || alltrue([
      for timeout in [var.timeouts.create, var.timeouts.update] :
      timeout == null || can(regex("^[0-9]+[smh]$", timeout))
    ])
    error_message = "resource_aws_prometheus_workspace_configuration, timeouts must be in format like '5m', '30s', or '2h'."
  }
}