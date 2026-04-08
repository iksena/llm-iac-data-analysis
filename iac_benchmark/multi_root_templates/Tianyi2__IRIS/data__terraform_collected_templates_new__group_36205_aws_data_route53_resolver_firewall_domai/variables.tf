variable "firewall_domain_list_id" {
  description = "The ID of the domain list."
  type        = string

  validation {
    condition     = can(regex("^rslvr-fdl-", var.firewall_domain_list_id))
    error_message = "data_aws_route53_resolver_firewall_domain_list, firewall_domain_list_id must start with 'rslvr-fdl-'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_route53_resolver_firewall_domain_list, region must be a valid AWS region format (e.g., us-east-1)."
  }
}