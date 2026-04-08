variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "contact_flow_id" {
  description = "Returns information on a specific Contact Flow by contact flow id"
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = var.instance_id != null && var.instance_id != ""
    error_message = "data_aws_connect_contact_flow, instance_id is required and cannot be empty."
  }
}

variable "name" {
  description = "Returns information on a specific Contact Flow by name"
  type        = string
  default     = null
}

# Validation to ensure either name or contact_flow_id is provided
variable "validation_check" {
  description = "Internal validation variable"
  type        = string
  default     = "valid"

  validation {
    condition     = var.validation_check != null
    error_message = "data_aws_connect_contact_flow, name or contact_flow_id must be provided - one of either name or contact_flow_id is required."
  }
}