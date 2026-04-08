variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ebs_volume, region must be a valid AWS region format."
  }
}

variable "filter" {
  description = "One or more name/value pairs to filter off of."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = null

  validation {
    condition = var.filter == null || (length(var.filter) >= 0 && alltrue([
      for f in var.filter : f.name != null && f.values != null && length(f.values) > 0
    ]))
    error_message = "data_aws_ebs_volume, filter must contain valid name and non-empty values list."
  }
}

variable "most_recent" {
  description = "If more than one result is returned, use the most recent volume."
  type        = bool
  default     = false

  validation {
    condition     = can(tobool(var.most_recent))
    error_message = "data_aws_ebs_volume, most_recent must be a boolean value."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_ebs_volume, timeouts_read must be a valid timeout format (e.g., 20m, 1h, 30s)."
  }
}