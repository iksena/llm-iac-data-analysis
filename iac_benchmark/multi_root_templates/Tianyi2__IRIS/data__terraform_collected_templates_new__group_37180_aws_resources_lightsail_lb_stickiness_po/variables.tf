variable "cookie_duration" {
  description = "Cookie duration in seconds. This determines the length of the session stickiness."
  type        = number

  validation {
    condition     = var.cookie_duration > 0
    error_message = "resource_aws_lightsail_lb_stickiness_policy, cookie_duration must be a positive number."
  }
}

variable "enabled" {
  description = "Whether to enable session stickiness for the load balancer."
  type        = bool

  validation {
    condition     = can(tobool(var.enabled))
    error_message = "resource_aws_lightsail_lb_stickiness_policy, enabled must be a boolean value (true or false)."
  }
}

variable "lb_name" {
  description = "Name of the load balancer to which you want to enable session stickiness."
  type        = string

  validation {
    condition     = length(var.lb_name) > 0
    error_message = "resource_aws_lightsail_lb_stickiness_policy, lb_name cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "resource_aws_lightsail_lb_stickiness_policy, region cannot be an empty string if provided."
  }
}