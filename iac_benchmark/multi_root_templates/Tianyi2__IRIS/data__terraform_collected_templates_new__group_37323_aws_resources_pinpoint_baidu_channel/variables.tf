variable "application_id" {
  description = "The application ID"
  type        = string

  validation {
    condition     = length(var.application_id) > 0
    error_message = "resource_aws_pinpoint_baidu_channel, application_id must not be empty."
  }
}

variable "api_key" {
  description = "Platform credential API key from Baidu"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.api_key) > 0
    error_message = "resource_aws_pinpoint_baidu_channel, api_key must not be empty."
  }
}

variable "secret_key" {
  description = "Platform credential Secret key from Baidu"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.secret_key) > 0
    error_message = "resource_aws_pinpoint_baidu_channel, secret_key must not be empty."
  }
}

variable "enabled" {
  description = "Specifies whether to enable the channel"
  type        = bool
  default     = true
}