variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_ec2_transit_gateway_dx_gateway_attachment, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "transit_gateway_id" {
  description = "Identifier of the EC2 Transit Gateway"
  type        = string
  default     = null

  validation {
    condition     = var.transit_gateway_id == null || can(regex("^tgw-[0-9a-f]{8,17}$", var.transit_gateway_id))
    error_message = "data_aws_ec2_transit_gateway_dx_gateway_attachment, transit_gateway_id must be a valid Transit Gateway ID format (tgw-xxxxxxxxx) or null."
  }
}

variable "dx_gateway_id" {
  description = "Identifier of the Direct Connect Gateway"
  type        = string
  default     = null

  validation {
    condition     = var.dx_gateway_id == null || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.dx_gateway_id))
    error_message = "data_aws_ec2_transit_gateway_dx_gateway_attachment, dx_gateway_id must be a valid Direct Connect Gateway ID format (UUID) or null."
  }
}

variable "filter" {
  description = "Configuration block(s) for filtering"
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = null

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_transit_gateway_dx_gateway_attachment, filter name must be non-empty string."
  }

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_dx_gateway_attachment, filter values must contain at least one value."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired Transit Gateway Direct Connect Gateway Attachment"
  type        = map(string)
  default     = null

  validation {
    condition = var.tags == null || alltrue([
      for k, v in var.tags : k != null && k != "" && v != null
    ])
    error_message = "data_aws_ec2_transit_gateway_dx_gateway_attachment, tags keys and values must be non-null and keys must be non-empty."
  }
}

variable "read_timeout" {
  description = "Read timeout for the data source"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.read_timeout))
    error_message = "data_aws_ec2_transit_gateway_dx_gateway_attachment, read_timeout must be a valid duration format (e.g., 20m, 1h, 300s)."
  }
}