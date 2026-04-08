variable "arn" {
  description = "ARN of the certificate authority"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm-pca:", var.arn))
    error_message = "data_aws_acmpca_certificate_authority, arn must be a valid ACM PCA certificate authority ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_acmpca_certificate_authority, region must be a valid AWS region identifier."
  }
}