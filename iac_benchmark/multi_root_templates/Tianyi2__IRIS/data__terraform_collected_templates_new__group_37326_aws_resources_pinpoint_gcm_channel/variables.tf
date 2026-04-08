variable "application_id" {
  description = "The application ID"
  type        = string

  validation {
    condition     = length(var.application_id) > 0
    error_message = "resource_aws_pinpoint_gcm_channel, application_id must not be empty."
  }
}

variable "api_key" {
  description = "Platform credential API key from Google"
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.api_key == null || length(var.api_key) > 0
    error_message = "resource_aws_pinpoint_gcm_channel, api_key must not be empty when provided."
  }
}

variable "default_authentication_method" {
  description = "Default authentication method. Valid values are TOKEN and KEY"
  type        = string
  default     = null

  validation {
    condition     = var.default_authentication_method == null || contains(["TOKEN", "KEY"], var.default_authentication_method)
    error_message = "resource_aws_pinpoint_gcm_channel, default_authentication_method must be either 'TOKEN' or 'KEY'."
  }
}

variable "service_json" {
  description = "Service Account JSON for TOKEN authentication method"
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.service_json == null || length(var.service_json) > 0
    error_message = "resource_aws_pinpoint_gcm_channel, service_json must not be empty when provided."
  }
}

variable "enabled" {
  description = "Whether the channel is enabled or disabled"
  type        = bool
  default     = true

  validation {
    condition     = var.enabled == true || var.enabled == false
    error_message = "resource_aws_pinpoint_gcm_channel, enabled must be a boolean value."
  }
}