variable "workgroup_name" {
  description = "Name of the workgroup."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.workgroup_name))
    error_message = "resource_aws_redshiftserverless_custom_domain_association, workgroup_name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "custom_domain_name" {
  description = "Custom domain to associate with the workgroup."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+$", var.custom_domain_name))
    error_message = "resource_aws_redshiftserverless_custom_domain_association, custom_domain_name must be a valid domain name."
  }
}

variable "custom_domain_certificate_arn" {
  description = "ARN of the certificate for the custom domain association."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm:[a-z0-9-]+:[0-9]{12}:certificate/[a-f0-9-]+$", var.custom_domain_certificate_arn))
    error_message = "resource_aws_redshiftserverless_custom_domain_association, custom_domain_certificate_arn must be a valid ACM certificate ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_redshiftserverless_custom_domain_association, region must be a valid AWS region identifier."
  }
}