variable "application_arn" {
  description = "ARN of the application."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso::", var.application_arn))
    error_message = "data_aws_ssoadmin_application, application_arn must be a valid SSO application ARN starting with 'arn:aws:sso::'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ssoadmin_application, region must be a valid AWS region format or null."
  }
}