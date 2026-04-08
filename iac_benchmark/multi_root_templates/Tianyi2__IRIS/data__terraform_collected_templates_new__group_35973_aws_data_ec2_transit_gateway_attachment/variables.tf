variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_ec2_transit_gateway_attachment, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "filter" {
  description = "One or more configuration blocks containing name-values filters."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_transit_gateway_attachment, filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_attachment, filter values must contain at least one value."
  }
}

variable "transit_gateway_attachment_id" {
  description = "ID of the attachment."
  type        = string
  default     = null

  validation {
    condition     = var.transit_gateway_attachment_id == null || can(regex("^tgw-attach-[0-9a-f]{8,17}$", var.transit_gateway_attachment_id))
    error_message = "data_aws_ec2_transit_gateway_attachment, transit_gateway_attachment_id must be a valid transit gateway attachment ID format (tgw-attach-xxxxxxxxx)."
  }
}