variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_ec2_transit_gateway_policy_table, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "transit_gateway_id" {
  description = "EC2 Transit Gateway identifier."
  type        = string

  validation {
    condition     = can(regex("^tgw-[a-f0-9]{8,17}$", var.transit_gateway_id))
    error_message = "resource_aws_ec2_transit_gateway_policy_table, transit_gateway_id must be a valid Transit Gateway ID format (tgw-xxxxxxxx)."
  }
}

variable "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Policy Table. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(keys(var.tags))
    error_message = "resource_aws_ec2_transit_gateway_policy_table, tags must be a valid map of strings."
  }
}