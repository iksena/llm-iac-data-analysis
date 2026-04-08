variable "route_server_id" {
  description = "The unique identifier for the route server to be associated"
  type        = string

  validation {
    condition     = can(regex("^rs-[a-z0-9]+$", var.route_server_id))
    error_message = "resource_aws_vpc_route_server_propagation, route_server_id must be a valid route server ID starting with 'rs-'."
  }
}

variable "route_table_id" {
  description = "The ID of the route table to which route server will propagate routes"
  type        = string

  validation {
    condition     = can(regex("^rtb-[a-z0-9]+$", var.route_table_id))
    error_message = "resource_aws_vpc_route_server_propagation, route_table_id must be a valid route table ID starting with 'rtb-'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_vpc_route_server_propagation, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    delete = "30m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_vpc_route_server_propagation, timeouts.create must be a valid duration format (e.g., 30m, 1h)."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_vpc_route_server_propagation, timeouts.delete must be a valid duration format (e.g., 30m, 1h)."
  }
}