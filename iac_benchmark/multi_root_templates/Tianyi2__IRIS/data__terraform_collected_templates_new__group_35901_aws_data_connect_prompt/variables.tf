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
    error_message = "data_aws_connect_prompt, instance_id must be a valid UUID format."
  }
}

variable "name" {
  description = "Returns information on a specific Prompt by name"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_connect_prompt, name cannot be empty."
  }
}