variable "enabled" {
  description = "Whether to enable HTTP to HTTPS redirection. true to activate HTTP to HTTPS redirection or false to deactivate HTTP to HTTPS redirection."
  type        = bool

  validation {
    condition     = can(var.enabled)
    error_message = "resource_aws_lightsail_lb_https_redirection_policy, enabled must be a boolean value (true or false)."
  }
}

variable "lb_name" {
  description = "Name of the load balancer to which you want to enable HTTP to HTTPS redirection."
  type        = string

  validation {
    condition     = length(var.lb_name) > 0
    error_message = "resource_aws_lightsail_lb_https_redirection_policy, lb_name cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_lightsail_lb_https_redirection_policy, region must be a valid AWS region format (e.g., us-east-1)."
  }
}