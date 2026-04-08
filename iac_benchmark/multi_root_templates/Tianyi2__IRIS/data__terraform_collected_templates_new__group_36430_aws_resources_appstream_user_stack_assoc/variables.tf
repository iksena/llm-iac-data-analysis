variable "authentication_type" {
  description = "Authentication type for the user"
  type        = string

  validation {
    condition     = contains(["USERPOOL", "SAML", "API"], var.authentication_type)
    error_message = "resource_aws_appstream_user_stack_association, authentication_type must be one of: USERPOOL, SAML, API."
  }
}

variable "stack_name" {
  description = "Name of the stack that is associated with the user"
  type        = string

  validation {
    condition     = length(var.stack_name) > 0
    error_message = "resource_aws_appstream_user_stack_association, stack_name cannot be empty."
  }
}

variable "user_name" {
  description = "Email address of the user who is associated with the stack"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.user_name))
    error_message = "resource_aws_appstream_user_stack_association, user_name must be a valid email address."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$|^[a-z]{2}-[a-z]+-[0-9][a-z]$", var.region))
    error_message = "resource_aws_appstream_user_stack_association, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "send_email_notification" {
  description = "Whether a welcome email is sent to a user after the user is created in the user pool"
  type        = bool
  default     = null
}