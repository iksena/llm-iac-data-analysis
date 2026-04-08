variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_ssoadmin_application_assignment_configuration, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}

variable "application_arn" {
  description = "ARN of the application."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso::", var.application_arn))
    error_message = "resource_aws_ssoadmin_application_assignment_configuration, application_arn must be a valid SSO application ARN starting with 'arn:aws:sso::'."
  }
}

variable "assignment_required" {
  description = "Indicates whether users must have an explicit assignment to access the application. If false, all users have access to the application."
  type        = bool

  validation {
    condition     = can(tobool(var.assignment_required))
    error_message = "resource_aws_ssoadmin_application_assignment_configuration, assignment_required must be a boolean value (true or false)."
  }
}