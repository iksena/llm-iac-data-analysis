variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "voice_connector_id" {
  description = "Amazon Chime Voice Connector ID."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.voice_connector_id)) && length(var.voice_connector_id) > 0
    error_message = "resource_aws_chime_voice_connector_termination_credentials, voice_connector_id must be a non-empty alphanumeric string."
  }
}

variable "credentials" {
  description = "List of termination SIP credentials."
  type = list(object({
    username = string
    password = string
  }))

  validation {
    condition     = length(var.credentials) > 0
    error_message = "resource_aws_chime_voice_connector_termination_credentials, credentials must contain at least one credential object."
  }

  validation {
    condition = alltrue([
      for cred in var.credentials : length(cred.username) > 0
    ])
    error_message = "resource_aws_chime_voice_connector_termination_credentials, credentials username must be a non-empty RFC2617 compliant string."
  }

  validation {
    condition = alltrue([
      for cred in var.credentials : length(cred.password) > 0
    ])
    error_message = "resource_aws_chime_voice_connector_termination_credentials, credentials password must be a non-empty RFC2617 compliant string."
  }
}