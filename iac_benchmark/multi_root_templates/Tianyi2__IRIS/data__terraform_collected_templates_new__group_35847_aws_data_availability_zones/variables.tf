variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "all_availability_zones" {
  description = "Set to true to include all Availability Zones and Local Zones regardless of your opt in status."
  type        = bool
  default     = null
}

variable "filter" {
  description = "Configuration block(s) for filtering. Each filter block contains name and values."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_availability_zones, filter: name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_availability_zones, filter: values must contain at least one value."
  }
}

variable "exclude_names" {
  description = "List of Availability Zone names to exclude."
  type        = list(string)
  default     = null
}

variable "exclude_zone_ids" {
  description = "List of Availability Zone IDs to exclude."
  type        = list(string)
  default     = null
}

variable "state" {
  description = "Allows to filter list of Availability Zones based on their current state. Can be either 'available', 'information', 'impaired' or 'unavailable'."
  type        = string
  default     = null

  validation {
    condition     = var.state == null || contains(["available", "information", "impaired", "unavailable"], var.state)
    error_message = "data_aws_availability_zones, state must be one of: available, information, impaired, unavailable."
  }
}

variable "read_timeout" {
  description = "Read timeout for the availability zones data source."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.read_timeout))
    error_message = "data_aws_availability_zones, read_timeout must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}