variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "certificate_authority_configuration" {
  description = "Nested argument containing algorithms and certificate subject information."
  type = object({
    key_algorithm     = string
    signing_algorithm = string
    subject = object({
      common_name                  = optional(string)
      country                      = optional(string)
      distinguished_name_qualifier = optional(string)
      generation_qualifier         = optional(string)
      given_name                   = optional(string)
      initials                     = optional(string)
      locality                     = optional(string)
      organization                 = optional(string)
      organizational_unit          = optional(string)
      pseudonym                    = optional(string)
      state                        = optional(string)
      surname                      = optional(string)
      title                        = optional(string)
    })
  })
  default = null
}

variable "key_algorithm" {
  description = "Type of the public key algorithm and size, in bits, of the key pair that your key pair creates when it issues a certificate."
  type        = string
}

variable "signing_algorithm" {
  description = "Name of the algorithm your private CA uses to sign certificate requests."
  type        = string
}

variable "common_name" {
  description = "Fully qualified domain name (FQDN) associated with the certificate subject."
  type        = string
  default     = null
  validation {
    condition     = var.common_name == null || length(var.common_name) <= 64
    error_message = "resource_aws_acmpca_certificate_authority, common_name must be less than or equal to 64 characters in length."
  }
}

variable "country" {
  description = "Two digit code that specifies the country in which the certificate subject located."
  type        = string
  default     = null
  validation {
    condition     = var.country == null || length(var.country) <= 2
    error_message = "resource_aws_acmpca_certificate_authority, country must be less than or equal to 2 characters in length."
  }
}

variable "distinguished_name_qualifier" {
  description = "Disambiguating information for the certificate subject."
  type        = string
  default     = null
  validation {
    condition     = var.distinguished_name_qualifier == null || length(var.distinguished_name_qualifier) <= 64
    error_message = "resource_aws_acmpca_certificate_authority, distinguished_name_qualifier must be less than or equal to 64 characters in length."
  }
}

variable "generation_qualifier" {
  description = "Typically a qualifier appended to the name of an individual. Examples include Jr. for junior, Sr. for senior, and III for third."
  type        = string
  default     = null
  validation {
    condition     = var.generation_qualifier == null || length(var.generation_qualifier) <= 3
    error_message = "resource_aws_acmpca_certificate_authority, generation_qualifier must be less than or equal to 3 characters in length."
  }
}

variable "given_name" {
  description = "First name."
  type        = string
  default     = null
  validation {
    condition     = var.given_name == null || length(var.given_name) <= 16
    error_message = "resource_aws_acmpca_certificate_authority, given_name must be less than or equal to 16 characters in length."
  }
}

variable "initials" {
  description = "Concatenation that typically contains the first letter of the given_name, the first letter of the middle name if one exists, and the first letter of the surname."
  type        = string
  default     = null
  validation {
    condition     = var.initials == null || length(var.initials) <= 5
    error_message = "resource_aws_acmpca_certificate_authority, initials must be less than or equal to 5 characters in length."
  }
}

variable "locality" {
  description = "Locality (such as a city or town) in which the certificate subject is located."
  type        = string
  default     = null
  validation {
    condition     = var.locality == null || length(var.locality) <= 128
    error_message = "resource_aws_acmpca_certificate_authority, locality must be less than or equal to 128 characters in length."
  }
}

variable "organization" {
  description = "Legal name of the organization with which the certificate subject is affiliated."
  type        = string
  default     = null
  validation {
    condition     = var.organization == null || length(var.organization) <= 64
    error_message = "resource_aws_acmpca_certificate_authority, organization must be less than or equal to 64 characters in length."
  }
}

variable "organizational_unit" {
  description = "Subdivision or unit of the organization (such as sales or finance) with which the certificate subject is affiliated."
  type        = string
  default     = null
  validation {
    condition     = var.organizational_unit == null || length(var.organizational_unit) <= 64
    error_message = "resource_aws_acmpca_certificate_authority, organizational_unit must be less than or equal to 64 characters in length."
  }
}

variable "pseudonym" {
  description = "Typically a shortened version of a longer given_name. For example, Jonathan is often shortened to John. Elizabeth is often shortened to Beth, Liz, or Eliza."
  type        = string
  default     = null
  validation {
    condition     = var.pseudonym == null || length(var.pseudonym) <= 128
    error_message = "resource_aws_acmpca_certificate_authority, pseudonym must be less than or equal to 128 characters in length."
  }
}

variable "state" {
  description = "State in which the subject of the certificate is located."
  type        = string
  default     = null
  validation {
    condition     = var.state == null || length(var.state) <= 128
    error_message = "resource_aws_acmpca_certificate_authority, state must be less than or equal to 128 characters in length."
  }
}

variable "surname" {
  description = "Family name. In the US and the UK for example, the surname of an individual is ordered last. In Asian cultures the surname is typically ordered first."
  type        = string
  default     = null
  validation {
    condition     = var.surname == null || length(var.surname) <= 40
    error_message = "resource_aws_acmpca_certificate_authority, surname must be less than or equal to 40 characters in length."
  }
}

