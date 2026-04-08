variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "voice_connector_id" {
  description = "The Amazon Chime Voice Connector ID."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.voice_connector_id)) && length(var.voice_connector_id) > 0
    error_message = "resource_aws_chime_voice_connector_origination, voice_connector_id must be a non-empty string containing only alphanumeric characters."
  }
}

variable "routes" {
  description = "Set of call distribution properties defined for your SIP hosts. Minimum of 1. Maximum of 20."
  type = list(object({
    host     = string
    port     = number
    priority = number
    protocol = string
    weight   = number
  }))

  validation {
    condition     = length(var.routes) >= 1 && length(var.routes) <= 20
    error_message = "resource_aws_chime_voice_connector_origination, routes must contain between 1 and 20 items."
  }

  validation {
    condition = alltrue([
      for route in var.routes :
      can(regex("^[a-zA-Z0-9.-]+$", route.host)) && length(route.host) > 0
    ])
    error_message = "resource_aws_chime_voice_connector_origination, routes each route host must be a valid FQDN or IP address."
  }

  validation {
    condition = alltrue([
      for route in var.routes :
      route.port >= 1 && route.port <= 65535
    ])
    error_message = "resource_aws_chime_voice_connector_origination, routes each route port must be between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for route in var.routes :
      route.priority >= 1
    ])
    error_message = "resource_aws_chime_voice_connector_origination, routes each route priority must be 1 or higher, with 1 being the highest priority."
  }

  validation {
    condition = alltrue([
      for route in var.routes :
      contains(["TCP", "UDP"], upper(route.protocol))
    ])
    error_message = "resource_aws_chime_voice_connector_origination, routes each route protocol must be either TCP or UDP."
  }

  validation {
    condition = alltrue([
      for route in var.routes :
      route.weight >= 1
    ])
    error_message = "resource_aws_chime_voice_connector_origination, routes each route weight must be 1 or higher."
  }
}

variable "disabled" {
  description = "When origination settings are disabled, inbound calls are not enabled for your Amazon Chime Voice Connector."
  type        = bool
  default     = false
}