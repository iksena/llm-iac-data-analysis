variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_id" {
  description = "The ID of the virtual private cloud (VPC) that you're updating the DNSSEC validation status for."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8}([0-9a-f]{9})?$", var.resource_id))
    error_message = "resource_aws_route53_resolver_dnssec_config, resource_id must be a valid VPC ID (vpc-xxxxxxxx or vpc-xxxxxxxxxxxxxxxxx)."
  }
}