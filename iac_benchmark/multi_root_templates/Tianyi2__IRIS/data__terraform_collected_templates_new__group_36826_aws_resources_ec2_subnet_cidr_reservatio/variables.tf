variable "cidr_block" {
  description = "The CIDR block for the reservation"
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "resource_aws_ec2_subnet_cidr_reservation, cidr_block must be a valid CIDR block."
  }
}

variable "reservation_type" {
  description = "The type of reservation to create"
  type        = string

  validation {
    condition     = contains(["explicit", "prefix"], var.reservation_type)
    error_message = "resource_aws_ec2_subnet_cidr_reservation, reservation_type must be either 'explicit' or 'prefix'."
  }
}

variable "subnet_id" {
  description = "The ID of the subnet to create the reservation for"
  type        = string

  validation {
    condition     = can(regex("^subnet-[a-z0-9]+$", var.subnet_id))
    error_message = "resource_aws_ec2_subnet_cidr_reservation, subnet_id must be a valid subnet ID (subnet-xxxxxxxx)."
  }
}

variable "description" {
  description = "A brief description of the reservation"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}