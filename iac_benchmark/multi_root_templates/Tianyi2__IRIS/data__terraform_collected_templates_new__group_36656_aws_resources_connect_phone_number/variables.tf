variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "country_code" {
  description = "The ISO country code. For a list of Valid values, refer to PhoneNumberCountryCode."
  type        = string
  validation {
    condition     = can(regex("^[A-Z]{2}$", var.country_code))
    error_message = "resource_aws_connect_phone_number, country_code must be a valid ISO country code (2 uppercase letters)."
  }
}

variable "description" {
  description = "The description of the phone number."
  type        = string
  default     = null
}

variable "prefix" {
  description = "The prefix of the phone number that is used to filter available phone numbers. If provided, it must contain + as part of the country code. Do not specify this argument when importing the resource."
  type        = string
  default     = null
  validation {
    condition     = var.prefix == null || can(regex("^\\+", var.prefix))
    error_message = "resource_aws_connect_phone_number, prefix must contain + as part of the country code when specified."
  }
}

variable "tags" {
  description = "Tags to apply to the Phone Number. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "target_arn" {
  description = "The Amazon Resource Name (ARN) for Amazon Connect instances that phone numbers are claimed to."
  type        = string
  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:connect:", var.target_arn))
    error_message = "resource_aws_connect_phone_number, target_arn must be a valid Amazon Connect instance ARN."
  }
}

variable "type" {
  description = "The type of phone number. Valid Values: TOLL_FREE | DID."
  type        = string
  validation {
    condition     = contains(["TOLL_FREE", "DID"], var.type)
    error_message = "resource_aws_connect_phone_number, type must be either TOLL_FREE or DID."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "2m")
    update = optional(string, "2m")
    delete = optional(string, "2m")
  })
  default = null
}