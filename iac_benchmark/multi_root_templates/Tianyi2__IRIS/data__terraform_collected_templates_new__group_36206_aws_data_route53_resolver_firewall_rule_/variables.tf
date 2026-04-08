variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "firewall_rule_group_id" {
  description = "The ID of the rule group."
  type        = string

  validation {
    condition     = can(regex("^rslvr-frg-[a-zA-Z0-9]+$", var.firewall_rule_group_id))
    error_message = "data_aws_route53_resolver_firewall_rule_group, firewall_rule_group_id must be a valid Route53 Resolver Firewall Rule Group ID starting with 'rslvr-frg-'."
  }

  validation {
    condition     = length(var.firewall_rule_group_id) > 0
    error_message = "data_aws_route53_resolver_firewall_rule_group, firewall_rule_group_id cannot be empty."
  }
}