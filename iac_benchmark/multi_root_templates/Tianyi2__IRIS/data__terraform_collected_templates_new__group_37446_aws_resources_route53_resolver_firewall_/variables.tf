variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "A name that lets you identify the rule group association"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_route53_resolver_firewall_rule_group_association, name must not be empty."
  }
}

variable "firewall_rule_group_id" {
  description = "The unique identifier of the firewall rule group"
  type        = string

  validation {
    condition     = length(var.firewall_rule_group_id) > 0
    error_message = "resource_aws_route53_resolver_firewall_rule_group_association, firewall_rule_group_id must not be empty."
  }
}

variable "mutation_protection" {
  description = "Setting that disallows modification or removal of the association"
  type        = string
  default     = null

  validation {
    condition     = var.mutation_protection == null || contains(["ENABLED", "DISABLED"], var.mutation_protection)
    error_message = "resource_aws_route53_resolver_firewall_rule_group_association, mutation_protection must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "priority" {
  description = "The setting that determines the processing order of the rule group"
  type        = number

  validation {
    condition     = var.priority >= 1 && var.priority <= 9999
    error_message = "resource_aws_route53_resolver_firewall_rule_group_association, priority must be between 1 and 9999."
  }
}

variable "vpc_id" {
  description = "The unique identifier of the VPC to associate with the rule group"
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "resource_aws_route53_resolver_firewall_rule_group_association, vpc_id must not be empty."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}