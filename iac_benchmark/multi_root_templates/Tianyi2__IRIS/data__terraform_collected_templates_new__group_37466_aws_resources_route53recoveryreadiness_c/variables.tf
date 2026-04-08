variable "cell_name" {
  description = "Unique name describing the cell."
  type        = string

  validation {
    condition     = length(var.cell_name) > 0
    error_message = "resource_aws_route53recoveryreadiness_cell, cell_name must not be empty."
  }
}

variable "cells" {
  description = "List of cell arns to add as nested fault domains within this cell."
  type        = list(string)
  default     = null

  validation {
    condition = var.cells == null ? true : alltrue([
      for cell_arn in var.cells : can(regex("^arn:aws:route53-recovery-readiness:", cell_arn))
    ])
    error_message = "resource_aws_route53recoveryreadiness_cell, cells must be valid Route53 Recovery Readiness cell ARNs."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.tags : can(regex("^[\\w\\s+=,.@-]{1,128}$", key)) && can(regex("^[\\w\\s+=,.@-]{0,256}$", value))
    ])
    error_message = "resource_aws_route53recoveryreadiness_cell, tags keys must be 1-128 characters and values must be 0-256 characters, using only letters, numbers, spaces, and the following characters: + = . @ - _."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operation."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[msh]$", var.timeouts_delete))
    error_message = "resource_aws_route53recoveryreadiness_cell, timeouts_delete must be a valid duration (e.g., 5m, 10s, 1h)."
  }
}