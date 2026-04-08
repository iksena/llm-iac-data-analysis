variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_ec2_carrier_gateway, region must be a valid AWS region format or null."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags)
    error_message = "resource_aws_ec2_carrier_gateway, tags must be a valid map of strings."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the carrier gateway."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8}([0-9a-f]{9})?$", var.vpc_id))
    error_message = "resource_aws_ec2_carrier_gateway, vpc_id must be a valid VPC ID format (vpc-xxxxxxxx or vpc-xxxxxxxxxxxxxxxxx)."
  }
}