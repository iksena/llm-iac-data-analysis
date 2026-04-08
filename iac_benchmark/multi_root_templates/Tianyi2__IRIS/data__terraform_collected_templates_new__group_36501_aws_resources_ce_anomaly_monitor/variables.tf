variable "name" {
  description = "The name of the monitor."
  type        = string
}

variable "monitor_type" {
  description = "The possible type values."
  type        = string
  validation {
    condition     = contains(["DIMENSIONAL", "CUSTOM"], var.monitor_type)
    error_message = "resource_aws_ce_anomaly_monitor, monitor_type must be either 'DIMENSIONAL' or 'CUSTOM'."
  }
}

variable "monitor_dimension" {
  description = "The dimensions to evaluate. Required if monitor_type is DIMENSIONAL."
  type        = string
  default     = null
  validation {
    condition     = var.monitor_dimension == null || contains(["SERVICE"], var.monitor_dimension)
    error_message = "resource_aws_ce_anomaly_monitor, monitor_dimension must be 'SERVICE' when specified."
  }
}

variable "monitor_specification" {
  description = "A valid JSON representation for the Expression object. Required if monitor_type is CUSTOM."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}