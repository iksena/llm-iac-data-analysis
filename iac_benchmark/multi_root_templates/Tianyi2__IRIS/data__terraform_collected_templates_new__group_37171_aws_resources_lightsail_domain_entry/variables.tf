variable "domain_name" {
  description = "Name of the Lightsail domain in which to create the entry"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]?\\.[a-zA-Z]{2,}$", var.domain_name))
    error_message = "resource_aws_lightsail_domain_entry, domain_name must be a valid domain name."
  }
}

variable "name" {
  description = "Name of the entry record"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_lightsail_domain_entry, name must not be empty."
  }
}

variable "target" {
  description = "Target of the domain entry"
  type        = string

  validation {
    condition     = length(var.target) > 0
    error_message = "resource_aws_lightsail_domain_entry, target must not be empty."
  }
}

variable "type" {
  description = "Type of record"
  type        = string

  validation {
    condition     = contains(["A", "AAAA", "CNAME", "MX", "NS", "SOA", "SRV", "TXT"], var.type)
    error_message = "resource_aws_lightsail_domain_entry, type must be one of: A, AAAA, CNAME, MX, NS, SOA, SRV, TXT."
  }
}

variable "is_alias" {
  description = "Whether the entry should be an alias"
  type        = bool
  default     = false

  validation {
    condition     = can(var.is_alias)
    error_message = "resource_aws_lightsail_domain_entry, is_alias must be a boolean value."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_lightsail_domain_entry, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}