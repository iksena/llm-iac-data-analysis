variable "name" {
  description = "This is the name of the hosted zone."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_route53_zone, name must not be empty."
  }
}

variable "comment" {
  description = "A comment for the hosted zone. Defaults to 'Managed by Terraform'."
  type        = string
  default     = "Managed by Terraform"

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\s\\-_\\.]*$", var.comment))
    error_message = "resource_aws_route53_zone, comment must contain only alphanumeric characters, spaces, hyphens, underscores, and periods."
  }
}

variable "delegation_set_id" {
  description = "The ID of the reusable delegation set whose NS records you want to assign to the hosted zone. Conflicts with vpc as delegation sets can only be used for public zones."
  type        = string
  default     = null

  validation {
    condition     = var.delegation_set_id == null || can(regex("^N[A-Z0-9]{12,32}$", var.delegation_set_id))
    error_message = "resource_aws_route53_zone, delegation_set_id must be a valid delegation set ID format when provided."
  }
}

variable "force_destroy" {
  description = "Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the zone."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s\\-_\\.:\\/\\+\\=@]*$", k)) && can(regex("^[a-zA-Z0-9\\s\\-_\\.:\\/\\+\\=@]*$", v))
    ])
    error_message = "resource_aws_route53_zone, tags keys and values must contain only valid characters."
  }
}

variable "vpc" {
  description = "Configuration block(s) specifying VPC(s) to associate with a private hosted zone. Conflicts with the delegation_set_id argument."
  type = list(object({
    vpc_id     = string
    vpc_region = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for vpc in var.vpc : can(regex("^vpc-[a-z0-9]{8,17}$", vpc.vpc_id))
    ])
    error_message = "resource_aws_route53_zone, vpc vpc_id must be a valid VPC ID format."
  }

  validation {
    condition = alltrue([
      for vpc in var.vpc : vpc.vpc_region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", vpc.vpc_region))
    ])
    error_message = "resource_aws_route53_zone, vpc vpc_region must be a valid AWS region format when provided."
  }
}