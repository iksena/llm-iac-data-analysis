variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_ec2_transit_gateway_route_table_association, region must be a valid AWS region name consisting of lowercase letters, numbers, and hyphens."
  }
}

variable "transit_gateway_attachment_id" {
  description = "Identifier of EC2 Transit Gateway Attachment."
  type        = string

  validation {
    condition     = can(regex("^tgw-attach-[0-9a-f]{8,17}$", var.transit_gateway_attachment_id))
    error_message = "resource_aws_ec2_transit_gateway_route_table_association, transit_gateway_attachment_id must be a valid Transit Gateway Attachment ID (tgw-attach-xxxxxxxx)."
  }
}

variable "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table."
  type        = string

  validation {
    condition     = can(regex("^tgw-rtb-[0-9a-f]{8,17}$", var.transit_gateway_route_table_id))
    error_message = "resource_aws_ec2_transit_gateway_route_table_association, transit_gateway_route_table_id must be a valid Transit Gateway Route Table ID (tgw-rtb-xxxxxxxx)."
  }
}

variable "replace_existing_association" {
  description = "Boolean whether the Gateway Attachment should remove any current Route Table association before associating with the specified Route Table. Default value: false. This argument is intended for use with EC2 Transit Gateways shared into the current account."
  type        = bool
  default     = false

  validation {
    condition     = can(tobool(var.replace_existing_association))
    error_message = "resource_aws_ec2_transit_gateway_route_table_association, replace_existing_association must be a boolean value (true or false)."
  }
}