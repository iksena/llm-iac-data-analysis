variable "account_id" {
  description = "AWS account identifier to designate as a delegated administrator for Detective"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_detective_organization_admin_account, account_id must be a valid 12-digit AWS account ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_detective_organization_admin_account, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}