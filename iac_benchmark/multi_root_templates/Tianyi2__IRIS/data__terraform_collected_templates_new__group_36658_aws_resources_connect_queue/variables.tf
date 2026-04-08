variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Specifies the description of the Queue."
  type        = string
  default     = null
}

variable "hours_of_operation_id" {
  description = "Specifies the identifier of the Hours of Operation."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.hours_of_operation_id))
    error_message = "resource_aws_connect_queue, hours_of_operation_id must be a valid UUID format."
  }
}

variable "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.instance_id))
    error_message = "resource_aws_connect_queue, instance_id must be a valid UUID format."
  }
}

variable "max_contacts" {
  description = "Specifies the maximum number of contacts that can be in the queue before it is considered full. Minimum value of 0."
  type        = number
  default     = null

  validation {
    condition     = var.max_contacts == null || var.max_contacts >= 0
    error_message = "resource_aws_connect_queue, max_contacts must be greater than or equal to 0."
  }
}

variable "name" {
  description = "Specifies the name of the Queue."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 127
    error_message = "resource_aws_connect_queue, name must be between 1 and 127 characters."
  }
}

variable "outbound_caller_config" {
  description = "A block that defines the outbound caller ID name, number, and outbound whisper flow."
  type = object({
    outbound_caller_id_name      = optional(string)
    outbound_caller_id_number_id = optional(string)
    outbound_flow_id             = optional(string)
  })
  default = null

  validation {
    condition = var.outbound_caller_config == null || (
      var.outbound_caller_config.outbound_caller_id_number_id == null ||
      can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.outbound_caller_config.outbound_caller_id_number_id))
    )
    error_message = "resource_aws_connect_queue, outbound_caller_id_number_id must be a valid UUID format when provided."
  }

  validation {
    condition = var.outbound_caller_config == null || (
      var.outbound_caller_config.outbound_flow_id == null ||
      can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.outbound_caller_config.outbound_flow_id))
    )
    error_message = "resource_aws_connect_queue, outbound_flow_id must be a valid UUID format when provided."
  }
}

variable "quick_connect_ids" {
  description = "Specifies a list of quick connects ids that determine the quick connects available to agents who are working the queue."
  type        = list(string)
  default     = null

  validation {
    condition = var.quick_connect_ids == null || alltrue([
      for id in var.quick_connect_ids : can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", id))
    ])
    error_message = "resource_aws_connect_queue, quick_connect_ids must contain valid UUID format entries."
  }
}

variable "status" {
  description = "Specifies the description of the Queue. Valid values are ENABLED, DISABLED."
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.status)
    error_message = "resource_aws_connect_queue, status must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "tags" {
  description = "Tags to apply to the Queue."
  type        = map(string)
  default     = {}
}