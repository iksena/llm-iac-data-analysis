variable "account_id" {
  description = "ID of the target account when managing member accounts. Will manage current user's account by default if omitted."
  type        = string
  default     = null
}

variable "alternate_contact_type" {
  description = "Type of the alternate contact. Allowed values are: BILLING, OPERATIONS, SECURITY."
  type        = string

  validation {
    condition     = contains(["BILLING", "OPERATIONS", "SECURITY"], var.alternate_contact_type)
    error_message = "resource_aws_account_alternate_contact, alternate_contact_type must be one of: BILLING, OPERATIONS, SECURITY."
  }
}

variable "email_address" {
  description = "An email address for the alternate contact."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email_address))
    error_message = "resource_aws_account_alternate_contact, email_address must be a valid email address."
  }
}

variable "name" {
  description = "Name of the alternate contact."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_account_alternate_contact, name cannot be empty."
  }
}

variable "phone_number" {
  description = "Phone number for the alternate contact."
  type        = string

  validation {
    condition     = length(var.phone_number) > 0
    error_message = "resource_aws_account_alternate_contact, phone_number cannot be empty."
  }
}

variable "title" {
  description = "Title for the alternate contact."
  type        = string

  validation {
    condition     = length(var.title) > 0
    error_message = "resource_aws_account_alternate_contact, title cannot be empty."
  }
}

variable "timeouts" {
  description = "Timeout configuration for the resource operations."
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = {}
}