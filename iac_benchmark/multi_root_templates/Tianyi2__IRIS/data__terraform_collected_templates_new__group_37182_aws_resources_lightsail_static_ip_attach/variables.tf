variable "instance_name" {
  description = "Name of the Lightsail instance to attach the IP to"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9\\-_]*$", var.instance_name))
    error_message = "resource_aws_lightsail_static_ip_attachment, instance_name must start with alphanumeric character and can only contain alphanumeric characters, hyphens, and underscores."
  }
}

variable "static_ip_name" {
  description = "Name of the allocated static IP"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9\\-_]*$", var.static_ip_name))
    error_message = "resource_aws_lightsail_static_ip_attachment, static_ip_name must start with alphanumeric character and can only contain alphanumeric characters, hyphens, and underscores."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9][a-z0-9\\-]*[a-z0-9]$", var.region))
    error_message = "resource_aws_lightsail_static_ip_attachment, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}