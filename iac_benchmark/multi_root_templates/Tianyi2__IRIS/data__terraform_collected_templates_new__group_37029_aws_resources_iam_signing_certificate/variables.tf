variable "certificate_body" {
  description = "The contents of the signing certificate in PEM-encoded format"
  type        = string

  validation {
    condition     = can(regex("^-----BEGIN CERTIFICATE-----", var.certificate_body))
    error_message = "resource_aws_iam_signing_certificate, certificate_body must be a valid PEM-encoded certificate starting with -----BEGIN CERTIFICATE-----."
  }

  validation {
    condition     = can(regex("-----END CERTIFICATE-----$", var.certificate_body))
    error_message = "resource_aws_iam_signing_certificate, certificate_body must be a valid PEM-encoded certificate ending with -----END CERTIFICATE-----."
  }
}

variable "status" {
  description = "The status you want to assign to the certificate. Active means that the certificate can be used for programmatic calls to Amazon Web Services. Inactive means that the certificate cannot be used"
  type        = string
  default     = "Active"

  validation {
    condition     = contains(["Active", "Inactive"], var.status)
    error_message = "resource_aws_iam_signing_certificate, status must be either 'Active' or 'Inactive'."
  }
}

variable "user_name" {
  description = "The name of the user the signing certificate is for"
  type        = string

  validation {
    condition     = length(var.user_name) > 0 && length(var.user_name) <= 128
    error_message = "resource_aws_iam_signing_certificate, user_name must be between 1 and 128 characters in length."
  }

  validation {
    condition     = can(regex("^[\\w+=,.@-]+$", var.user_name))
    error_message = "resource_aws_iam_signing_certificate, user_name must contain only alphanumeric characters and/or the following: +=,.@-."
  }
}