variable "email_identity" {
  description = "The name of the email identity"
  type        = string

  validation {
    condition     = length(var.email_identity) > 0
    error_message = "data_aws_sesv2_email_identity, email_identity must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_sesv2_email_identity, region must be a valid AWS region format when specified."
  }
}