variable "title" {
  description = "Title such as Mr. or Ms. which is pre-pended to the name to refer formally to the certificate subject."
  type        = string
  default     = null
  validation {
    condition     = var.title == null || length(var.title) <= 64
    error_message = "resource_aws_acmpca_certificate_authority, title must be less than or equal to 64 characters in length."
  }
}

variable "enabled" {
  description = "Whether the certificate authority is enabled or disabled. Defaults to true. Can only be disabled if the CA is in an ACTIVE state."
  type        = bool
  default     = true
}

variable "revocation_configuration" {
  description = "Nested argument containing revocation configuration."
  type = object({
    crl_configuration = optional(object({
      custom_cname       = optional(string)
      enabled            = optional(bool, false)
      expiration_in_days = optional(number)
      s3_bucket_name     = optional(string)
      s3_object_acl      = optional(string, "PUBLIC_READ")
    }))
    ocsp_configuration = optional(object({
      enabled           = bool
      ocsp_custom_cname = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.revocation_configuration == null || (
      var.revocation_configuration.crl_configuration == null ||
      var.revocation_configuration.crl_configuration.custom_cname == null ||
      length(var.revocation_configuration.crl_configuration.custom_cname) <= 253
    )
    error_message = "resource_aws_acmpca_certificate_authority, custom_cname must be less than or equal to 253 characters in length."
  }

  validation {
    condition = var.revocation_configuration == null || (
      var.revocation_configuration.crl_configuration == null ||
      !var.revocation_configuration.crl_configuration.enabled ||
      (var.revocation_configuration.crl_configuration.expiration_in_days != null &&
        var.revocation_configuration.crl_configuration.expiration_in_days >= 1 &&
      var.revocation_configuration.crl_configuration.expiration_in_days <= 5000)
    )
    error_message = "resource_aws_acmpca_certificate_authority, expiration_in_days must be between 1 and 5000."
  }

  validation {
    condition = var.revocation_configuration == null || (
      var.revocation_configuration.crl_configuration == null ||
      !var.revocation_configuration.crl_configuration.enabled ||
      var.revocation_configuration.crl_configuration.s3_bucket_name != null
    )
    error_message = "resource_aws_acmpca_certificate_authority, s3_bucket_name is required when CRL is enabled."
  }

  validation {
    condition = var.revocation_configuration == null || (
      var.revocation_configuration.crl_configuration == null ||
      var.revocation_configuration.crl_configuration.s3_bucket_name == null ||
      (length(var.revocation_configuration.crl_configuration.s3_bucket_name) >= 3 &&
      length(var.revocation_configuration.crl_configuration.s3_bucket_name) <= 255)
    )
    error_message = "resource_aws_acmpca_certificate_authority, s3_bucket_name must be between 3 and 255 characters in length."
  }
}

variable "usage_mode" {
  description = "Specifies whether the CA issues general-purpose certificates that typically require a revocation mechanism, or short-lived certificates that may optionally omit revocation because they expire quickly."
  type        = string
  default     = "GENERAL_PURPOSE"
  validation {
    condition     = contains(["GENERAL_PURPOSE", "SHORT_LIVED_CERTIFICATE"], var.usage_mode)
    error_message = "resource_aws_acmpca_certificate_authority, usage_mode must be either GENERAL_PURPOSE or SHORT_LIVED_CERTIFICATE."
  }
}

variable "tags" {
  description = "Key-value map of user-defined tags that are attached to the certificate authority."
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "Type of the certificate authority. Defaults to SUBORDINATE."
  type        = string
  default     = "SUBORDINATE"
  validation {
    condition     = contains(["ROOT", "SUBORDINATE"], var.type)
    error_message = "resource_aws_acmpca_certificate_authority, type must be either ROOT or SUBORDINATE."
  }
}

variable "key_storage_security_standard" {
  description = "Cryptographic key management compliance standard used for handling CA keys."
  type        = string
  default     = "FIPS_140_2_LEVEL_3_OR_HIGHER"
  validation {
    condition     = contains(["FIPS_140_2_LEVEL_3_OR_HIGHER", "FIPS_140_2_LEVEL_2_OR_HIGHER"], var.key_storage_security_standard)
    error_message = "resource_aws_acmpca_certificate_authority, key_storage_security_standard must be either FIPS_140_2_LEVEL_3_OR_HIGHER or FIPS_140_2_LEVEL_2_OR_HIGHER."
  }
}

variable "permanent_deletion_time_in_days" {
  description = "Number of days to make a CA restorable after it has been deleted, must be between 7 to 30 days, with default to 30 days."
  type        = number
  default     = 30
  validation {
    condition     = var.permanent_deletion_time_in_days >= 7 && var.permanent_deletion_time_in_days <= 30
    error_message = "resource_aws_acmpca_certificate_authority, permanent_deletion_time_in_days must be between 7 to 30 days."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the certificate authority."
  type        = string
  default     = "1m"
}