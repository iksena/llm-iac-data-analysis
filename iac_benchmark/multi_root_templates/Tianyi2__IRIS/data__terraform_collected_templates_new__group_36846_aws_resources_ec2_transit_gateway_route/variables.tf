variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "destination_cidr_block" {
  description = "IPv4 or IPv6 RFC1924 CIDR used for destination matches. Routing decisions are based on the most specific match."
  type        = string

  validation {
    condition     = can(cidrhost(var.destination_cidr_block, 0))
    error_message = "resource_aws_ec2_transit_gateway_route, destination_cidr_block must be a valid IPv4 or IPv6 CIDR block."
  }
}

variable "transit_gateway_attachment_id" {
  description = "Identifier of EC2 Transit Gateway Attachment (required if blackhole is set to false)."
  type        = string
  default     = null

  validation {
    condition     = var.transit_gateway_attachment_id == null || can(regex("^tgw-attach-[0-9a-f]+$", var.transit_gateway_attachment_id))
    error_message = "resource_aws_ec2_transit_gateway_route, transit_gateway_attachment_id must be a valid Transit Gateway Attachment ID (format: tgw-attach-xxxxxxxx)."
  }
}

variable "blackhole" {
  description = "Indicates whether to drop traffic that matches this route (default to false)."
  type        = bool
  default     = false
}

variable "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table."
  type        = string

  validation {
    condition     = can(regex("^tgw-rtb-[0-9a-f]+$", var.transit_gateway_route_table_id))
    error_message = "resource_aws_ec2_transit_gateway_route, transit_gateway_route_table_id must be a valid Transit Gateway Route Table ID (format: tgw-rtb-xxxxxxxx)."
  }
}