variable "id" {
  description = "ID of the IPAM"
  type        = string

  validation {
    condition     = can(regex("^ipam-[a-f0-9]{8}$", var.id))
    error_message = "data_aws_vpc_ipam, id must be a valid IPAM ID starting with 'ipam-' followed by 8 hexadecimal characters."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_vpc_ipam, region must be a valid AWS region name or null."
  }
}