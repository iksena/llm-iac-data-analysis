variable "email_identity" {
  description = "The email address or domain to verify"
  type        = string

  validation {
    condition     = length(var.email_identity) > 0
    error_message = "resource_aws_sesv2_email_identity, email_identity must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "configuration_set_name" {
  description = "The configuration set to use by default when sending from this identity. Note that any configuration set defined in the email sending request takes precedence"
  type        = string
  default     = null
}

variable "dkim_signing_attributes" {
  description = "The configuration of the DKIM authentication settings for an email domain identity"
  type = object({
    domain_signing_private_key = optional(string)
    domain_signing_selector    = optional(string)
    next_signing_key_length    = optional(string)
  })
  default = null

  validation {
    condition = var.dkim_signing_attributes == null || (
      var.dkim_signing_attributes.next_signing_key_length == null ||
      contains(["RSA_1024_BIT", "RSA_2048_BIT"], var.dkim_signing_attributes.next_signing_key_length)
    )
    error_message = "resource_aws_sesv2_email_identity, next_signing_key_length must be either 'RSA_1024_BIT' or 'RSA_2048_BIT'."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}
}