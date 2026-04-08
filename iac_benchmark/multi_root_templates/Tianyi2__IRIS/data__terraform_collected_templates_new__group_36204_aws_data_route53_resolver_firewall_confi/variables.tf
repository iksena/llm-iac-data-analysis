variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_route53_resolver_firewall_config, region must be a valid AWS region format (e.g., us-east-1) if provided."
  }
}

variable "resource_id" {
  description = "The ID of the VPC from Amazon VPC that the configuration is for."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]{8}$|^vpc-[a-z0-9]{17}$", var.resource_id))
    error_message = "data_aws_route53_resolver_firewall_config, resource_id must be a valid VPC ID format (vpc-xxxxxxxx or vpc-xxxxxxxxxxxxxxxxx)."
  }
}