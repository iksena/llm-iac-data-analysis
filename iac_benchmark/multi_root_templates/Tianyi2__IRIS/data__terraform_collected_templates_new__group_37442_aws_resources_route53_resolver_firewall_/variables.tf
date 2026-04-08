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
    error_message = "resource_aws_route53_resolver_firewall_config, resource_id must be a non-empty string."
  }
}

variable "firewall_fail_open" {
  description = "Determines how Route 53 Resolver handles queries during failures. Valid values: ENABLED, DISABLED."
  type        = string

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.firewall_fail_open)
    error_message = "resource_aws_route53_resolver_firewall_config, firewall_fail_open must be either 'ENABLED' or 'DISABLED'."
  }
}