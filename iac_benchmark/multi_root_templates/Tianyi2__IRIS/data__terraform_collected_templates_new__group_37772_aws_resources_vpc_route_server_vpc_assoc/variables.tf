variable "route_server_id" {
  description = "The unique identifier for the route server to be associated"
  type        = string

  validation {
    condition     = can(regex("^rs-[a-z0-9]+$", var.route_server_id))
    error_message = "resource_aws_vpc_route_server_vpc_association, route_server_id must be a valid route server ID starting with 'rs-'."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the route server"
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "resource_aws_vpc_route_server_vpc_association, vpc_id must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_vpc_route_server_vpc_association, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    delete = "30m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create)) && can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_vpc_route_server_vpc_association, timeouts must be in valid duration format (e.g., 30m, 1h)."
  }
}