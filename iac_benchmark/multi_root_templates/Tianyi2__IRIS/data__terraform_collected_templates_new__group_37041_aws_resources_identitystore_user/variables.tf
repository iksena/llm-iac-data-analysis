variable "display_name" {
  description = "The name that is typically displayed when the user is referenced."
  type        = string

  validation {
    condition     = length(var.display_name) <= 1024
    error_message = "resource_aws_identitystore_user, display_name must be 1024 characters or fewer."
  }
}

variable "identity_store_id" {
  description = "The globally unique identifier for the identity store that this user is in."
  type        = string
}

variable "user_name" {
  description = "A unique string used to identify the user. This value can consist of letters, accented characters, symbols, numbers, and punctuation. This value is specified at the time the user is created and stored as an attribute of the user object in the identity store. The limit is 128 characters."
  type        = string

  validation {
    condition     = length(var.user_name) <= 128
    error_message = "resource_aws_identitystore_user, user_name must be 128 characters or fewer."
  }
}

variable "name" {
  description = "Details about the user's full name."
  type = object({
    family_name      = string
    given_name       = string
    formatted        = optional(string)
    honorific_prefix = optional(string)
    honorific_suffix = optional(string)
    middle_name      = optional(string)
  })

  validation {
    condition     = length(var.name.family_name) <= 1024
    error_message = "resource_aws_identitystore_user, name.family_name must be 1024 characters or fewer."
  }

  validation {
    condition     = length(var.name.given_name) <= 1024
    error_message = "resource_aws_identitystore_user, name.given_name must be 1024 characters or fewer."
  }

  validation {
    condition     = var.name.formatted == null || length(var.name.formatted) <= 1024
    error_message = "resource_aws_identitystore_user, name.formatted must be 1024 characters or fewer."
  }

  validation {
    condition     = var.name.honorific_prefix == null || length(var.name.honorific_prefix) <= 1024
    error_message = "resource_aws_identitystore_user, name.honorific_prefix must be 1024 characters or fewer."
  }

  validation {
    condition     = var.name.honorific_suffix == null || length(var.name.honorific_suffix) <= 1024
    error_message = "resource_aws_identitystore_user, name.honorific_suffix must be 1024 characters or fewer."
  }

  validation {
    condition     = var.name.middle_name == null || length(var.name.middle_name) <= 1024
    error_message = "resource_aws_identitystore_user, name.middle_name must be 1024 characters or fewer."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "addresses" {
  description = "Details about the user's address. At most 1 address is allowed."
  type = object({
    country        = optional(string)
    formatted      = optional(string)
    locality       = optional(string)
    postal_code    = optional(string)
    primary        = optional(bool)
    region         = optional(string)
    street_address = optional(string)
    type           = optional(string)
  })
  default = null

  validation {
    condition     = var.addresses == null || var.addresses.country == null || length(var.addresses.country) <= 1024
    error_message = "resource_aws_identitystore_user, addresses.country must be 1024 characters or fewer."
  }

  validation {
    condition     = var.addresses == null || var.addresses.formatted == null || length(var.addresses.formatted) <= 1024
    error_message = "resource_aws_identitystore_user, addresses.formatted must be 1024 characters or fewer."
  }

  validation {
    condition     = var.addresses == null || var.addresses.locality == null || length(var.addresses.locality) <= 1024
    error_message = "resource_aws_identitystore_user, addresses.locality must be 1024 characters or fewer."
  }

  validation {
    condition     = var.addresses == null || var.addresses.postal_code == null || length(var.addresses.postal_code) <= 1024
    error_message = "resource_aws_identitystore_user, addresses.postal_code must be 1024 characters or fewer."
  }

  validation {
    condition     = var.addresses == null || var.addresses.region == null || length(var.addresses.region) <= 1024
    error_message = "resource_aws_identitystore_user, addresses.region must be 1024 characters or fewer."
  }

  validation {
    condition     = var.addresses == null || var.addresses.street_address == null || length(var.addresses.street_address) <= 1024
    error_message = "resource_aws_identitystore_user, addresses.street_address must be 1024 characters or fewer."
  }

  validation {
    condition     = var.addresses == null || var.addresses.type == null || length(var.addresses.type) <= 1024
    error_message = "resource_aws_identitystore_user, addresses.type must be 1024 characters or fewer."
  }
}

variable "emails" {
  description = "Details about the user's email. At most 1 email is allowed."
  type = object({
    primary = optional(bool)
    type    = optional(string)
    value   = optional(string)
  })
  default = null

  validation {
    condition     = var.emails == null || var.emails.type == null || length(var.emails.type) <= 1024
    error_message = "resource_aws_identitystore_user, emails.type must be 1024 characters or fewer."
  }

  validation {
    condition     = var.emails == null || var.emails.value == null || length(var.emails.value) <= 1024
    error_message = "resource_aws_identitystore_user, emails.value must be 1024 characters or fewer."
  }
}

variable "locale" {
  description = "The user's geographical region or location."
  type        = string
  default     = null

  validation {
    condition     = var.locale == null || length(var.locale) <= 1024
    error_message = "resource_aws_identitystore_user, locale must be 1024 characters or fewer."
  }
}

variable "nickname" {
  description = "An alternate name for the user."
  type        = string
  default     = null

  validation {
    condition     = var.nickname == null || length(var.nickname) <= 1024
    error_message = "resource_aws_identitystore_user, nickname must be 1024 characters or fewer."
  }
}

variable "phone_numbers" {
  description = "Details about the user's phone number. At most 1 phone number is allowed."
  type = object({
    primary = optional(bool)
    type    = optional(string)
    value   = optional(string)
  })
  default = null

  validation {
    condition     = var.phone_numbers == null || var.phone_numbers.type == null || length(var.phone_numbers.type) <= 1024
    error_message = "resource_aws_identitystore_user, phone_numbers.type must be 1024 characters or fewer."
  }

  validation {
    condition     = var.phone_numbers == null || var.phone_numbers.value == null || length(var.phone_numbers.value) <= 1024
    error_message = "resource_aws_identitystore_user, phone_numbers.value must be 1024 characters or fewer."
  }
}

variable "preferred_language" {
  description = "The preferred language of the user."
  type        = string
  default     = null

  validation {
    condition     = var.preferred_language == null || length(var.preferred_language) <= 1024
    error_message = "resource_aws_identitystore_user, preferred_language must be 1024 characters or fewer."
  }
}

variable "profile_url" {
  description = "An URL that may be associated with the user."
  type        = string
  default     = null

  validation {
    condition     = var.profile_url == null || length(var.profile_url) <= 1024
    error_message = "resource_aws_identitystore_user, profile_url must be 1024 characters or fewer."
  }
}

variable "timezone" {
  description = "The user's time zone."
  type        = string
  default     = null

  validation {
    condition     = var.timezone == null || length(var.timezone) <= 1024
    error_message = "resource_aws_identitystore_user, timezone must be 1024 characters or fewer."
  }
}

variable "title" {
  description = "The user's title."
  type        = string
  default     = null

  validation {
    condition     = var.title == null || length(var.title) <= 1024
    error_message = "resource_aws_identitystore_user, title must be 1024 characters or fewer."
  }
}

variable "user_type" {
  description = "The user type."
  type        = string
  default     = null

  validation {
    condition     = var.user_type == null || length(var.user_type) <= 1024
    error_message = "resource_aws_identitystore_user, user_type must be 1024 characters or fewer."
  }
}