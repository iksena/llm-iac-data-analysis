variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "transit_gateway_id" {
  description = "Identifier of EC2 Transit Gateway"
  type        = string

  validation {
    condition     = can(regex("^tgw-[a-z0-9]+$", var.transit_gateway_id))
    error_message = "resource_aws_ec2_transit_gateway_route_table, transit_gateway_id must be a valid Transit Gateway ID starting with 'tgw-'."
  }
}

variable "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Route Table"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_ec2_transit_gateway_route_table, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_ec2_transit_gateway_route_table, tags values must be between 0 and 256 characters."
  }
}