variable "domain" {
  description = "Name of the domain"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-._]*[a-zA-Z0-9]$", var.domain))
    error_message = "data_aws_ses_domain_identity, domain must be a valid domain name."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ses_domain_identity, region must be a valid AWS region."
  }
}