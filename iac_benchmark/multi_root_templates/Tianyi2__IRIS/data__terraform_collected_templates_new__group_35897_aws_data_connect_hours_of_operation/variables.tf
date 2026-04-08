variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = var.instance_id != null && var.instance_id != ""
    error_message = "data_aws_connect_hours_of_operation, instance_id is required and cannot be empty."
  }
}

variable "hours_of_operation_id" {
  description = "Returns information on a specific Hours of Operation by hours of operation id"
  type        = string
  default     = null
}

variable "name" {
  description = "Returns information on a specific Hours of Operation by name"
  type        = string
  default     = null
}

# Validation to ensure either name or hours_of_operation_id is provided
locals {
  has_name_or_id = var.name != null || var.hours_of_operation_id != null
}

variable "validate_name_or_id" {
  description = "Internal validation variable - do not set"
  type        = bool
  default     = true

  validation {
    condition     = var.validate_name_or_id ? (var.name != null || var.hours_of_operation_id != null) : true
    error_message = "data_aws_connect_hours_of_operation, name or hours_of_operation_id must be provided - one of either name or hours_of_operation_id is required."
  }
}