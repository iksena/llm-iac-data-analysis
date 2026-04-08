variable "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.instance_id))
    error_message = "data_aws_connect_queue, instance_id must be a valid UUID format."
  }
}

variable "queue_id" {
  description = "Returns information on a specific Queue by Queue id"
  type        = string
  default     = null

  validation {
    condition     = var.queue_id == null || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.queue_id))
    error_message = "data_aws_connect_queue, queue_id must be a valid UUID format when specified."
  }
}

variable "name" {
  description = "Returns information on a specific Queue by name"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "data_aws_connect_queue, name must not be empty when specified."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_connect_queue, region must be a valid AWS region format when specified."
  }
}

locals {
  has_queue_id_or_name = var.queue_id != null || var.name != null
}

variable "validation_check" {
  description = "Internal validation to ensure either queue_id or name is provided"
  type        = bool
  default     = true

  validation {
    condition     = var.validation_check == true && (var.queue_id != null || var.name != null)
    error_message = "data_aws_connect_queue, either queue_id or name must be specified."
  }
}