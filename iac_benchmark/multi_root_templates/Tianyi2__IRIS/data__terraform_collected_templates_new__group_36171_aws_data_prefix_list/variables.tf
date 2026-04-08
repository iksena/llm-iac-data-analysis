variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "prefix_list_id" {
  description = "ID of the prefix list to select."
  type        = string
  default     = null

  validation {
    condition     = var.prefix_list_id == null || can(regex("^pl-[0-9a-f]{8,17}$", var.prefix_list_id))
    error_message = "data_aws_prefix_list, prefix_list_id must be a valid prefix list ID format (pl-xxxxxxxx)."
  }
}

variable "name" {
  description = "Name of the prefix list to select."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "data_aws_prefix_list, name must not be empty if provided."
  }
}

variable "filter" {
  description = "Configuration block(s) for filtering."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : length(f.name) > 0
    ])
    error_message = "data_aws_prefix_list, filter name must not be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_prefix_list, filter values must not be empty."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    read = optional(string, "20m")
  })
  default = {}

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.read))
    error_message = "data_aws_prefix_list, timeouts read must be in format like '20m', '1h', or '30s'."
  }
}