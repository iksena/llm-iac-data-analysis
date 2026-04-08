variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "dhcp_options_id" {
  description = "EC2 DHCP Options ID"
  type        = string
  default     = null
}

variable "filter" {
  description = "List of custom filters"
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_vpc_dhcp_options, filter: name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_vpc_dhcp_options, filter: values must contain at least one element."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operation"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_vpc_dhcp_options, timeouts_read: must be a valid duration (e.g., '20m', '1h', '30s')."
  }
}