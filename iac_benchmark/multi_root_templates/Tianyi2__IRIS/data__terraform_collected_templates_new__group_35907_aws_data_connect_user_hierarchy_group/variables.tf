variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "hierarchy_group_id" {
  description = "Returns information on a specific hierarchy group by hierarchy group id"
  type        = string
  default     = null

  validation {
    condition     = var.hierarchy_group_id == null || can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.hierarchy_group_id))
    error_message = "data_aws_connect_user_hierarchy_group, hierarchy_group_id must be a valid UUID format."
  }
}

variable "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "data_aws_connect_user_hierarchy_group, instance_id must be a valid UUID format."
  }
}

variable "name" {
  description = "Returns information on a specific hierarchy group by name"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "data_aws_connect_user_hierarchy_group, name cannot be empty string."
  }
}

locals {
  has_name               = var.name != null
  has_hierarchy_group_id = var.hierarchy_group_id != null
}

variable "validation_check" {
  description = "Internal validation to ensure either name or hierarchy_group_id is provided"
  type        = bool
  default     = true

  validation {
    condition     = var.validation_check == true && (local.has_name || local.has_hierarchy_group_id)
    error_message = "data_aws_connect_user_hierarchy_group, either name or hierarchy_group_id must be provided."
  }
}