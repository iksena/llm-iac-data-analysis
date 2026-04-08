variable "enabled" {
  description = "Whether or not the Trust Anchor should be enabled"
  type        = bool
  default     = null
}

variable "name" {
  description = "The name of the Trust Anchor"
  type        = string
}

variable "source_type" {
  description = "The type of the source of trust"
  type        = string

  validation {
    condition     = contains(["AWS_ACM_PCA", "CERTIFICATE_BUNDLE"], var.source_type)
    error_message = "resource_aws_rolesanywhere_trust_anchor, source_type must be either 'AWS_ACM_PCA' or 'CERTIFICATE_BUNDLE'."
  }
}

variable "acm_pca_arn" {
  description = "The ARN of an ACM Private Certificate Authority. Required when source_type is AWS_ACM_PCA"
  type        = string
  default     = null

  validation {
    condition     = var.source_type == "AWS_ACM_PCA" ? var.acm_pca_arn != null : true
    error_message = "resource_aws_rolesanywhere_trust_anchor, acm_pca_arn is required when source_type is 'AWS_ACM_PCA'."
  }

  validation {
    condition     = var.source_type == "CERTIFICATE_BUNDLE" ? var.acm_pca_arn == null : true
    error_message = "resource_aws_rolesanywhere_trust_anchor, acm_pca_arn must be null when source_type is 'CERTIFICATE_BUNDLE'."
  }
}

variable "x509_certificate_data" {
  description = "The X.509 certificate data. Required when source_type is CERTIFICATE_BUNDLE"
  type        = string
  default     = null

  validation {
    condition     = var.source_type == "CERTIFICATE_BUNDLE" ? var.x509_certificate_data != null : true
    error_message = "resource_aws_rolesanywhere_trust_anchor, x509_certificate_data is required when source_type is 'CERTIFICATE_BUNDLE'."
  }

  validation {
    condition     = var.source_type == "AWS_ACM_PCA" ? var.x509_certificate_data == null : true
    error_message = "resource_aws_rolesanywhere_trust_anchor, x509_certificate_data must be null when source_type is 'AWS_ACM_PCA'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}