variable "domain" {
  description = "Verified domain name or email identity to generate DKIM tokens for"
  type        = string

  validation {
    condition     = length(var.domain) > 0
    error_message = "resource_aws_ses_domain_mail_from, domain must be a non-empty string."
  }
}

variable "mail_from_domain" {
  description = "Subdomain (of above domain) which is to be used as MAIL FROM address (Required for DMARC validation)"
  type        = string

  validation {
    condition     = length(var.mail_from_domain) > 0
    error_message = "resource_aws_ses_domain_mail_from, mail_from_domain must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "behavior_on_mx_failure" {
  description = "The action that you want Amazon SES to take if it cannot successfully read the required MX record when you send an email. Defaults to UseDefaultValue"
  type        = string
  default     = "UseDefaultValue"

  validation {
    condition     = contains(["UseDefaultValue", "RejectMessage"], var.behavior_on_mx_failure)
    error_message = "resource_aws_ses_domain_mail_from, behavior_on_mx_failure must be either 'UseDefaultValue' or 'RejectMessage'."
  }
}