variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "amazon_code_guru_profiler_status" {
  description = "Status of the CodeGuru Profiler integration. Valid values are ENABLED and DISABLED."
  type        = string

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.amazon_code_guru_profiler_status)
    error_message = "resource_aws_devopsguru_event_sources_config, amazon_code_guru_profiler_status must be either 'ENABLED' or 'DISABLED'."
  }
}