variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "voice_connector_id" {
  description = "The Amazon Chime Voice Connector ID."
  type        = string

  validation {
    condition     = length(var.voice_connector_id) > 0
    error_message = "resource_aws_chime_voice_connector_termination, voice_connector_id must not be empty."
  }
}

variable "cidr_allow_list" {
  description = "The IP addresses allowed to make calls, in CIDR format."
  type        = list(string)

  validation {
    condition     = length(var.cidr_allow_list) > 0
    error_message = "resource_aws_chime_voice_connector_termination, cidr_allow_list must contain at least one CIDR block."
  }

  validation {
    condition = alltrue([
      for cidr in var.cidr_allow_list : can(cidrhost(cidr, 0))
    ])
    error_message = "resource_aws_chime_voice_connector_termination, cidr_allow_list must contain valid CIDR blocks."
  }
}

variable "calling_regions" {
  description = "The countries to which calls are allowed, in ISO 3166-1 alpha-2 format."
  type        = list(string)

  validation {
    condition     = length(var.calling_regions) > 0
    error_message = "resource_aws_chime_voice_connector_termination, calling_regions must contain at least one country code."
  }

  validation {
    condition = alltrue([
      for region in var.calling_regions : length(region) == 2
    ])
    error_message = "resource_aws_chime_voice_connector_termination, calling_regions must contain valid ISO 3166-1 alpha-2 country codes (2 characters each)."
  }
}

variable "disabled" {
  description = "When termination settings are disabled, outbound calls can not be made."
  type        = bool
  default     = null
}

variable "default_phone_number" {
  description = "The default caller ID phone number."
  type        = string
  default     = null
}

variable "cps_limit" {
  description = "The limit on calls per second. Max value based on account service quota. Default value of 1."
  type        = number
  default     = 1

  validation {
    condition     = var.cps_limit > 0
    error_message = "resource_aws_chime_voice_connector_termination, cps_limit must be greater than 0."
  }
}