variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_id" {
  description = "The ID of the VPC that the configuration is for."
  type        = string

  validation {
    condition     = length(var.resource_id) > 0
    error_message = "resource_aws_route53_resolver_config, resource_id must be a non-empty string."
  }
}

variable "autodefined_reverse_flag" {
  description = "Indicates whether or not the Resolver will create autodefined rules for reverse DNS lookups."
  type        = string

  validation {
    condition     = contains(["ENABLE", "DISABLE"], var.autodefined_reverse_flag)
    error_message = "resource_aws_route53_resolver_config, autodefined_reverse_flag must be either 'ENABLE' or 'DISABLE'."
  }
}