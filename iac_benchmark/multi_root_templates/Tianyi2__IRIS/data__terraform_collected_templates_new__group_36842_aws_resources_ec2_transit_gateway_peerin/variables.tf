variable "transit_gateway_attachment_id" {
  description = "The ID of the EC2 Transit Gateway Peering Attachment to manage"
  type        = string

  validation {
    condition     = can(regex("^tgw-attach-[0-9a-f]{8,17}$", var.transit_gateway_attachment_id))
    error_message = "resource_aws_ec2_transit_gateway_peering_attachment_accepter, transit_gateway_attachment_id must be a valid Transit Gateway attachment ID (format: tgw-attach-xxxxxxxxx)."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Peering Attachment"
  type        = map(string)
  default     = {}
}