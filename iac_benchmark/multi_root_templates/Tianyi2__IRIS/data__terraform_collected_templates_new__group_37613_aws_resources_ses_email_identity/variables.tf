variable "email" {
  type        = string
  description = "The email address to assign to SES"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email))
    error_message = "resource_aws_ses_email_identity, email must be a valid email address format."
  }
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_ses_email_identity, region must be a valid AWS region format or null."
  }
}