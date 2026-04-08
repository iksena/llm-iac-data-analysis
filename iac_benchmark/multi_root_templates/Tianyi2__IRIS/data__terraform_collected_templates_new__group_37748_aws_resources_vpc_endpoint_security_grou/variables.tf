variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "security_group_id" {
  description = "The ID of the security group to be associated with the VPC endpoint."
  type        = string

  validation {
    condition     = can(regex("^sg-[0-9a-f]{8,17}$", var.security_group_id))
    error_message = "resource_aws_vpc_endpoint_security_group_association, security_group_id must be a valid security group ID (sg-xxxxxxxx)."
  }
}

variable "vpc_endpoint_id" {
  description = "The ID of the VPC endpoint with which the security group will be associated."
  type        = string

  validation {
    condition     = can(regex("^vpce-[0-9a-f]{8,17}$", var.vpc_endpoint_id))
    error_message = "resource_aws_vpc_endpoint_security_group_association, vpc_endpoint_id must be a valid VPC endpoint ID (vpce-xxxxxxxx)."
  }
}

variable "replace_default_association" {
  description = "Whether this association should replace the association with the VPC's default security group that is created when no security groups are specified during VPC endpoint creation. At most 1 association per-VPC endpoint should be configured with replace_default_association = true. false should be used when importing resources."
  type        = bool
  default     = null
}