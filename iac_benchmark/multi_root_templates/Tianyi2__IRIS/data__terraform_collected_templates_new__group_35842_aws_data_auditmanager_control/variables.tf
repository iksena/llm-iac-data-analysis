variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_auditmanager_control, region must be a valid AWS region identifier."
  }
}

variable "name" {
  description = "Name of the control."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 300
    error_message = "data_auditmanager_control, name must be between 1 and 300 characters."
  }
}

variable "type" {
  description = "Type of control. Valid values are Custom and Standard."
  type        = string

  validation {
    condition     = contains(["Custom", "Standard"], var.type)
    error_message = "data_auditmanager_control, type must be either 'Custom' or 'Standard'."
  }
}