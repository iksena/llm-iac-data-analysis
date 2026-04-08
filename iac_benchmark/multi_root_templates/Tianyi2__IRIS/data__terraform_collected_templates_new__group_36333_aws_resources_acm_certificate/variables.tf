variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Domain name for which the certificate should be issued"
  type        = string
  default     = null
}

variable "subject_alternative_names" {
  description = "Set of domains that should be SANs in the issued certificate"
  type        = set(string)
  default     = null
}

variable "validation_method" {
  description = "Which method to use for validation. DNS or EMAIL are valid"
  type        = string
  default     = null
  validation {
    condition     = var.validation_method == null || contains(["DNS", "EMAIL"], var.validation_method)
    error_message = "resource_aws_acm_certificate, validation_method must be either DNS or EMAIL."
  }
}

variable "key_algorithm" {
  description = "Specifies the algorithm of the public and private key pair that your Amazon issued certificate uses to encrypt data"
  type        = string
  default     = null
}

variable "options" {
  description = "Configuration block used to set certificate options"
  type = object({
    certificate_transparency_logging_preference = optional(string)
    export                                      = optional(string)
  })
  default = null
  validation {
    condition = var.options == null || (
      (var.options.certificate_transparency_logging_preference == null || contains(["ENABLED", "DISABLED"], var.options.certificate_transparency_logging_preference)) &&
      (var.options.export == null || contains(["ENABLED", "DISABLED"], var.options.export))
    )
    error_message = "resource_aws_acm_certificate, options.certificate_transparency_logging_preference must be ENABLED or DISABLED and options.export must be ENABLED or DISABLED."
  }
}

variable "validation_option" {
  description = "Configuration block used to specify information about the initial validation of each domain name"
  type = list(object({
    domain_name       = string
    validation_domain = string
  }))
  default = null
}

variable "private_key" {
  description = "Certificate's PEM-formatted private key"
  type        = string
  default     = null
  sensitive   = true
}

variable "certificate_body" {
  description = "Certificate's PEM-formatted public key"
  type        = string
  default     = null
}

variable "certificate_chain" {
  description = "Certificate's PEM-formatted chain"
  type        = string
  default     = null
}

variable "certificate_authority_arn" {
  description = "ARN of an ACM PCA"
  type        = string
  default     = null
  validation {
    condition     = var.certificate_authority_arn == null || can(regex("^arn:aws:acm-pca:", var.certificate_authority_arn))
    error_message = "resource_aws_acm_certificate, certificate_authority_arn must be a valid ACM PCA ARN."
  }
}

variable "early_renewal_duration" {
  description = "Amount of time to start automatic renewal process before expiration"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}