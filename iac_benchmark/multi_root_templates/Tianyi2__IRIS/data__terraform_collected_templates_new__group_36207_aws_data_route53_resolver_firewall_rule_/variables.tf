variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "firewall_rule_group_association_id" {
  description = "The identifier for the association."
  type        = string

  validation {
    condition     = length(var.firewall_rule_group_association_id) > 0
    error_message = "data_aws_route53_resolver_firewall_rule_group_association, firewall_rule_group_association_id must be a non-empty string."
  }
}