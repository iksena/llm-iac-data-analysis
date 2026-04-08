variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "active" {
  description = "Boolean flag to indicate if the certificate should be active for device authentication"
  type        = bool

  validation {
    condition     = var.active != null
    error_message = "resource_aws_iot_ca_certificate, active is required and cannot be null."
  }
}

variable "allow_auto_registration" {
  description = "Boolean flag to indicate if the certificate should be active for device registration"
  type        = bool

  validation {
    condition     = var.allow_auto_registration != null
    error_message = "resource_aws_iot_ca_certificate, allow_auto_registration is required and cannot be null."
  }
}

variable "ca_certificate_pem" {
  description = "PEM encoded CA certificate"
  type        = string

  validation {
    condition     = var.ca_certificate_pem != null && var.ca_certificate_pem != ""
    error_message = "resource_aws_iot_ca_certificate, ca_certificate_pem is required and cannot be empty."
  }
}

variable "certificate_mode" {
  description = "The certificate mode in which the CA will be registered"
  type        = string
  default     = "DEFAULT"

  validation {
    condition     = contains(["DEFAULT", "SNI_ONLY"], var.certificate_mode)
    error_message = "resource_aws_iot_ca_certificate, certificate_mode must be either 'DEFAULT' or 'SNI_ONLY'."
  }
}

variable "verification_certificate_pem" {
  description = "PEM encoded verification certificate containing the common name of a registration code"
  type        = string
  default     = null

  validation {
    condition     = var.certificate_mode != "DEFAULT" || var.verification_certificate_pem != null
    error_message = "resource_aws_iot_ca_certificate, verification_certificate_pem is required when certificate_mode is 'DEFAULT'."
  }
}

variable "registration_config" {
  description = "Information about the registration configuration"
  type = object({
    role_arn      = optional(string)
    template_body = optional(string)
    template_name = optional(string)
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}