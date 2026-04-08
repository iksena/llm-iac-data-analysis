variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_sesv2_email_identity_feedback_attributes, region must be a valid AWS region format."
  }
}

variable "email_identity" {
  description = "The email identity."
  type        = string

  validation {
    condition     = length(var.email_identity) > 0
    error_message = "resource_aws_sesv2_email_identity_feedback_attributes, email_identity cannot be empty."
  }
}

variable "email_forwarding_enabled" {
  description = "Sets the feedback forwarding configuration for the identity."
  type        = bool
  default     = null

  validation {
    condition     = var.email_forwarding_enabled == null || can(tobool(var.email_forwarding_enabled))
    error_message = "resource_aws_sesv2_email_identity_feedback_attributes, email_forwarding_enabled must be a boolean value."
  }
}