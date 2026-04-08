variable "name" {
  description = "Name for the allocated static IP"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name)) && length(var.name) > 0
    error_message = "resource_aws_lightsail_static_ip, name must be a non-empty string containing only alphanumeric characters, dots, underscores, and hyphens."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_lightsail_static_ip, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null."
  }
}