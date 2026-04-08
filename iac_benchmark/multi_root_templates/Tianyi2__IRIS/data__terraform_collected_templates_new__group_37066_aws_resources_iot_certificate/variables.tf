variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "active" {
  description = "Boolean flag to indicate if the certificate should be active"
  type        = bool

  validation {
    condition     = can(var.active)
    error_message = "resource_aws_iot_certificate, active must be a boolean value."
  }
}

variable "csr" {
  description = "The certificate signing request"
  type        = string
  default     = null

  validation {
    condition     = var.csr == null || can(regex("^-----BEGIN CERTIFICATE REQUEST-----", var.csr))
    error_message = "resource_aws_iot_certificate, csr must be a valid PEM formatted certificate signing request."
  }
}

variable "certificate_pem" {
  description = "The certificate to be registered"
  type        = string
  default     = null

  validation {
    condition     = var.certificate_pem == null || can(regex("^-----BEGIN CERTIFICATE-----", var.certificate_pem))
    error_message = "resource_aws_iot_certificate, certificate_pem must be a valid PEM formatted certificate."
  }
}

variable "ca_pem" {
  description = "The CA certificate for the certificate to be registered"
  type        = string
  default     = null

  validation {
    condition     = var.ca_pem == null || can(regex("^-----BEGIN CERTIFICATE-----", var.ca_pem))
    error_message = "resource_aws_iot_certificate, ca_pem must be a valid PEM formatted CA certificate."
  }
}