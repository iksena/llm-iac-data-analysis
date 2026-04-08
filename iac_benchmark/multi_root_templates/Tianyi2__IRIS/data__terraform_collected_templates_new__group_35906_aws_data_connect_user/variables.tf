variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "data_aws_connect_user, instance_id must be a valid UUID format."
  }
}

variable "name" {
  description = "Returns information on a specific User by name"
  type        = string
  default     = null

}

variable "user_id" {
  description = "Returns information on a specific User by User id"
  type        = string
  default     = null


  validation {
    condition     = var.user_id == null || can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.user_id))
    error_message = "data_aws_connect_user, user_id must be a valid UUID format when specified."
  }
}

# Validation to ensure either name or user_id is provided
locals {
  has_identifier = var.name != null || var.user_id != null
}

variable "_validate_required_args" {
  description = "Internal validation variable"
  type        = bool
  default     = true

  validation {
    condition     = var._validate_required_args == true && local.has_identifier
    error_message = "data_aws_connect_user, instance_id and one of either name or user_id is required."
  }
}