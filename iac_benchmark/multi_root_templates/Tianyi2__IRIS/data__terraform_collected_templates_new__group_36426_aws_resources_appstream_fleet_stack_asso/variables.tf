variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "fleet_name" {
  description = "Name of the fleet."
  type        = string

  validation {
    condition     = length(var.fleet_name) > 0
    error_message = "resource_aws_appstream_fleet_stack_association, fleet_name must be a non-empty string."
  }
}

variable "stack_name" {
  description = "Name of the stack."
  type        = string

  validation {
    condition     = length(var.stack_name) > 0
    error_message = "resource_aws_appstream_fleet_stack_association, stack_name must be a non-empty string."
  }
}