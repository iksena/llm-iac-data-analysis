variable "zone_id" {
  description = "The ID of the private hosted zone that you want to authorize associating a VPC with"
  type        = string

  validation {
    condition     = can(regex("^Z[A-Z0-9]+$", var.zone_id))
    error_message = "resource_aws_route53_vpc_association_authorization, zone_id must be a valid Route 53 Hosted Zone ID starting with 'Z' followed by alphanumeric characters."
  }
}

variable "vpc_id" {
  description = "The VPC to authorize for association with the private hosted zone"
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "resource_aws_route53_vpc_association_authorization, vpc_id must be a valid VPC ID starting with 'vpc-' followed by lowercase alphanumeric characters."
  }
}

variable "vpc_region" {
  description = "The VPC's region. Defaults to the region of the AWS provider"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Configuration options for operation timeouts"
  type = object({
    create = optional(string, "20m")
    read   = optional(string, "5m")
    delete = optional(string, "20m")
  })
  default = null
}