variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "email_identity" {
  description = "The verified email identity."
  type        = string

  validation {
    condition     = length(var.email_identity) > 0
    error_message = "resource_aws_sesv2_email_identity_mail_from_attributes, email_identity must not be empty."
  }
}

variable "behavior_on_mx_failure" {
  description = "The action to take if the required MX record isn't found when you send an email. Valid values: USE_DEFAULT_VALUE, REJECT_MESSAGE."
  type        = string
  default     = null

  validation {
    condition     = var.behavior_on_mx_failure == null || contains(["USE_DEFAULT_VALUE", "REJECT_MESSAGE"], var.behavior_on_mx_failure)
    error_message = "resource_aws_sesv2_email_identity_mail_from_attributes, behavior_on_mx_failure must be one of: USE_DEFAULT_VALUE, REJECT_MESSAGE."
  }
}

variable "mail_from_domain" {
  description = "The custom MAIL FROM domain that you want the verified identity to use. Required if behavior_on_mx_failure is REJECT_MESSAGE."
  type        = string
  default     = null

  validation {
    condition     = !(var.behavior_on_mx_failure == "REJECT_MESSAGE" && var.mail_from_domain == null)
    error_message = "resource_aws_sesv2_email_identity_mail_from_attributes, mail_from_domain is required when behavior_on_mx_failure is REJECT_MESSAGE."
  }
}