variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filter" {
  description = "Configuration block(s) for filtering."
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = null

  validation {
    condition = var.filter == null ? true : alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_launch_template, filter: name is required and cannot be empty."
  }

  validation {
    condition = var.filter == null ? true : alltrue([
      for f in var.filter : f.values != null && length(f.values) > 0
    ])
    error_message = "data_aws_launch_template, filter: values is required and cannot be empty."
  }
}

variable "id" {
  description = "ID of the specific launch template to retrieve."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the launch template."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired Launch Template."
  type        = map(string)
  default     = null
}

variable "timeouts_read" {
  description = "How long to wait for the launch template data to be read."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_read))
    error_message = "data_aws_launch_template, timeouts_read must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}