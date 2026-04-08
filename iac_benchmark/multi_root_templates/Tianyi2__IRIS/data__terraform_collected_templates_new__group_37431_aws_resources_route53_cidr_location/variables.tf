variable "cidr_blocks" {
  description = "CIDR blocks for the location"
  type        = list(string)

  validation {
    condition = alltrue([
      for cidr in var.cidr_blocks : can(cidrhost(cidr, 0))
    ])
    error_message = "resource_aws_route53_cidr_location, cidr_blocks must contain valid CIDR notation blocks."
  }

  validation {
    condition     = length(var.cidr_blocks) > 0
    error_message = "resource_aws_route53_cidr_location, cidr_blocks must contain at least one CIDR block."
  }
}

variable "cidr_collection_id" {
  description = "The ID of the CIDR collection to update"
  type        = string

  validation {
    condition     = length(var.cidr_collection_id) > 0
    error_message = "resource_aws_route53_cidr_location, cidr_collection_id cannot be empty."
  }
}

variable "name" {
  description = "Name for the CIDR location"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_route53_cidr_location, name cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_route53_cidr_location, name must contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}