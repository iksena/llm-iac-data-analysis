variable "email" {
  description = "Email identity to retrieve"
  type        = string

  validation {
    condition     = can(regex("^[^@]+@[^@]+\\.[^@]+$", var.email))
    error_message = "data_aws_ses_email_identity, email must be a valid email address format."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ses_email_identity, region must be a valid AWS region format or null."
  }
}