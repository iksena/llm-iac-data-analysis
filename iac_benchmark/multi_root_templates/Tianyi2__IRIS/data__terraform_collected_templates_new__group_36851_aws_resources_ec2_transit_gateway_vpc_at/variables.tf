variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "transit_gateway_attachment_id" {
  description = "The ID of the EC2 Transit Gateway Attachment to manage."
  type        = string

  validation {
    condition     = can(regex("^tgw-attach-[0-9a-f]{8,17}$", var.transit_gateway_attachment_id))
    error_message = "resource_aws_ec2_transit_gateway_vpc_attachment_accepter, transit_gateway_attachment_id must be a valid Transit Gateway VPC Attachment ID (format: tgw-attach-xxxxxxxxx)."
  }
}

variable "transit_gateway_default_route_table_association" {
  description = "Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table."
  type        = bool
  default     = true

  validation {
    condition     = can(tobool(var.transit_gateway_default_route_table_association))
    error_message = "resource_aws_ec2_transit_gateway_vpc_attachment_accepter, transit_gateway_default_route_table_association must be a boolean value (true or false)."
  }
}

variable "transit_gateway_default_route_table_propagation" {
  description = "Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table."
  type        = bool
  default     = true

  validation {
    condition     = can(tobool(var.transit_gateway_default_route_table_propagation))
    error_message = "resource_aws_ec2_transit_gateway_vpc_attachment_accepter, transit_gateway_default_route_table_propagation must be a boolean value (true or false)."
  }
}

variable "tags" {
  description = "Key-value tags for the EC2 Transit Gateway VPC Attachment. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(keys(var.tags))
    error_message = "resource_aws_ec2_transit_gateway_vpc_attachment_accepter, tags must be a map of strings."
  }
}