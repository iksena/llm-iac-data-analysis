variable "default_route_table_id" {
  description = "ID of the default route table."
  type        = string

  validation {
    condition     = can(regex("^rtb-[0-9a-f]{8,17}$", var.default_route_table_id))
    error_message = "resource_aws_default_route_table, default_route_table_id must be a valid route table ID format (rtb-xxxxxxxx)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_default_route_table, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "propagating_vgws" {
  description = "List of virtual gateways for propagation."
  type        = list(string)
  default     = null

  validation {
    condition = var.propagating_vgws == null || alltrue([
      for vgw in var.propagating_vgws : can(regex("^vgw-[0-9a-f]{8,17}$", vgw))
    ])
    error_message = "resource_aws_default_route_table, propagating_vgws must be a list of valid virtual gateway IDs (vgw-xxxxxxxx) or null."
  }
}

variable "route" {
  description = "Configuration block of routes."
  type = list(object({
    cidr_block                 = optional(string)
    ipv6_cidr_block            = optional(string)
    destination_prefix_list_id = optional(string)
    core_network_arn           = optional(string)
    egress_only_gateway_id     = optional(string)
    gateway_id                 = optional(string)
    instance_id                = optional(string)
    nat_gateway_id             = optional(string)
    network_interface_id       = optional(string)
    transit_gateway_id         = optional(string)
    vpc_endpoint_id            = optional(string)
    vpc_peering_connection_id  = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for route in var.route :
      (route.cidr_block != null || route.ipv6_cidr_block != null || route.destination_prefix_list_id != null) &&
      (route.core_network_arn != null || route.egress_only_gateway_id != null || route.gateway_id != null ||
        route.instance_id != null || route.nat_gateway_id != null || route.network_interface_id != null ||
      route.transit_gateway_id != null || route.vpc_endpoint_id != null || route.vpc_peering_connection_id != null)
    ])
    error_message = "resource_aws_default_route_table, route must have at least one destination argument (cidr_block, ipv6_cidr_block, or destination_prefix_list_id) and one target argument."
  }

  validation {
    condition = alltrue([
      for route in var.route :
      route.cidr_block == null || can(cidrhost(route.cidr_block, 0))
    ])
    error_message = "resource_aws_default_route_table, route cidr_block must be a valid CIDR block."
  }

  validation {
    condition = alltrue([
      for route in var.route :
      route.ipv6_cidr_block == null || can(regex("^([0-9a-fA-F]{0,4}:){0,7}[0-9a-fA-F]{0,4}(/[0-9]{1,3})?$", route.ipv6_cidr_block))
    ])
    error_message = "resource_aws_default_route_table, route ipv6_cidr_block must be a valid IPv6 CIDR block."
  }

  validation {
    condition = alltrue([
      for route in var.route :
      route.destination_prefix_list_id == null || can(regex("^pl-[0-9a-f]{8,17}$", route.destination_prefix_list_id))
    ])
    error_message = "resource_aws_default_route_table, route destination_prefix_list_id must be a valid prefix list ID (pl-xxxxxxxx)."
  }

  validation {
    condition = alltrue([
      for route in var.route :
      route.core_network_arn == null || can(regex("^arn:aws:networkmanager::[0-9]{12}:core-network/core-network-[0-9a-f]{8,17}$", route.core_network_arn))
    ])
    error_message = "resource_aws_default_route_table, route core_network_arn must be a valid core network ARN."
  }

  validation {
    condition = alltrue([
      for route in var.route :
      route.egress_only_gateway_id == null || can(regex("^eigw-[0-9a-f]{8,17}$", route.egress_only_gateway_id))
    ])
    error_message = "resource_aws_default_route_table, route egress_only_gateway_id must be a valid egress-only internet gateway ID (eigw-xxxxxxxx)."
  }

  validation {
    condition = alltrue([
      for route in var.route :
      route.gateway_id == null || can(regex("^(igw-|vgw-)[0-9a-f]{8,17}$", route.gateway_id))
    ])
    error_message = "resource_aws_default_route_table, route gateway_id must be a valid internet gateway or virtual private gateway ID (igw-xxxxxxxx or vgw-xxxxxxxx)."
  }

  validation {
    condition = alltrue([
      for route in var.route :
      route.instance_id == null || can(regex("^i-[0-9a-f]{8,17}$", route.instance_id))
    ])
    error_message = "resource_aws_default_route_table, route instance_id must be a valid EC2 instance ID (i-xxxxxxxx)."
  }

  validation {
    condition = alltrue([
      for route in var.route :
      route.nat_gateway_id == null || can(regex("^nat-[0-9a-f]{8,17}$", route.nat_gateway_id))
    ])
    error_message = "resource_aws_default_route_table, route nat_gateway_id must be a valid NAT gateway ID (nat-xxxxxxxx)."
  }

  validation {
    condition = alltrue([
      for route in var.route :
      route.network_interface_id == null || can(regex("^eni-[0-9a-f]{8,17}$", route.network_interface_id))
    ])
    error_message = "resource_aws_default_route_table, route network_interface_id must be a valid network interface ID (eni-xxxxxxxx)."
  }

  validation {
    condition = alltrue([
      for route in var.route :
      route.transit_gateway_id == null || can(regex("^tgw-[0-9a-f]{8,17}$", route.transit_gateway_id))
    ])
    error_message = "resource_aws_default_route_table, route transit_gateway_id must be a valid transit gateway ID (tgw-xxxxxxxx)."
  }

  validation {
    condition = alltrue([
      for route in var.route :
      route.vpc_endpoint_id == null || can(regex("^vpce-[0-9a-f]{8,17}$", route.vpc_endpoint_id))
    ])
    error_message = "resource_aws_default_route_table, route vpc_endpoint_id must be a valid VPC endpoint ID (vpce-xxxxxxxx)."
  }

  validation {
    condition = alltrue([
      for route in var.route :
      route.vpc_peering_connection_id == null || can(regex("^pcx-[0-9a-f]{8,17}$", route.vpc_peering_connection_id))
    ])
    error_message = "resource_aws_default_route_table, route vpc_peering_connection_id must be a valid VPC peering connection ID (pcx-xxxxxxxx)."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key in keys(var.tags) : length(key) <= 128
    ])
    error_message = "resource_aws_default_route_table, tags keys must be 128 characters or less."
  }

  validation {
    condition = alltrue([
      for value in values(var.tags) : length(value) <= 256
    ])
    error_message = "resource_aws_default_route_table, tags values must be 256 characters or less."
  }
}