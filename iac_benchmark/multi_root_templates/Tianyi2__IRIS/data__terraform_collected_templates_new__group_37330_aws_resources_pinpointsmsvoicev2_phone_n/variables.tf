variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "deletion_protection_enabled" {
  description = "When set to true the phone number can't be deleted"
  type        = bool
  default     = false
}

variable "iso_country_code" {
  description = "The two-character code, in ISO 3166-1 alpha-2 format, for the country or region"
  type        = string

  validation {
    condition     = length(var.iso_country_code) == 2
    error_message = "resource_aws_pinpointsmsvoicev2_phone_number, iso_country_code must be exactly 2 characters in ISO 3166-1 alpha-2 format."
  }
}

variable "message_type" {
  description = "The type of message. Valid values are TRANSACTIONAL for messages that are critical or time-sensitive and PROMOTIONAL for messages that aren't critical or time-sensitive"
  type        = string

  validation {
    condition     = contains(["TRANSACTIONAL", "PROMOTIONAL"], var.message_type)
    error_message = "resource_aws_pinpointsmsvoicev2_phone_number, message_type must be either TRANSACTIONAL or PROMOTIONAL."
  }
}

variable "number_capabilities" {
  description = "Describes if the origination identity can be used for text messages, voice calls or both. Valid values are SMS and VOICE"
  type        = list(string)

  validation {
    condition     = length(var.number_capabilities) > 0 && alltrue([for cap in var.number_capabilities : contains(["SMS", "VOICE"], cap)])
    error_message = "resource_aws_pinpointsmsvoicev2_phone_number, number_capabilities must contain at least one value and all values must be either SMS or VOICE."
  }
}

variable "number_type" {
  description = "The type of phone number to request. Possible values are LONG_CODE, TOLL_FREE, TEN_DLC, or SIMULATOR"
  type        = string

  validation {
    condition     = contains(["LONG_CODE", "TOLL_FREE", "TEN_DLC", "SIMULATOR"], var.number_type)
    error_message = "resource_aws_pinpointsmsvoicev2_phone_number, number_type must be one of LONG_CODE, TOLL_FREE, TEN_DLC, or SIMULATOR."
  }
}

variable "opt_out_list_name" {
  description = "The name of the opt-out list to associate with the phone number"
  type        = string
  default     = null
}

variable "registration_id" {
  description = "Use this field to attach your phone number for an external registration process"
  type        = string
  default     = null
}

variable "self_managed_opt_outs_enabled" {
  description = "When set to false an end recipient sends a message that begins with HELP or STOP to one of your dedicated numbers, AWS End User Messaging SMS and Voice automatically replies with a customizable message and adds the end recipient to the opt-out list. When set to true you're responsible for responding to HELP and STOP requests"
  type        = bool
  default     = null
}

variable "two_way_channel_arn" {
  description = "The Amazon Resource Name (ARN) of the two way channel"
  type        = string
  default     = null
}

variable "two_way_channel_enabled" {
  description = "When set to true you can receive incoming text messages from your end recipients"
  type        = bool
  default     = false
}

variable "two_way_channel_role" {
  description = "IAM Role ARN for a service to assume, to be able to post inbound SMS messages"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}