variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the slot type. The name is case sensitive."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_]+$", var.name))
    error_message = "data_aws_lex_slot_type, name must contain only alphanumeric characters and underscores."
  }

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 100
    error_message = "data_aws_lex_slot_type, name must be between 1 and 100 characters."
  }
}

variable "slot_version" {
  description = "Version of the slot type"
  type        = string
  default     = null

  validation {
    condition     = var.slot_version == null || can(regex("^[0-9]+$|^\\$LATEST$", var.slot_version))
    error_message = "data_aws_lex_slot_type, slot_version must be either a numeric version or $LATEST."
  }
}