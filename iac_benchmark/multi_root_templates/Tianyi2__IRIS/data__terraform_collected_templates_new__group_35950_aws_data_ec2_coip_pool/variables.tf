variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "local_gateway_route_table_id" {
  description = "Local Gateway Route Table Id assigned to desired COIP Pool"
  type        = string
  default     = null
}

variable "pool_id" {
  description = "ID of the specific COIP Pool to retrieve"
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the desired COIP Pool"
  type        = map(string)
  default     = {}
}

variable "filter" {
  description = "One or more filter blocks to filter COIP pools"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_coip_pool, filter: name must be a non-empty string."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_coip_pool, filter: values must contain at least one element."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    read = optional(string, "20m")
  })
  default = null

  validation {
    condition     = var.timeouts == null || can(regex("^[0-9]+[smh]$", var.timeouts.read))
    error_message = "data_aws_ec2_coip_pool, timeouts: read must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}