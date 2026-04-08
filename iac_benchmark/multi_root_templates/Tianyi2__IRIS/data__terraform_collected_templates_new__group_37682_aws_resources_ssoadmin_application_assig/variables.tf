variable "application_arn" {
  description = "ARN of the application"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso::", var.application_arn))
    error_message = "resource_aws_ssoadmin_application_assignment, application_arn must be a valid SSO application ARN starting with 'arn:aws:sso::'."
  }
}

variable "principal_id" {
  description = "An identifier for an object in IAM Identity Center, such as a user or group"
  type        = string

  validation {
    condition     = length(var.principal_id) > 0
    error_message = "resource_aws_ssoadmin_application_assignment, principal_id cannot be empty."
  }
}

variable "principal_type" {
  description = "Entity type for which the assignment will be created. Valid values are USER or GROUP"
  type        = string

  validation {
    condition     = contains(["USER", "GROUP"], var.principal_type)
    error_message = "resource_aws_ssoadmin_application_assignment, principal_type must be either 'USER' or 'GROUP'."
  }
}