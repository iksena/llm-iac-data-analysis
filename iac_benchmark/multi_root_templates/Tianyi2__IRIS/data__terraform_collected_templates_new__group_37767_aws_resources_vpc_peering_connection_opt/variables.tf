variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_peering_connection_id" {
  description = "The ID of the requester VPC peering connection."
  type        = string

  validation {
    condition     = can(regex("^pcx-[0-9a-f]{8,17}$", var.vpc_peering_connection_id))
    error_message = "resource_aws_vpc_peering_connection_options, vpc_peering_connection_id must be a valid VPC peering connection ID (starts with 'pcx-')."
  }
}

variable "accepter" {
  description = "An optional configuration block that allows for VPC Peering Connection options to be set for the VPC that accepts the peering connection."
  type = object({
    allow_remote_vpc_dns_resolution = optional(bool)
  })
  default = null
}

variable "requester" {
  description = "A optional configuration block that allows for VPC Peering Connection options to be set for the VPC that requests the peering connection."
  type = object({
    allow_remote_vpc_dns_resolution = optional(bool)
  })
  default = null
}