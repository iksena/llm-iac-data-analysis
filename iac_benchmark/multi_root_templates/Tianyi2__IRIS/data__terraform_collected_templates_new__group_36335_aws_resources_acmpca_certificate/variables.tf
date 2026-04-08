variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "certificate_authority_arn" {
  description = "ARN of the certificate authority."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm-pca:", var.certificate_authority_arn))
    error_message = "resource_acmpca_certificate, certificate_authority_arn must be a valid ACM PCA ARN starting with 'arn:aws:acm-pca:'."
  }
}

variable "certificate_signing_request" {
  description = "Certificate Signing Request in PEM format."
  type        = string

  validation {
    condition     = can(regex("-----BEGIN CERTIFICATE REQUEST-----", var.certificate_signing_request))
    error_message = "resource_acmpca_certificate, certificate_signing_request must be a valid PEM-encoded certificate signing request."
  }
}

variable "signing_algorithm" {
  description = "Algorithm to use to sign certificate requests."
  type        = string

  validation {
    condition = contains([
      "SHA256WITHRSA",
      "SHA256WITHECDSA",
      "SHA384WITHRSA",
      "SHA384WITHECDSA",
      "SHA512WITHRSA",
      "SHA512WITHECDSA"
    ], var.signing_algorithm)
    error_message = "resource_acmpca_certificate, signing_algorithm must be one of: SHA256WITHRSA, SHA256WITHECDSA, SHA384WITHRSA, SHA384WITHECDSA, SHA512WITHRSA, SHA512WITHECDSA."
  }
}

variable "validity" {
  description = "Configures end of the validity period for the certificate."
  type = object({
    type  = string
    value = string
  })

  validation {
    condition = contains([
      "DAYS",
      "MONTHS",
      "YEARS",
      "ABSOLUTE",
      "END_DATE"
    ], var.validity.type)
    error_message = "resource_acmpca_certificate, validity.type must be one of: DAYS, MONTHS, YEARS, ABSOLUTE, END_DATE."
  }

  validation {
    condition     = var.validity.value != null && var.validity.value != ""
    error_message = "resource_acmpca_certificate, validity.value must be provided and cannot be empty."
  }
}

variable "template_arn" {
  description = "Template to use when issuing a certificate."
  type        = string
  default     = null

  validation {
    condition     = var.template_arn == null || can(regex("^arn:aws:acm-pca:", var.template_arn))
    error_message = "resource_acmpca_certificate, template_arn must be a valid ACM PCA template ARN starting with 'arn:aws:acm-pca:' when provided."
  }
}

variable "api_passthrough" {
  description = "Specifies X.509 certificate information to be included in the issued certificate. To use with API Passthrough templates."
  type        = any
  default     = null
}