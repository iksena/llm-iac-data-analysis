variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "destination_cidr_block" {
  description = "IPv4 CIDR range used for destination matches. Routing decisions are based on the most specific match."
  type        = string

  validation {
    condition     = can(cidrhost(var.destination_cidr_block, 0))
    error_message = "resource_aws_ec2_local_gateway_route, destination_cidr_block must be a valid IPv4 CIDR block."
  }
}

variable "local_gateway_route_table_id" {
  description = "Identifier of EC2 Local Gateway Route Table."
  type        = string

  validation {
    condition     = can(regex("^lgw-rtb-[0-9a-f]{8,17}$", var.local_gateway_route_table_id))
    error_message = "resource_aws_ec2_local_gateway_route, local_gateway_route_table_id must be a valid EC2 Local Gateway Route Table identifier (format: lgw-rtb-xxxxxxxx)."
  }
}

variable "local_gateway_virtual_interface_group_id" {
  description = "Identifier of EC2 Local Gateway Virtual Interface Group."
  type        = string

  validation {
    condition     = can(regex("^lgw-vif-grp-[0-9a-f]{8,17}$", var.local_gateway_virtual_interface_group_id))
    error_message = "resource_aws_ec2_local_gateway_route, local_gateway_virtual_interface_group_id must be a valid EC2 Local Gateway Virtual Interface Group identifier (format: lgw-vif-grp-xxxxxxxx)."
  }
}