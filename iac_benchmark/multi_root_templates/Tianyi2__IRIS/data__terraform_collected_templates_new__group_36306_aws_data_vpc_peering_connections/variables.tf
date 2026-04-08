variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_vpc_peering_connections, region must be a valid AWS region format or null."
  }
}

variable "filter" {
  description = "Custom filter block to filter VPC peering connections"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = null

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : f.name != null && length(f.name) > 0 && f.values != null && length(f.values) > 0
    ])
    error_message = "data_aws_vpc_peering_connections, filter blocks must have non-empty name and values."
  }
}

variable "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the desired VPC Peering Connection"
  type        = map(string)
  default     = null

  validation {
    condition = var.tags == null || alltrue([
      for k, v in var.tags : k != null && v != null
    ])
    error_message = "data_aws_vpc_peering_connections, tags must not contain null keys or values."
  }
}

variable "timeouts_read" {
  description = "How long to wait for the VPC peering connections data source to return"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_vpc_peering_connections, timeouts_read must be a valid timeout format (e.g., '20m', '5s', '1h')."
  }
}