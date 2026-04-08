variable "domain_name" {
  description = "Name of the Lightsail domain to manage"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.domain_name)) && length(var.domain_name) > 0
    error_message = "resource_aws_lightsail_domain, domain_name must be a valid domain name containing only lowercase letters, numbers, dots, and hyphens."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_lightsail_domain, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}