variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "certificate" {
  description = "PEM-encoded certificate for the Certificate Authority."
  type        = string

  validation {
    condition     = can(regex("^-----BEGIN CERTIFICATE-----", var.certificate))
    error_message = "resource_aws_acmpca_certificate_authority_certificate, certificate must be a valid PEM-encoded certificate starting with '-----BEGIN CERTIFICATE-----'."
  }
}

variable "certificate_authority_arn" {
  description = "ARN of the Certificate Authority."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:acm-pca:[a-z0-9-]+:[0-9]{12}:certificate-authority/[a-f0-9-]+$", var.certificate_authority_arn))
    error_message = "resource_aws_acmpca_certificate_authority_certificate, certificate_authority_arn must be a valid ACM PCA Certificate Authority ARN."
  }
}

variable "certificate_chain" {
  description = "PEM-encoded certificate chain that includes any intermediate certificates and chains up to root CA. Required for subordinate Certificate Authorities. Not allowed for root Certificate Authorities."
  type        = string
  default     = null

  validation {
    condition     = var.certificate_chain == null || can(regex("^-----BEGIN CERTIFICATE-----", var.certificate_chain))
    error_message = "resource_aws_acmpca_certificate_authority_certificate, certificate_chain must be null or a valid PEM-encoded certificate chain starting with '-----BEGIN CERTIFICATE-----'."
  }
}