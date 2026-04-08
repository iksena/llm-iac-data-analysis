variable "domain_name" {
  description = "The name of your Customer Profile domain. It must be unique for your AWS account."
  type        = string

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "resource_aws_customerprofiles_profile, domain_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account_number" {
  description = "A unique account number that you have given to the customer."
  type        = string
  default     = null
}

variable "additional_information" {
  description = "Any additional information relevant to the customer's profile."
  type        = string
  default     = null
}

variable "address" {
  description = "A generic address associated with the customer that is not mailing, shipping, or billing."
  type = object({
    address_1   = optional(string)
    address_2   = optional(string)
    address_3   = optional(string)
    address_4   = optional(string)
    city        = optional(string)
    country     = optional(string)
    county      = optional(string)
    postal_code = optional(string)
    province    = optional(string)
    state       = optional(string)
  })
  default = null
}

variable "attributes" {
  description = "A key value pair of attributes of a customer profile."
  type        = map(string)
  default     = {}
}

variable "billing_address" {
  description = "The customer's billing address."
  type = object({
    address_1   = optional(string)
    address_2   = optional(string)
    address_3   = optional(string)
    address_4   = optional(string)
    city        = optional(string)
    country     = optional(string)
    county      = optional(string)
    postal_code = optional(string)
    province    = optional(string)
    state       = optional(string)
  })
  default = null
}

variable "birth_date" {
  description = "The customer's birth date."
  type        = string
  default     = null
}

variable "business_email_address" {
  description = "The customer's business email address."
  type        = string
  default     = null

  validation {
    condition     = var.business_email_address == null || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.business_email_address))
    error_message = "resource_aws_customerprofiles_profile, business_email_address must be a valid email address."
  }
}

variable "business_name" {
  description = "The name of the customer's business."
  type        = string
  default     = null
}

variable "business_phone_number" {
  description = "The customer's business phone number."
  type        = string
  default     = null
}

variable "email_address" {
  description = "The customer's email address, which has not been specified as a personal or business address."
  type        = string
  default     = null

  validation {
    condition     = var.email_address == null || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email_address))
    error_message = "resource_aws_customerprofiles_profile, email_address must be a valid email address."
  }
}

variable "first_name" {
  description = "The customer's first name."
  type        = string
  default     = null
}

variable "gender_string" {
  description = "The gender with which the customer identifies."
  type        = string
  default     = null
}

variable "home_phone_number" {
  description = "The customer's home phone number."
  type        = string
  default     = null
}

variable "last_name" {
  description = "The customer's last name."
  type        = string
  default     = null
}

variable "mailing_address" {
  description = "The customer's mailing address."
  type = object({
    address_1   = optional(string)
    address_2   = optional(string)
    address_3   = optional(string)
    address_4   = optional(string)
    city        = optional(string)
    country     = optional(string)
    county      = optional(string)
    postal_code = optional(string)
    province    = optional(string)
    state       = optional(string)
  })
  default = null
}

variable "middle_name" {
  description = "The customer's middle name."
  type        = string
  default     = null
}

variable "mobile_phone_number" {
  description = "The customer's mobile phone number."
  type        = string
  default     = null
}

variable "party_type_string" {
  description = "The type of profile used to describe the customer."
  type        = string
  default     = null
}

variable "personal_email_address" {
  description = "The customer's personal email address."
  type        = string
  default     = null

  validation {
    condition     = var.personal_email_address == null || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.personal_email_address))
    error_message = "resource_aws_customerprofiles_profile, personal_email_address must be a valid email address."
  }
}

variable "phone_number" {
  description = "The customer's phone number, which has not been specified as a mobile, home, or business number."
  type        = string
  default     = null
}

variable "shipping_address" {
  description = "The customer's shipping address."
  type = object({
    address_1   = optional(string)
    address_2   = optional(string)
    address_3   = optional(string)
    address_4   = optional(string)
    city        = optional(string)
    country     = optional(string)
    county      = optional(string)
    postal_code = optional(string)
    province    = optional(string)
    state       = optional(string)
  })
  default = null
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}