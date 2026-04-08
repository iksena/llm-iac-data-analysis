variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_licensemanager_grant_accepter, region must be a valid AWS region identifier."
  }
}

variable "grant_arn" {
  description = "The ARN of the grant to accept."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:license-manager:.*:.*:grant:.*$", var.grant_arn))
    error_message = "resource_aws_licensemanager_grant_accepter, grant_arn must be a valid License Manager grant ARN."
  }
}