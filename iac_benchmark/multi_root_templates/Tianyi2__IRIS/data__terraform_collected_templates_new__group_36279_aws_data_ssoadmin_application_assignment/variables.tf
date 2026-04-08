variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ssoadmin_application_assignments, region must be a valid AWS region identifier."
  }
}

variable "application_arn" {
  description = "ARN of the application."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso::[0-9]{12}:application/[a-zA-Z0-9-_/]+$", var.application_arn))
    error_message = "data_aws_ssoadmin_application_assignments, application_arn must be a valid SSO Admin application ARN."
  }
}