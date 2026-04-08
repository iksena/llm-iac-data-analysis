variable "application_id" {
  description = "The application ID"
  type        = string

  validation {
    condition     = length(var.application_id) > 0
    error_message = "resource_aws_pinpoint_adm_channel, application_id must not be empty."
  }
}

variable "client_id" {
  description = "Client ID (part of OAuth Credentials) obtained via Amazon Developer Account"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.client_id) > 0
    error_message = "resource_aws_pinpoint_adm_channel, client_id must not be empty."
  }
}

variable "client_secret" {
  description = "Client Secret (part of OAuth Credentials) obtained via Amazon Developer Account"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.client_secret) > 0
    error_message = "resource_aws_pinpoint_adm_channel, client_secret must not be empty."
  }
}

variable "enabled" {
  description = "Specifies whether to enable the channel"
  type        = bool
  default     = true

  validation {
    condition     = can(var.enabled)
    error_message = "resource_aws_pinpoint_adm_channel, enabled must be a boolean value."
  }
}