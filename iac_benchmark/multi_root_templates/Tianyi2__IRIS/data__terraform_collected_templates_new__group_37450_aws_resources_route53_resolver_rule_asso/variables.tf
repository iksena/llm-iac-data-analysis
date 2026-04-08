variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_route53_resolver_rule_association, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "resolver_rule_id" {
  description = "The ID of the resolver rule that you want to associate with the VPC."
  type        = string

  validation {
    condition     = can(regex("^rslvr-rr-[a-z0-9]+$", var.resolver_rule_id))
    error_message = "resource_aws_route53_resolver_rule_association, resolver_rule_id must be a valid Route53 resolver rule ID starting with 'rslvr-rr-'."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC that you want to associate the resolver rule with."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "resource_aws_route53_resolver_rule_association, vpc_id must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "name" {
  description = "A name for the association that you're creating between a resolver rule and a VPC."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || (length(var.name) >= 1 && length(var.name) <= 255)
    error_message = "resource_aws_route53_resolver_rule_association, name must be between 1 and 255 characters when specified."
  }
}