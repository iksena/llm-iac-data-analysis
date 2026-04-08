variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "security_group_id" {
  description = "The ID of the security group."
  type        = string

  validation {
    condition     = can(regex("^sg-[a-f0-9]{8,17}$", var.security_group_id))
    error_message = "resource_aws_vpc_security_group_vpc_association, security_group_id must be a valid security group ID (sg-xxxxxxxx or sg-xxxxxxxxxxxxxxxxx)."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC to make the association with."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-f0-9]{8,17}$", var.vpc_id))
    error_message = "resource_aws_vpc_security_group_vpc_association, vpc_id must be a valid VPC ID (vpc-xxxxxxxx or vpc-xxxxxxxxxxxxxxxxx)."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the VPC security group association."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_vpc_security_group_vpc_association, create_timeout must be a valid timeout format (e.g., 5m, 10s, 1h)."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the VPC security group association."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_vpc_security_group_vpc_association, delete_timeout must be a valid timeout format (e.g., 5m, 10s, 1h)."
  }
}