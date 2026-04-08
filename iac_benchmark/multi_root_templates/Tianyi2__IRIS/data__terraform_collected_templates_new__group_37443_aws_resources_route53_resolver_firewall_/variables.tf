variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "A name that lets you identify the domain list, to manage and use it."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_route53_resolver_firewall_domain_list, name must not be empty."
  }
}

variable "domains" {
  description = "A array of domains for the firewall domain list."
  type        = list(string)
  default     = []

  validation {
    condition = length(var.domains) == 0 || alltrue([
      for domain in var.domains : can(regex("^[a-zA-Z0-9.-]+$", domain))
    ])
    error_message = "resource_aws_route53_resolver_firewall_domain_list, domains must contain valid domain names."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key in keys(var.tags) : length(key) <= 128
    ])
    error_message = "resource_aws_route53_resolver_firewall_domain_list, tags keys must not exceed 128 characters."
  }

  validation {
    condition = alltrue([
      for value in values(var.tags) : length(value) <= 256
    ])
    error_message = "resource_aws_route53_resolver_firewall_domain_list, tags values must not exceed 256 characters."
  }
}