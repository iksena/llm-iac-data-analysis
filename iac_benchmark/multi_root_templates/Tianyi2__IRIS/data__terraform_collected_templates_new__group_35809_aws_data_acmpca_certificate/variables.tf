variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "ARN of the certificate issued by the private certificate authority."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm-pca:", var.arn))
    error_message = "data_aws_acmpca_certificate, arn must be a valid AWS ACM PCA certificate ARN starting with 'arn:aws:acm-pca:'."
  }
}

variable "certificate_authority_arn" {
  description = "ARN of the certificate authority."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm-pca:", var.certificate_authority_arn))
    error_message = "data_aws_acmpca_certificate, certificate_authority_arn must be a valid AWS ACM PCA certificate authority ARN starting with 'arn:aws:acm-pca:'."
  }
}