variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_ec2_transit_gateway_connect_peer, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "bgp_asn" {
  description = "The BGP ASN number assigned customer device. If not provided, it will use the same BGP ASN as is associated with Transit Gateway."
  type        = number
  default     = null

  validation {
    condition     = var.bgp_asn == null || (var.bgp_asn >= 1 && var.bgp_asn <= 4294967295)
    error_message = "resource_aws_ec2_transit_gateway_connect_peer, bgp_asn must be between 1 and 4294967295."
  }
}

variable "inside_cidr_blocks" {
  description = "The CIDR block that will be used for addressing within the tunnel. It must contain exactly one IPv4 CIDR block and up to one IPv6 CIDR block. The IPv4 CIDR block must be /29 size and must be within 169.254.0.0/16 range, with exception of: 169.254.0.0/29, 169.254.1.0/29, 169.254.2.0/29, 169.254.3.0/29, 169.254.4.0/29, 169.254.5.0/29, 169.254.169.248/29. The IPv6 CIDR block must be /125 size and must be within fd00::/8."
  type        = list(string)

  validation {
    condition     = length(var.inside_cidr_blocks) >= 1 && length(var.inside_cidr_blocks) <= 2
    error_message = "resource_aws_ec2_transit_gateway_connect_peer, inside_cidr_blocks must contain exactly one IPv4 CIDR block and up to one IPv6 CIDR block."
  }

  validation {
    condition = alltrue([
      for cidr in var.inside_cidr_blocks : can(cidrhost(cidr, 0))
    ])
    error_message = "resource_aws_ec2_transit_gateway_connect_peer, inside_cidr_blocks must contain valid CIDR blocks."
  }
}

variable "peer_address" {
  description = "The IP addressed assigned to customer device, which will be used as tunnel endpoint. It can be IPv4 or IPv6 address, but must be the same address family as transit_gateway_address."
  type        = string

  validation {
    condition     = can(regex("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$", var.peer_address)) || can(regex("^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.peer_address))
    error_message = "resource_aws_ec2_transit_gateway_connect_peer, peer_address must be a valid IPv4 or IPv6 address."
  }
}

variable "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Connect Peer."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))])
    error_message = "resource_aws_ec2_transit_gateway_connect_peer, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}

variable "transit_gateway_address" {
  description = "The IP address assigned to Transit Gateway, which will be used as tunnel endpoint. This address must be from associated Transit Gateway CIDR block. The address must be from the same address family as peer_address."
  type        = string
  default     = null

  validation {
    condition     = var.transit_gateway_address == null || can(regex("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$", var.transit_gateway_address)) || can(regex("^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.transit_gateway_address))
    error_message = "resource_aws_ec2_transit_gateway_connect_peer, transit_gateway_address must be a valid IPv4 or IPv6 address."
  }
}

variable "transit_gateway_attachment_id" {
  description = "The Transit Gateway Connect attachment ID."
  type        = string

  validation {
    condition     = can(regex("^tgw-attach-[0-9a-f]{8,17}$", var.transit_gateway_attachment_id))
    error_message = "resource_aws_ec2_transit_gateway_connect_peer, transit_gateway_attachment_id must be a valid Transit Gateway attachment ID format."
  }
}