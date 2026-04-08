variable "role" {
  description = "The grafana role. Valid values can be found at https://docs.aws.amazon.com/grafana/latest/APIReference/API_UpdateInstruction.html#ManagedGrafana-Type-UpdateInstruction-role"
  type        = string

  validation {
    condition = contains([
      "ADMIN",
      "EDITOR",
      "VIEWER"
    ], var.role)
    error_message = "resource_aws_grafana_role_association, role must be one of: ADMIN, EDITOR, VIEWER."
  }
}

variable "workspace_id" {
  description = "The workspace id"
  type        = string

  validation {
    condition     = can(regex("^g-[0-9a-f]{10}$", var.workspace_id))
    error_message = "resource_aws_grafana_role_association, workspace_id must be a valid Grafana workspace ID (format: g-xxxxxxxxxx)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "group_ids" {
  description = "The AWS SSO group ids to be assigned the role given in role"
  type        = list(string)
  default     = null

  validation {
    condition = var.group_ids == null || (
      var.group_ids != null && length(var.group_ids) > 0 && alltrue([
        for id in var.group_ids : can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", id))
      ])
    )
    error_message = "resource_aws_grafana_role_association, group_ids must be a list of valid AWS SSO group UUIDs."
  }
}

variable "user_ids" {
  description = "The AWS SSO user ids to be assigned the role given in role"
  type        = list(string)
  default     = null

  validation {
    condition = var.user_ids == null || (
      var.user_ids != null && length(var.user_ids) > 0 && alltrue([
        for id in var.user_ids : can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", id))
      ])
    )
    error_message = "resource_aws_grafana_role_association, user_ids must be a list of valid AWS SSO user UUIDs."
  }
}