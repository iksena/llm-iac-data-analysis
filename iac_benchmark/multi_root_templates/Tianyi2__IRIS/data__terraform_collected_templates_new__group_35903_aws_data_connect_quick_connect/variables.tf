variable "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.instance_id))
    error_message = "data_aws_connect_quick_connect, instance_id must be a valid UUID format."
  }
}

variable "name" {
  description = "Returns information on a specific Quick Connect by name"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "data_aws_connect_quick_connect, name must not be empty when provided."
  }
}

variable "quick_connect_id" {
  description = "Returns information on a specific Quick Connect by Quick Connect id"
  type        = string
  default     = null

  validation {
    condition     = var.quick_connect_id == null || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.quick_connect_id))
    error_message = "data_aws_connect_quick_connect, quick_connect_id must be a valid UUID format when provided."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_connect_quick_connect, region must be a valid AWS region format when provided."
  }
}

