variable "name" {
  description = "Name of the certificate"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.name))
    error_message = "resource_aws_lightsail_certificate, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "domain_name" {
  description = "Domain name for which the certificate should be issued"
  type        = string
  default     = null

  validation {
    condition     = var.domain_name == null || can(regex("^[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.domain_name))
    error_message = "resource_aws_lightsail_certificate, domain_name must be a valid domain name format."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "subject_alternative_names" {
  description = "Set of domains that should be SANs in the issued certificate. domain_name attribute is automatically added as a Subject Alternative Name"
  type        = set(string)
  default     = null

  validation {
    condition = var.subject_alternative_names == null || alltrue([
      for domain in var.subject_alternative_names : can(regex("^[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", domain))
    ])
    error_message = "resource_aws_lightsail_certificate, subject_alternative_names must contain valid domain name formats."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. To create a key-only tag, use an empty string as the value"
  type        = map(string)
  default     = {}
}