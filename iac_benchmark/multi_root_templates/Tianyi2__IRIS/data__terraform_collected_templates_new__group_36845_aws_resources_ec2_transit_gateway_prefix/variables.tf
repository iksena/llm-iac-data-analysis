variable "prefix_list_id" {
  description = "Identifier of EC2 Prefix List"
  type        = string

  validation {
    condition     = can(regex("^pl-[0-9a-f]{8}([0-9a-f]{9})?$", var.prefix_list_id))
    error_message = "resource_aws_ec2_transit_gateway_prefix_list_reference, prefix_list_id must be a valid EC2 Prefix List ID (pl-xxxxxxxx or pl-xxxxxxxxxxxxxxxxx)."
  }
}

variable "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table"
  type        = string

  validation {
    condition     = can(regex("^tgw-rtb-[0-9a-f]{8}([0-9a-f]{9})?$", var.transit_gateway_route_table_id))
    error_message = "resource_aws_ec2_transit_gateway_prefix_list_reference, transit_gateway_route_table_id must be a valid Transit Gateway Route Table ID (tgw-rtb-xxxxxxxx or tgw-rtb-xxxxxxxxxxxxxxxxx)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "blackhole" {
  description = "Indicates whether to drop traffic that matches the Prefix List"
  type        = bool
  default     = false
}

variable "transit_gateway_attachment_id" {
  description = "Identifier of EC2 Transit Gateway Attachment"
  type        = string
  default     = null

  validation {
    condition     = var.transit_gateway_attachment_id == null || can(regex("^tgw-attach-[0-9a-f]{8}([0-9a-f]{9})?$", var.transit_gateway_attachment_id))
    error_message = "resource_aws_ec2_transit_gateway_prefix_list_reference, transit_gateway_attachment_id must be a valid Transit Gateway Attachment ID (tgw-attach-xxxxxxxx or tgw-attach-xxxxxxxxxxxxxxxxx) or null."
  }
}