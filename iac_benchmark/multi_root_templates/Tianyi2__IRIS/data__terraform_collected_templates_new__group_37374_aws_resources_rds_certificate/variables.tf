variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_rds_certificate, region must be a valid AWS region format (e.g., us-west-2) or null to use provider default."
  }
}

variable "certificate_identifier" {
  description = "Certificate identifier. For example, rds-ca-rsa4096-g1. Refer to AWS RDS Certificate Identifier documentation for more information."
  type        = string

  validation {
    condition     = length(var.certificate_identifier) > 0
    error_message = "resource_aws_rds_certificate, certificate_identifier cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.certificate_identifier))
    error_message = "resource_aws_rds_certificate, certificate_identifier must contain only alphanumeric characters and hyphens."
  }
}