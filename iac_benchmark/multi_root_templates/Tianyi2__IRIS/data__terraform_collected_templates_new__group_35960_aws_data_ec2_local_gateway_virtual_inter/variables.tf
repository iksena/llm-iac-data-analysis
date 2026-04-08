variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "id" {
  description = "Identifier of EC2 Local Gateway Virtual Interface"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "filter" {
  description = "Configuration blocks containing name-values filters"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_local_gateway_virtual_interface, filter: filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_local_gateway_virtual_interface, filter: filter values must contain at least one value."
  }
}

variable "timeouts_read" {
  description = "Read timeout configuration"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_ec2_local_gateway_virtual_interface, timeouts_read: must be a valid duration (e.g., '20m', '1h', '30s')."
  }
}