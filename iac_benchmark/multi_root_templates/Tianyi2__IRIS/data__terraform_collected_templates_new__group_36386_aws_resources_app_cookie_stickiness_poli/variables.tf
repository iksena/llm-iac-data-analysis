variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the stickiness policy."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_app_cookie_stickiness_policy, name must not be empty."
  }
}

variable "load_balancer" {
  description = "Name of load balancer to which the policy should be attached."
  type        = string

  validation {
    condition     = length(var.load_balancer) > 0
    error_message = "resource_aws_app_cookie_stickiness_policy, load_balancer must not be empty."
  }
}

variable "lb_port" {
  description = "Load balancer port to which the policy should be applied. This must be an active listener on the load balancer."
  type        = number

  validation {
    condition     = var.lb_port > 0 && var.lb_port <= 65535
    error_message = "resource_aws_app_cookie_stickiness_policy, lb_port must be between 1 and 65535."
  }
}

variable "cookie_name" {
  description = "Application cookie whose lifetime the ELB's cookie should follow."
  type        = string

  validation {
    condition     = length(var.cookie_name) > 0
    error_message = "resource_aws_app_cookie_stickiness_policy, cookie_name must not be empty."
  }
}