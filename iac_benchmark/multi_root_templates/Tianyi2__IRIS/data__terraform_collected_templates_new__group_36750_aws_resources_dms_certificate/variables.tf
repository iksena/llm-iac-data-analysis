variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "certificate_id" {
  description = "The certificate identifier."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.certificate_id)) && length(var.certificate_id) > 0
    error_message = "resource_aws_dms_certificate, certificate_id must be a non-empty string containing only alphanumeric characters and hyphens."
  }
}

variable "certificate_pem" {
  description = "The contents of the .pem X.509 certificate file for the certificate. Either certificate_pem or certificate_wallet must be set."
  type        = string
  default     = null

  validation {
    condition     = var.certificate_pem == null || (var.certificate_pem != null && length(var.certificate_pem) > 0)
    error_message = "resource_aws_dms_certificate, certificate_pem must be a non-empty string if provided."
  }
}

variable "certificate_wallet" {
  description = "The contents of the Oracle Wallet certificate for use with SSL, provided as a base64-encoded String. Either certificate_pem or certificate_wallet must be set."
  type        = string
  default     = null

  validation {
    condition     = var.certificate_wallet == null || (var.certificate_wallet != null && length(var.certificate_wallet) > 0)
    error_message = "resource_aws_dms_certificate, certificate_wallet must be a non-empty string if provided."
  }

  validation {
    condition     = var.certificate_wallet == null || can(base64decode(var.certificate_wallet))
    error_message = "resource_aws_dms_certificate, certificate_wallet must be a valid base64-encoded string if provided."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}