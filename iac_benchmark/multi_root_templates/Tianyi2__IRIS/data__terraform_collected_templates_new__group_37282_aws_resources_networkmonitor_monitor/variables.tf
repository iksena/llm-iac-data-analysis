variable "monitor_name" {
  description = "The name of the monitor."
  type        = string

  validation {
    condition     = length(var.monitor_name) > 0
    error_message = "resource_aws_networkmonitor_monitor, monitor_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "aggregation_period" {
  description = "The time, in seconds, that metrics are aggregated and sent to Amazon CloudWatch. Valid values are either 30 or 60."
  type        = number
  default     = null

  validation {
    condition     = var.aggregation_period == null || contains([30, 60], var.aggregation_period)
    error_message = "resource_aws_networkmonitor_monitor, aggregation_period must be either 30 or 60."
  }
}

variable "tags" {
  description = "Key-value tags for the monitor."
  type        = map(string)
  default     = {}
}