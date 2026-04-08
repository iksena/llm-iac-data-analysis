variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the framework."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_auditmanager_framework, name must not be empty."
  }
}

variable "type" {
  description = "Type of framework. Valid values are Custom and Standard."
  type        = string

  validation {
    condition     = contains(["Custom", "Standard"], var.type)
    error_message = "data_aws_auditmanager_framework, type must be either 'Custom' or 'Standard'."
  }
}