variable "account_id" {
  description = "The ID of the target account when managing member accounts. Will manage current user's account by default if omitted."
  type        = string
  default     = null
}

variable "address_line_1" {
  description = "The first line of the primary contact address."
  type        = string

  validation {
    condition     = length(var.address_line_1) > 0
    error_message = "resource_aws_account_primary_contact, address_line_1 must not be empty."
  }
}

variable "address_line_2" {
  description = "The second line of the primary contact address, if any."
  type        = string
  default     = null
}

variable "address_line_3" {
  description = "The third line of the primary contact address, if any."
  type        = string
  default     = null
}

variable "city" {
  description = "The city of the primary contact address."
  type        = string

  validation {
    condition     = length(var.city) > 0
    error_message = "resource_aws_account_primary_contact, city must not be empty."
  }
}

variable "company_name" {
  description = "The name of the company associated with the primary contact information, if any."
  type        = string
  default     = null
}

variable "country_code" {
  description = "The ISO-3166 two-letter country code for the primary contact address."
  type        = string

  validation {
    condition     = length(var.country_code) == 2
    error_message = "resource_aws_account_primary_contact, country_code must be a two-letter ISO-3166 country code."
  }
}

variable "district_or_county" {
  description = "The district or county of the primary contact address, if any."
  type        = string
  default     = null
}

variable "full_name" {
  description = "The full name of the primary contact address."
  type        = string

  validation {
    condition     = length(var.full_name) > 0
    error_message = "resource_aws_account_primary_contact, full_name must not be empty."
  }
}

variable "phone_number" {
  description = "The phone number of the primary contact information. The number will be validated and, in some countries, checked for activation."
  type        = string

  validation {
    condition     = length(var.phone_number) > 0
    error_message = "resource_aws_account_primary_contact, phone_number must not be empty."
  }
}

variable "postal_code" {
  description = "The postal code of the primary contact address."
  type        = string

  validation {
    condition     = length(var.postal_code) > 0
    error_message = "resource_aws_account_primary_contact, postal_code must not be empty."
  }
}

variable "state_or_region" {
  description = "The state or region of the primary contact address. This field is required in selected countries."
  type        = string
  default     = null
}

variable "website_url" {
  description = "The URL of the website associated with the primary contact information, if any."
  type        = string
  default     = null

  validation {
    condition     = var.website_url == null || can(regex("^https?://", var.website_url))
    error_message = "resource_aws_account_primary_contact, website_url must be a valid URL starting with http:// or https://."
  }
}