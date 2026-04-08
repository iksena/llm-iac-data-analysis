variable "domain" {
  type        = string
  description = "The domain name of the SES domain identity to verify."

  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?$", split(".", var.domain)[0])) && length(var.domain) <= 253
    error_message = "resource_aws_ses_domain_identity_verification, domain must be a valid domain name."
  }
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9\\-]+$", var.region))
    error_message = "resource_aws_ses_domain_identity_verification, region must be a valid AWS region identifier."
  }
}

variable "timeouts" {
  type = object({
    create = optional(string, "45m")
  })
  description = "Configuration options for resource timeouts."
  default = {
    create = "45m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_ses_domain_identity_verification, timeouts.create must be a valid timeout string (e.g., '45m', '1h', '30s')."
  }
}