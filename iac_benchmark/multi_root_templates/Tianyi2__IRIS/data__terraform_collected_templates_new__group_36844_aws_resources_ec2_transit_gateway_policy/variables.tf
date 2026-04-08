variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_ec2_transit_gateway_policy_table_association, region must be a valid AWS region identifier."
  }
}

variable "transit_gateway_attachment_id" {
  type        = string
  description = "Identifier of EC2 Transit Gateway Attachment."

  validation {
    condition     = can(regex("^tgw-attach-[0-9a-f]{8,17}$", var.transit_gateway_attachment_id))
    error_message = "resource_aws_ec2_transit_gateway_policy_table_association, transit_gateway_attachment_id must be a valid Transit Gateway Attachment ID (tgw-attach-xxxxxxxx)."
  }
}

variable "transit_gateway_policy_table_id" {
  type        = string
  description = "Identifier of EC2 Transit Gateway Policy Table."

  validation {
    condition     = can(regex("^tgw-rtb-[0-9a-f]{8,17}$", var.transit_gateway_policy_table_id))
    error_message = "resource_aws_ec2_transit_gateway_policy_table_association, transit_gateway_policy_table_id must be a valid Transit Gateway Policy Table ID (tgw-rtb-xxxxxxxx)."
  }
}