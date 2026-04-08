variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]{8,17}$", var.vpc_id))
    error_message = "resource_aws_vpn_gateway_attachment, vpc_id must be a valid VPC ID (vpc-xxxxxxxx)."
  }
}

variable "vpn_gateway_id" {
  description = "The ID of the Virtual Private Gateway."
  type        = string

  validation {
    condition     = can(regex("^vgw-[a-z0-9]{8,17}$", var.vpn_gateway_id))
    error_message = "resource_aws_vpn_gateway_attachment, vpn_gateway_id must be a valid VPN Gateway ID (vgw-xxxxxxxx)."
  }
}