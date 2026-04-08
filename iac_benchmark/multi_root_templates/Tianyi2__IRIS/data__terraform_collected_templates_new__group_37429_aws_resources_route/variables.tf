variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "route_table_id" {
  description = "The ID of the routing table."
  type        = string

  validation {
    condition     = var.route_table_id != null && var.route_table_id != ""
    error_message = "resource_aws_route, route_table_id must be provided and cannot be empty."
  }
}

# Destination arguments (exactly one must be supplied)
variable "destination_cidr_block" {
  description = "The destination CIDR block."
  type        = string
  default     = null
}

variable "destination_ipv6_cidr_block" {
  description = "The destination IPv6 CIDR block."
  type        = string
  default     = null
}

variable "destination_prefix_list_id" {
  description = "The ID of a managed prefix list destination."
  type        = string
  default     = null
}

# Target arguments (exactly one must be supplied)
variable "carrier_gateway_id" {
  description = "Identifier of a carrier gateway. This attribute can only be used when the VPC contains a subnet which is associated with a Wavelength Zone."
  type        = string
  default     = null
}

variable "core_network_arn" {
  description = "The Amazon Resource Name (ARN) of a core network."
  type        = string
  default     = null
}

variable "egress_only_gateway_id" {
  description = "Identifier of a VPC Egress Only Internet Gateway."
  type        = string
  default     = null
}

variable "gateway_id" {
  description = "Identifier of a VPC internet gateway or a virtual private gateway. Specify 'local' when updating a previously imported local route."
  type        = string
  default     = null
}

variable "nat_gateway_id" {
  description = "Identifier of a VPC NAT gateway."
  type        = string
  default     = null
}

variable "local_gateway_id" {
  description = "Identifier of a Outpost local gateway."
  type        = string
  default     = null
}

variable "network_interface_id" {
  description = "Identifier of an EC2 network interface."
  type        = string
  default     = null
}

variable "transit_gateway_id" {
  description = "Identifier of an EC2 Transit Gateway."
  type        = string
  default     = null
}

variable "vpc_endpoint_id" {
  description = "Identifier of a VPC Endpoint."
  type        = string
  default     = null
}

variable "vpc_peering_connection_id" {
  description = "Identifier of a VPC peering connection."
  type        = string
  default     = null
}

# Timeout variables
variable "timeouts_create" {
  description = "Timeout for creating the route."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_create))
    error_message = "resource_aws_route, timeouts_create must be a valid duration format (e.g., '5m', '30s', '1h')."
  }
}

variable "timeouts_update" {
  description = "Timeout for updating the route."
  type        = string
  default     = "2m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_update))
    error_message = "resource_aws_route, timeouts_update must be a valid duration format (e.g., '5m', '30s', '1h')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the route."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_delete))
    error_message = "resource_aws_route, timeouts_delete must be a valid duration format (e.g., '5m', '30s', '1h')."
  }
}

# Validation to ensure exactly one destination argument is provided
locals {
  destination_count = length([
    for v in [var.destination_cidr_block, var.destination_ipv6_cidr_block, var.destination_prefix_list_id] : v if v != null
  ])
}

# Validation to ensure exactly one target argument is provided
locals {
  target_count = length([
    for v in [
      var.carrier_gateway_id,
      var.core_network_arn,
      var.egress_only_gateway_id,
      var.gateway_id,
      var.nat_gateway_id,
      var.local_gateway_id,
      var.network_interface_id,
      var.transit_gateway_id,
      var.vpc_endpoint_id,
      var.vpc_peering_connection_id
    ] : v if v != null
  ])
}

