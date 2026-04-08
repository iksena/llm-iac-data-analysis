variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_lb_cookie_stickiness_policy, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "name" {
  description = "The name of the stickiness policy"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 32
    error_message = "resource_aws_lb_cookie_stickiness_policy, name must be between 1 and 32 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "resource_aws_lb_cookie_stickiness_policy, name can only contain alphanumeric characters and hyphens."
  }
}

variable "load_balancer" {
  description = "The load balancer to which the policy should be attached"
  type        = string

  validation {
    condition     = length(var.load_balancer) > 0
    error_message = "resource_aws_lb_cookie_stickiness_policy, load_balancer is required and cannot be empty."
  }
}

variable "lb_port" {
  description = "The load balancer port to which the policy should be applied"
  type        = number

  validation {
    condition     = var.lb_port >= 1 && var.lb_port <= 65535
    error_message = "resource_aws_lb_cookie_stickiness_policy, lb_port must be between 1 and 65535."
  }
}

variable "cookie_expiration_period" {
  description = "The time period after which the session cookie should be considered stale, expressed in seconds"
  type        = number
  default     = null

  validation {
    condition     = var.cookie_expiration_period == null || (var.cookie_expiration_period >= 1 && var.cookie_expiration_period <= 604800)
    error_message = "resource_aws_lb_cookie_stickiness_policy, cookie_expiration_period must be between 1 and 604800 seconds (7 days) when specified."
  }
}