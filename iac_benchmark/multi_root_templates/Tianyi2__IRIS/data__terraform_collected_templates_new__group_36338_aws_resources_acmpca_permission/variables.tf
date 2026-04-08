variable "certificate_authority_arn" {
  description = "ARN of the CA that grants the permissions"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm-pca:", var.certificate_authority_arn))
    error_message = "resource_aws_acmpca_permission, certificate_authority_arn must be a valid ACM PCA ARN starting with 'arn:aws:acm-pca:'"
  }
}

variable "actions" {
  description = "Actions that the specified AWS service principal can use. These include IssueCertificate, GetCertificate, and ListPermissions"
  type        = list(string)

  validation {
    condition = length(var.actions) > 0 && alltrue([
      for action in var.actions : contains(["IssueCertificate", "GetCertificate", "ListPermissions"], action)
    ])
    error_message = "resource_aws_acmpca_permission, actions must be a non-empty list containing only 'IssueCertificate', 'GetCertificate', and/or 'ListPermissions'"
  }
}

variable "principal" {
  description = "AWS service or identity that receives the permission. At this time, the only valid principal is acm.amazonaws.com"
  type        = string

  validation {
    condition     = var.principal == "acm.amazonaws.com"
    error_message = "resource_aws_acmpca_permission, principal must be 'acm.amazonaws.com' - this is currently the only valid principal"
  }
}

variable "source_account" {
  description = "ID of the calling account"
  type        = string
  default     = null

  validation {
    condition     = var.source_account == null || can(regex("^[0-9]{12}$", var.source_account))
    error_message = "resource_aws_acmpca_permission, source_account must be a valid 12-digit AWS account ID"
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_acmpca_permission, region must be a valid AWS region identifier (e.g., us-east-1, eu-west-1)"
  }
}