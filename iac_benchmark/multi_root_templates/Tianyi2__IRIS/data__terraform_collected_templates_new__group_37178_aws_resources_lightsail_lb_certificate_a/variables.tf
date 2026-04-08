variable "certificate_name" {
  description = "Name of your SSL/TLS certificate."
  type        = string

  validation {
    condition     = length(var.certificate_name) > 0
    error_message = "resource_aws_lightsail_lb_certificate_attachment, certificate_name must not be empty."
  }
}

variable "lb_name" {
  description = "Name of the load balancer to which you want to associate the SSL/TLS certificate."
  type        = string

  validation {
    condition     = length(var.lb_name) > 0
    error_message = "resource_aws_lightsail_lb_certificate_attachment, lb_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}