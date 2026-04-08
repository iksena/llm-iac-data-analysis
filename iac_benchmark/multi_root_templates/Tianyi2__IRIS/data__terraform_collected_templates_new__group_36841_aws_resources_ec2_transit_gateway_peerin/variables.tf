variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "peer_account_id" {
  description = "Account ID of EC2 Transit Gateway to peer with"
  type        = string
  default     = null
}

variable "peer_region" {
  description = "Region of EC2 Transit Gateway to peer with"
  type        = string

  validation {
    condition     = var.peer_region != null && var.peer_region != ""
    error_message = "resource_aws_ec2_transit_gateway_peering_attachment, peer_region is required and cannot be empty."
  }
}

variable "peer_transit_gateway_id" {
  description = "Identifier of EC2 Transit Gateway to peer with"
  type        = string

  validation {
    condition     = var.peer_transit_gateway_id != null && var.peer_transit_gateway_id != ""
    error_message = "resource_aws_ec2_transit_gateway_peering_attachment, peer_transit_gateway_id is required and cannot be empty."
  }

  validation {
    condition     = can(regex("^tgw-[0-9a-f]{8,17}$", var.peer_transit_gateway_id))
    error_message = "resource_aws_ec2_transit_gateway_peering_attachment, peer_transit_gateway_id must be a valid transit gateway ID (tgw-xxxxxxxx)."
  }
}

variable "transit_gateway_id" {
  description = "Identifier of EC2 Transit Gateway"
  type        = string

  validation {
    condition     = var.transit_gateway_id != null && var.transit_gateway_id != ""
    error_message = "resource_aws_ec2_transit_gateway_peering_attachment, transit_gateway_id is required and cannot be empty."
  }

  validation {
    condition     = can(regex("^tgw-[0-9a-f]{8,17}$", var.transit_gateway_id))
    error_message = "resource_aws_ec2_transit_gateway_peering_attachment, transit_gateway_id must be a valid transit gateway ID (tgw-xxxxxxxx)."
  }
}

variable "options" {
  description = "Describes whether dynamic routing is enabled or disabled for the transit gateway peering request"
  type = object({
    dynamic_routing = optional(string)
  })
  default = null

  validation {
    condition = var.options == null || (
      var.options.dynamic_routing == null ||
      contains(["enable", "disable"], var.options.dynamic_routing)
    )
    error_message = "resource_aws_ec2_transit_gateway_peering_attachment, options.dynamic_routing must be either 'enable' or 'disable'."
  }
}

variable "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Peering Attachment"
  type        = map(string)
  default     = {}
}