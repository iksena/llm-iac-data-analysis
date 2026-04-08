variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "group_ip_address" {
  description = "The IP address assigned to the transit gateway multicast group."
  type        = string

  validation {
    condition     = can(cidrhost("${var.group_ip_address}/32", 0))
    error_message = "resource_aws_ec2_transit_gateway_multicast_group_member, group_ip_address must be a valid IP address."
  }
}

variable "network_interface_id" {
  description = "The group members' network interface ID to register with the transit gateway multicast group."
  type        = string

  validation {
    condition     = can(regex("^eni-[0-9a-f]{8,17}$", var.network_interface_id))
    error_message = "resource_aws_ec2_transit_gateway_multicast_group_member, network_interface_id must be a valid network interface ID (eni-xxxxxxxx)."
  }
}

variable "transit_gateway_multicast_domain_id" {
  description = "The ID of the transit gateway multicast domain."
  type        = string

  validation {
    condition     = can(regex("^tgw-mcast-domain-[0-9a-f]{8,17}$", var.transit_gateway_multicast_domain_id))
    error_message = "resource_aws_ec2_transit_gateway_multicast_group_member, transit_gateway_multicast_domain_id must be a valid transit gateway multicast domain ID (tgw-mcast-domain-xxxxxxxx)."
  }
}