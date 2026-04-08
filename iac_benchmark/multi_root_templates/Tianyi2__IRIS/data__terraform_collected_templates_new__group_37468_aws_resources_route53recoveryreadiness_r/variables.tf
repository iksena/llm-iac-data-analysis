variable "recovery_group_name" {
  description = "A unique name describing the recovery group"
  type        = string

  validation {
    condition     = length(var.recovery_group_name) > 0
    error_message = "resource_aws_route53recoveryreadiness_recovery_group, recovery_group_name must not be empty."
  }
}

variable "cells" {
  description = "List of cell arns to add as nested fault domains within this recovery group"
  type        = list(string)
  default     = null

  validation {
    condition = var.cells == null ? true : alltrue([
      for cell in var.cells : can(regex("^arn:aws:route53-recovery-readiness:[^:]*:[^:]*:cell/[^/]+$", cell))
    ])
    error_message = "resource_aws_route53recoveryreadiness_recovery_group, cells must be valid Route53 Recovery Readiness cell ARNs."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

variable "delete_timeout" {
  description = "Timeout for delete operation"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_route53recoveryreadiness_recovery_group, delete_timeout must be a valid timeout format (e.g., '5m', '30s', '1h')."
  }
}