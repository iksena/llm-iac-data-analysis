variable "route_server_id" {
  description = "The ID of the route server for which to create an endpoint"
  type        = string

  validation {
    condition     = can(regex("^rs-[0-9a-f]{8}([0-9a-f]{9}|[0-9a-f]{17})$", var.route_server_id))
    error_message = "resource_aws_vpc_route_server_endpoint, route_server_id must be a valid route server ID (rs-xxxxxxxx format)."
  }
}

variable "subnet_id" {
  description = "The ID of the subnet in which to create the route server endpoint"
  type        = string

  validation {
    condition     = can(regex("^subnet-[0-9a-f]{8}([0-9a-f]{9}|[0-9a-f]{17})$", var.subnet_id))
    error_message = "resource_aws_vpc_route_server_endpoint, subnet_id must be a valid subnet ID (subnet-xxxxxxxx format)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_vpc_route_server_endpoint, region must be a valid AWS region format (e.g., us-west-2)."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_vpc_route_server_endpoint, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_vpc_route_server_endpoint, tags values must be between 0 and 256 characters."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_vpc_route_server_endpoint, timeouts.create must be in valid duration format (e.g., 30m, 1h)."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_vpc_route_server_endpoint, timeouts.delete must be in valid duration format (e.g., 30m, 1h)."
  }
}