variable "name" {
  description = "The name of the SIP rule"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_chimesdkvoice_sip_rule, name must not be empty."
  }
}

variable "trigger_type" {
  description = "The type of trigger assigned to the SIP rule in trigger_value"
  type        = string

  validation {
    condition     = contains(["RequestUriHostname", "ToPhoneNumber"], var.trigger_type)
    error_message = "resource_aws_chimesdkvoice_sip_rule, trigger_type must be either 'RequestUriHostname' or 'ToPhoneNumber'."
  }
}

variable "trigger_value" {
  description = "If trigger_type is RequestUriHostname, the value can be the outbound host name of an Amazon Chime Voice Connector. If trigger_type is ToPhoneNumber, the value can be a customer-owned phone number in the E164 format"
  type        = string

  validation {
    condition     = length(var.trigger_value) > 0
    error_message = "resource_aws_chimesdkvoice_sip_rule, trigger_value must not be empty."
  }
}

variable "target_applications" {
  description = "List of SIP media applications with priority and AWS Region. Only one SIP application per AWS Region can be used"
  type = list(object({
    aws_region               = string
    priority                 = number
    sip_media_application_id = string
  }))

  validation {
    condition     = length(var.target_applications) > 0
    error_message = "resource_aws_chimesdkvoice_sip_rule, target_applications must contain at least one application."
  }

  validation {
    condition = alltrue([
      for app in var.target_applications : length(app.aws_region) > 0
    ])
    error_message = "resource_aws_chimesdkvoice_sip_rule, target_applications aws_region must not be empty."
  }

  validation {
    condition = alltrue([
      for app in var.target_applications : app.priority >= 1
    ])
    error_message = "resource_aws_chimesdkvoice_sip_rule, target_applications priority must be >= 1."
  }

  validation {
    condition = alltrue([
      for app in var.target_applications : length(app.sip_media_application_id) > 0
    ])
    error_message = "resource_aws_chimesdkvoice_sip_rule, target_applications sip_media_application_id must not be empty."
  }
}

variable "disabled" {
  description = "Enables or disables a rule. You must disable rules before you can delete them"
  type        = bool
  default     = null
}