variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the Amazon Chime Voice Connector group."
  type        = string

  validation {
    condition     = can(regex("^.+$", var.name))
    error_message = "resource_aws_chime_voice_connector_group, name must be a non-empty string."
  }
}

variable "connector" {
  description = "The Amazon Chime Voice Connectors to route inbound calls to. Limit: 3 VoiceConnectorItems per Amazon Chime Voice Connector group."
  type = list(object({
    voice_connector_id = string
    priority           = number
  }))
  default = []

  validation {
    condition     = length(var.connector) <= 3
    error_message = "resource_aws_chime_voice_connector_group, connector list cannot exceed 3 items."
  }

  validation {
    condition = alltrue([
      for conn in var.connector : can(regex("^.+$", conn.voice_connector_id))
    ])
    error_message = "resource_aws_chime_voice_connector_group, connector voice_connector_id must be a non-empty string."
  }

  validation {
    condition = alltrue([
      for conn in var.connector : conn.priority > 0 && floor(conn.priority) == conn.priority
    ])
    error_message = "resource_aws_chime_voice_connector_group, connector priority must be a positive integer."
  }
}