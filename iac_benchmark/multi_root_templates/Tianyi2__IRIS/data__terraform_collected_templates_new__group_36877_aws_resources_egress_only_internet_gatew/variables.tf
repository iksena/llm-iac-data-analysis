variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The VPC ID to create in."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]{8,17}$", var.vpc_id))
    error_message = "resource_aws_egress_only_internet_gateway, vpc_id must be a valid VPC ID starting with 'vpc-' followed by 8-17 hexadecimal characters."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}