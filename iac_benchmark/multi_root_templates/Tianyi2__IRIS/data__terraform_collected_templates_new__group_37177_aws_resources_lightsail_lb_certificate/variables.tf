variable "domain_name" {
  description = "Domain name (e.g., example.com) for your SSL/TLS certificate."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.[a-z]{2,}$", var.domain_name))
    error_message = "resource_aws_lightsail_lb_certificate, domain_name must be a valid domain name."
  }
}

variable "lb_name" {
  description = "Load balancer name where you want to create the SSL/TLS certificate."
  type        = string

  validation {
    condition     = length(var.lb_name) > 0 && length(var.lb_name) <= 255
    error_message = "resource_aws_lightsail_lb_certificate, lb_name must be between 1 and 255 characters in length."
  }
}

variable "name" {
  description = "SSL/TLS certificate name."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "resource_aws_lightsail_lb_certificate, name must be between 1 and 255 characters in length."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "subject_alternative_names" {
  description = "Set of domains that should be SANs in the issued certificate. domain_name attribute is automatically added as a Subject Alternative Name."
  type        = set(string)
  default     = null

  validation {
    condition = var.subject_alternative_names == null || alltrue([
      for san in var.subject_alternative_names : can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.[a-z]{2,}$", san))
    ])
    error_message = "resource_aws_lightsail_lb_certificate, subject_alternative_names must contain valid domain names."
  }
}