variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "all_availability_zones" {
  description = "Set to true to include all Availability Zones and Local Zones regardless of your opt in status."
  type        = bool
  default     = false
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
    error_message = "data_aws_availability_zone, filter: name is required and cannot be empty."
  }

  validation {
    condition = var.filter == null ? true : alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_availability_zone, filter: values must contain at least one value."
  }
}

variable "name" {
  description = "Full name of the availability zone to select."
  type        = string
  default     = null
}

variable "state" {
  description = "Specific availability zone state to require. May be any of 'available', 'information' or 'impaired'."
  type        = string
  default     = null

  validation {
    condition     = var.state == null ? true : contains(["available", "information", "impaired"], var.state)
    error_message = "data_aws_availability_zone, state: must be one of 'available', 'information', or 'impaired'."
  }
}

variable "zone_id" {
  description = "Zone ID of the availability zone to select."
  type        = string
  default     = null
}

variable "timeouts_read" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"
}