variable "name" {
  description = "Name of the event bus"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_cloudwatch_event_bus, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_cloudwatch_event_bus, region must be a valid AWS region format (e.g., us-east-1)."
  }
}