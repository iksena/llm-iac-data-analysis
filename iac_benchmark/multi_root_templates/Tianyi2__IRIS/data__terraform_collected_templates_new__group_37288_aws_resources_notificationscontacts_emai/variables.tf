variable "email_address" {
  type        = string
  description = "Email address for the contact. Must be between 6 and 254 characters and match an email pattern."

  validation {
    condition     = length(var.email_address) >= 6 && length(var.email_address) <= 254
    error_message = "resource_aws_notificationscontacts_email_contact, email_address must be between 6 and 254 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email_address))
    error_message = "resource_aws_notificationscontacts_email_contact, email_address must match a valid email pattern."
  }
}

variable "name" {
  type        = string
  description = "Name of the email contact. Must be between 1 and 64 characters and can contain alphanumeric characters, underscores, tildes, periods, and hyphens."

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "resource_aws_notificationscontacts_email_contact, name must be between 1 and 64 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._~-]+$", var.name))
    error_message = "resource_aws_notificationscontacts_email_contact, name can only contain alphanumeric characters, underscores, tildes, periods, and hyphens."
  }
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to assign to the resource."
  default     = {}
}