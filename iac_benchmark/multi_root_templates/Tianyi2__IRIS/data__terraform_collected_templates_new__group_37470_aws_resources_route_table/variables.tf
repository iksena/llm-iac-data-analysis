variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string

  validation {
    condition     = var.vpc_id != null && var.vpc_id != ""
    error_message = "resource_aws_route_table, vpc_id is required and cannot be empty."
  }
}

variable "route" {
  description = "A list of route objects. This argument is processed in attribute-as-blocks mode. Omitting this argument is interpreted as ignoring any existing routes. To remove all managed routes an empty list should be specified."
  type = list(object({
    cidr_block                 = optional(string)
    ipv6_cidr_block            = optional(string)
    destination_prefix_list_id = optional(string)
    carrier_gateway_id         = optional(string)
    core_network_arn           = optional(string)
    egress_only_gateway_id     = optional(string)
    gateway_id                 = optional(string)
    local_gateway_id           = optional(string)
    nat_gateway_id             = optional(string)
    network_interface_id       = optional(string)
    transit_gateway_id         = optional(string)
    vpc_endpoint_id            = optional(string)
    vpc_peering_connection_id  = optional(string)
  }))
  default = null

  validation {
    condition = var.route == null ? true : alltrue([
      for r in var.route : (
        (r.cidr_block != null && r.cidr_block != "") ||
        (r.ipv6_cidr_block != null && r.ipv6_cidr_block != "") ||
        (r.destination_prefix_list_id != null && r.destination_prefix_list_id != "")
      )
    ])
    error_message = "resource_aws_route_table, route must have at least one destination argument: cidr_block, ipv6_cidr_block, or destination_prefix_list_id."
  }

  validation {
    condition = var.route == null ? true : alltrue([
      for r in var.route : (
        (r.carrier_gateway_id != null && r.carrier_gateway_id != "") ||
        (r.core_network_arn != null && r.core_network_arn != "") ||
        (r.egress_only_gateway_id != null && r.egress_only_gateway_id != "") ||
        (r.gateway_id != null && r.gateway_id != "") ||
        (r.local_gateway_id != null && r.local_gateway_id != "") ||
        (r.nat_gateway_id != null && r.nat_gateway_id != "") ||
        (r.network_interface_id != null && r.network_interface_id != "") ||
        (r.transit_gateway_id != null && r.transit_gateway_id != "") ||
        (r.vpc_endpoint_id != null && r.vpc_endpoint_id != "") ||
        (r.vpc_peering_connection_id != null && r.vpc_peering_connection_id != "")
      )
    ])
    error_message = "resource_aws_route_table, route must have at least one target argument: carrier_gateway_id, core_network_arn, egress_only_gateway_id, gateway_id, local_gateway_id, nat_gateway_id, network_interface_id, transit_gateway_id, vpc_endpoint_id, or vpc_peering_connection_id."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = null
}

variable "propagating_vgws" {
  description = "A list of virtual gateways for propagation."
  type        = list(string)
  default     = null
}