variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "application_id" {
  description = "ID of the application."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{32}$", var.application_id))
    error_message = "resource_aws_pinpoint_sms_channel, application_id must be a valid 32-character hexadecimal application ID."
  }
}

variable "enabled" {
  description = "Whether the channel is enabled or disabled. By default, it is set to true."
  type        = bool
  default     = true

  validation {
    condition     = var.enabled == true || var.enabled == false
    error_message = "resource_aws_pinpoint_sms_channel, enabled must be a boolean value (true or false)."
  }
}

variable "sender_id" {
  description = "Identifier of the sender for your messages."
  type        = string
  default     = null

  validation {
    condition     = var.sender_id == null || can(regex("^[A-Za-z0-9]{1,11}$", var.sender_id))
    error_message = "resource_aws_pinpoint_sms_channel, sender_id must be 1-11 alphanumeric characters when specified."
  }
}

variable "short_code" {
  description = "Short Code registered with the phone provider."
  type        = string
  default     = null

  validation {
    condition     = var.short_code == null || can(regex("^[0-9]{3,8}$", var.short_code))
    error_message = "resource_aws_pinpoint_sms_channel, short_code must be 3-8 digits when specified."
  }
}