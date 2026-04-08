variable "certificate_id" {
  description = "A customer-assigned name for the certificate. Identifiers must begin with a letter and must contain only ASCII letters, digits, and hyphens. They can't end with a hyphen or contain two consecutive hyphens."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z]([a-zA-Z0-9-]*[a-zA-Z0-9])?$", var.certificate_id)) && !can(regex("--", var.certificate_id))
    error_message = "data_aws_dms_certificate, certificate_id must begin with a letter, contain only ASCII letters, digits, and hyphens, cannot end with a hyphen, and cannot contain two consecutive hyphens."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}