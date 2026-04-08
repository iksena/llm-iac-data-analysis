variable "alias" {
  description = "A unique and identifiable alias for the contact or escalation plan"
  type        = string

  validation {
    condition     = length(var.alias) >= 1 && length(var.alias) <= 255
    error_message = "resource_aws_ssmcontacts_contact, alias must be between 1 and 255 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.alias))
    error_message = "resource_aws_ssmcontacts_contact, alias may only contain alphanumerics, underscores (_), and hyphens (-)."
  }
}

variable "type" {
  description = "The type of contact engaged. A single contact is type PERSONAL and an escalation plan is type ESCALATION"
  type        = string

  validation {
    condition     = contains(["PERSONAL", "ESCALATION"], var.type)
    error_message = "resource_aws_ssmcontacts_contact, type must be either 'PERSONAL' or 'ESCALATION'."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "display_name" {
  description = "Full friendly name of the contact or escalation plan"
  type        = string
  default     = null

  validation {
    condition     = var.display_name == null || (length(var.display_name) >= 1 && length(var.display_name) <= 255)
    error_message = "resource_aws_ssmcontacts_contact, display_name must be between 1 and 255 characters when provided."
  }

  validation {
    condition     = var.display_name == null || can(regex("^[a-zA-Z0-9_\\-\\. ]+$", var.display_name))
    error_message = "resource_aws_ssmcontacts_contact, display_name may only contain alphanumerics, underscores (_), hyphens (-), periods (.), and spaces."
  }
}

variable "tags" {
  description = "Key-value tags for the contact"
  type        = map(string)
  default     = {}
}