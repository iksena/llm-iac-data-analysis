variable "firewall_rule_group_id" {
  description = "The unique identifier of the firewall rule group that you want to retrieve the rules for"
  type        = string

  validation {
    condition     = length(var.firewall_rule_group_id) > 0
    error_message = "data_aws_route53_resolver_firewall_rules, firewall_rule_group_id cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_route53_resolver_firewall_rules, region must be a valid AWS region format."
  }
}

variable "action" {
  description = "The action that DNS Firewall should take on a DNS query when it matches one of the domains in the rule's domain list"
  type        = string
  default     = null

  validation {
    condition     = var.action == null || contains(["ALLOW", "BLOCK", "ALERT"], var.action)
    error_message = "data_aws_route53_resolver_firewall_rules, action must be one of: ALLOW, BLOCK, ALERT."
  }
}

variable "priority" {
  description = "The setting that determines the processing order of the rules in a rule group"
  type        = number
  default     = null

  validation {
    condition     = var.priority == null || (var.priority >= 1 && var.priority <= 9000)
    error_message = "data_aws_route53_resolver_firewall_rules, priority must be between 1 and 9000."
  }
}