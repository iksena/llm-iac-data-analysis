variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_peering_connection_id" {
  description = "The VPC Peering Connection ID to manage."
  type        = string

  validation {
    condition     = can(regex("^pcx-[0-9a-f]{8,17}$", var.vpc_peering_connection_id))
    error_message = "resource_aws_vpc_peering_connection_accepter, vpc_peering_connection_id must be a valid VPC peering connection ID starting with 'pcx-'."
  }
}

variable "auto_accept" {
  description = "Whether or not to accept the peering request. Defaults to false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}