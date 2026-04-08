variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The ID of the VPC to which we would like to associate a DHCP Options Set."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "resource_aws_vpc_dhcp_options_association, vpc_id must be a valid VPC ID format (vpc-xxxxxxxx)."
  }
}

variable "dhcp_options_id" {
  description = "The ID of the DHCP Options Set to associate to the VPC."
  type        = string

  validation {
    condition     = can(regex("^dopt-[0-9a-f]{8,17}$", var.dhcp_options_id))
    error_message = "resource_aws_vpc_dhcp_options_association, dhcp_options_id must be a valid DHCP Options ID format (dopt-xxxxxxxx)."
  }
}