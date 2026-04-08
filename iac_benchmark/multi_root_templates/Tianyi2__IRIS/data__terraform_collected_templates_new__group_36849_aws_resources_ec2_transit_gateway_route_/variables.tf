variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "transit_gateway_attachment_id" {
  description = "Identifier of EC2 Transit Gateway Attachment."
  type        = string

  validation {
    condition     = var.transit_gateway_attachment_id != ""
    error_message = "resource_aws_ec2_transit_gateway_route_table_propagation, transit_gateway_attachment_id must not be empty."
  }
}

variable "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table."
  type        = string

  validation {
    condition     = var.transit_gateway_route_table_id != ""
    error_message = "resource_aws_ec2_transit_gateway_route_table_propagation, transit_gateway_route_table_id must not be empty."
  }
}