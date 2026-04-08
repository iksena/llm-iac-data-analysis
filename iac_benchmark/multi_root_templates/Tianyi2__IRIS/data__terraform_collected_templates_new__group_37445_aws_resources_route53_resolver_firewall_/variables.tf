variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]+-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_route53_resolver_firewall_rule_group, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "name" {
  description = "A name that lets you identify the rule group, to manage and use it"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "resource_aws_route53_resolver_firewall_rule_group, name must be between 1 and 64 characters."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) <= 128 && length(v) <= 256])
    error_message = "resource_aws_route53_resolver_firewall_rule_group, tags keys must be <= 128 characters and values must be <= 256 characters."
  }
}