variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_route53_resolver_query_log_config_association, region must be a valid AWS region identifier."
  }
}

variable "resolver_query_log_config_id" {
  description = "The ID of the Route 53 Resolver query logging configuration that you want to associate a VPC with."
  type        = string

  validation {
    condition     = can(regex("^rqlc-[0-9a-f]+$", var.resolver_query_log_config_id))
    error_message = "resource_aws_route53_resolver_query_log_config_association, resolver_query_log_config_id must be a valid Route 53 Resolver query logging configuration ID (format: rqlc-*)."
  }
}

variable "resource_id" {
  description = "The ID of a VPC that you want this query logging configuration to log queries for."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.resource_id))
    error_message = "resource_aws_route53_resolver_query_log_config_association, resource_id must be a valid VPC ID (format: vpc-*)."
  }
}