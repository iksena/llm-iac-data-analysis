variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filter" {
  description = "Configuration block for complex filters"
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_route_table, filter: name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_route_table, filter: values must contain at least one element."
  }
}

variable "gateway_id" {
  description = "ID of an Internet Gateway or Virtual Private Gateway which is connected to the Route Table"
  type        = string
  default     = null
}

variable "route_table_id" {
  description = "ID of the specific Route Table to retrieve"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "ID of a Subnet which is connected to the Route Table"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired Route Table"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC that the desired Route Table belongs to"
  type        = string
  default     = null
}

variable "read_timeout" {
  description = "Timeout for read operations"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.read_timeout))
    error_message = "data_aws_route_table, read_timeout: must be a valid duration format (e.g., '20m', '1h', '30s')."
  }
}