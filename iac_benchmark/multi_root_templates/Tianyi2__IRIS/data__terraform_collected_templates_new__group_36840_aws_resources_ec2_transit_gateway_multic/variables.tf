variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "group_ip_address" {
  description = "The IP address assigned to the transit gateway multicast group"
  type        = string

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.group_ip_address))
    error_message = "resource_aws_ec2_transit_gateway_multicast_group_source, group_ip_address must be a valid IPv4 address."
  }
}

variable "network_interface_id" {
  description = "The group members' network interface ID to register with the transit gateway multicast group"
  type        = string

  validation {
    condition     = can(regex("^eni-[0-9a-f]+$", var.network_interface_id))
    error_message = "resource_aws_ec2_transit_gateway_multicast_group_source, network_interface_id must be a valid network interface ID starting with 'eni-'."
  }
}

variable "transit_gateway_multicast_domain_id" {
  description = "The ID of the transit gateway multicast domain"
  type        = string

  validation {
    condition     = can(regex("^tgw-mcast-domain-[0-9a-f]+$", var.transit_gateway_multicast_domain_id))
    error_message = "resource_aws_ec2_transit_gateway_multicast_group_source, transit_gateway_multicast_domain_id must be a valid transit gateway multicast domain ID starting with 'tgw-mcast-domain-'."
  }
}