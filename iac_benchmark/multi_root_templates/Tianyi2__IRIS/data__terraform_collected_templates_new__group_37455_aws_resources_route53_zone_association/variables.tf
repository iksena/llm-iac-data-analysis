variable "zone_id" {
  description = "The private hosted zone to associate"
  type        = string

  validation {
    condition     = can(regex("^Z[A-Z0-9]+$", var.zone_id))
    error_message = "resource_aws_route53_zone_association, zone_id must be a valid Route 53 hosted zone ID starting with 'Z'."
  }
}

variable "vpc_id" {
  description = "The VPC to associate with the private hosted zone"
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "resource_aws_route53_zone_association, vpc_id must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "vpc_region" {
  description = "The VPC's region. Defaults to the region of the AWS provider"
  type        = string
  default     = null

  validation {
    condition     = var.vpc_region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.vpc_region))
    error_message = "resource_aws_route53_zone_association, vpc_region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the association"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.create_timeout))
    error_message = "resource_aws_route53_zone_association, create_timeout must be a valid timeout duration (e.g., 30m, 1h, 3600s)."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the association"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.delete_timeout))
    error_message = "resource_aws_route53_zone_association, delete_timeout must be a valid timeout duration (e.g., 30m, 1h, 3600s)."
  }
}