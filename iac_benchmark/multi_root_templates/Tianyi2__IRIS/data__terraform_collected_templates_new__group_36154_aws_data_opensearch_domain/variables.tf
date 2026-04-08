variable "domain_name" {
  description = "Name of the domain"
  type        = string

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "data_aws_opensearch_domain, domain_name must be a non-empty string."
  }

  validation {
    condition     = length(var.domain_name) >= 3 && length(var.domain_name) <= 28
    error_message = "data_aws_opensearch_domain, domain_name must be between 3 and 28 characters long."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9\\-]*[a-z0-9]$", var.domain_name))
    error_message = "data_aws_opensearch_domain, domain_name must start and end with a lowercase letter or number, and can only contain lowercase letters, numbers, and hyphens."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9\\-]+$", var.region))
    error_message = "data_aws_opensearch_domain, region must be a valid AWS region format if specified."
  }
}