variable "name" {
  description = "Name of the Event Integration"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_appintegrations_event_integration, name must not be empty."
  }
}

variable "description" {
  description = "Description of the Event Integration"
  type        = string
  default     = null
}

variable "eventbridge_bus" {
  description = "EventBridge bus"
  type        = string

  validation {
    condition     = length(var.eventbridge_bus) > 0
    error_message = "resource_aws_appintegrations_event_integration, eventbridge_bus must not be empty."
  }
}

variable "event_filter_source" {
  description = "Source of the events"
  type        = string

  validation {
    condition     = length(var.event_filter_source) > 0
    error_message = "resource_aws_appintegrations_event_integration, event_filter_source must not be empty."
  }
}

variable "tags" {
  description = "Tags to apply to the Event Integration"
  type        = map(string)
  default     = {}
}