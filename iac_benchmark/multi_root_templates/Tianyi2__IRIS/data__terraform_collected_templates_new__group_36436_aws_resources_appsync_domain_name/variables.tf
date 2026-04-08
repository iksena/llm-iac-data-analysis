variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "certificate_arn" {
  description = "ARN of the certificate. This can be an Certificate Manager (ACM) certificate or an Identity and Access Management (IAM) server certificate. The certificate must reside in us-east-1."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm:us-east-1:[0-9]{12}:certificate/[a-f0-9-]+$|^arn:aws:iam::[0-9]{12}:server-certificate/.+$", var.certificate_arn))
    error_message = "resource_aws_appsync_domain_name, certificate_arn must be a valid ACM certificate ARN in us-east-1 or IAM server certificate ARN."
  }
}

variable "description" {
  description = "A description of the Domain Name."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\\.([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?))*$", var.domain_name))
    error_message = "resource_aws_appsync_domain_name, domain_name must be a valid domain name format."
  }

  validation {
    condition     = length(var.domain_name) <= 253
    error_message = "resource_aws_appsync_domain_name, domain_name must be 253 characters or less."
  }
}