variable "domain" {
  description = "Verified domain name to generate DKIM tokens for"
  type        = string

  validation {
    condition     = length(var.domain) > 0
    error_message = "resource_aws_ses_domain_dkim, domain must not be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?\\.[a-zA-Z]{2,}$", var.domain))
    error_message = "resource_aws_ses_domain_dkim, domain must be a valid domain name format."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z0-9\\-]+$", var.region))
    error_message = "resource_aws_ses_domain_dkim, region must be a valid AWS region format when specified."
  }
}