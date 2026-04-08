variable "instance_name" {
  description = "Name of the instance to attach to the load balancer."
  type        = string

  validation {
    condition     = length(var.instance_name) > 0
    error_message = "resource_aws_lightsail_lb_attachment, instance_name must not be empty."
  }
}

variable "lb_name" {
  description = "Name of the Lightsail load balancer."
  type        = string

  validation {
    condition     = length(var.lb_name) > 0
    error_message = "resource_aws_lightsail_lb_attachment, lb_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}