variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cidr_block" {
  description = "Cidr block of the desired VPC."
  type        = string
  default     = null
}

variable "dhcp_options_id" {
  description = "DHCP options id of the desired VPC."
  type        = string
  default     = null
}

variable "default" {
  description = "Boolean constraint on whether the desired VPC is the default VPC for the region."
  type        = bool
  default     = null
}

variable "filter" {
  description = "Custom filter blocks to filter VPCs."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_vpc, filter: filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_vpc, filter: filter values must contain at least one value."
  }
}

variable "id" {
  description = "ID of the specific VPC to retrieve."
  type        = string
  default     = null
}

variable "state" {
  description = "Current state of the desired VPC. Can be either 'pending' or 'available'."
  type        = string
  default     = null

  validation {
    condition     = var.state == null || contains(["pending", "available"], var.state)
    error_message = "data_aws_vpc, state: state must be either 'pending' or 'available'."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired VPC."
  type        = map(string)
  default     = null
}

variable "timeouts_read" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_vpc, timeouts_read: timeout must be a valid duration (e.g., '20m', '1h', '30s')."
  }
}